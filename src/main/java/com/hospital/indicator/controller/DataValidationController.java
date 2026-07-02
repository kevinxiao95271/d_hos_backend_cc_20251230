package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.entity.IndicatorResult;
import com.hospital.indicator.mapper.IndicatorMapper;
import com.hospital.indicator.mapper.IndicatorResultMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;

/**
 * 数据质检接口
 * <p>
 * 对已计算的指标结果与配置的目标值/监测方向做合规校验。
 * 校验规则：
 *   INCREASE  - 结果 >= 目标值 → PASS（逐步提高型，低于目标为异常）
 *   DECREASE  - 结果 <= 目标值 → PASS（逐步降低型，高于目标为异常）
 *   MONITOR   - 仅监测，不判断合规，状态为 MONITOR
 *   无目标值   - 状态为 NO_TARGET
 */
@Tag(name = "数据质检", description = "指标结果合规性质检（基于目标值与监测方向）")
@RestController
@RequestMapping("/api/data-validation")
public class DataValidationController {

    @Autowired
    private IndicatorMapper indicatorMapper;

    @Autowired
    private IndicatorResultMapper indicatorResultMapper;

    // -------------------------------------------------------------------------
    // POST /api/data-validation/check
    // -------------------------------------------------------------------------
    @Operation(summary = "触发数据质检",
               description = "对指定时间维度/时间值的指标结果做合规校验。\n\n"
                   + "**参数（均可选）**：\n"
                   + "- `timeDimension`：YEAR/MONTH/QUARTER（空则取各指标最新一条结果）\n"
                   + "- `timeValue`：如 2020、2020-01（与 timeDimension 配套）\n"
                   + "- `metricCodes`：指定指标编码列表（空则检查全部叶子指标）\n\n"
                   + "**返回 issues 说明**：\n"
                   + "- `status=PASS`：达标\n"
                   + "- `status=FAIL`：不达标（result 超出目标值范围）\n"
                   + "- `status=MONITOR`：监测型指标，无合规判断\n"
                   + "- `status=NO_TARGET`：未配置目标值\n"
                   + "- `status=NO_RESULT`：该时间段无计算结果")
    @PostMapping("/check")
    public Result<Map<String, Object>> check(@RequestBody(required = false) Map<String, Object> params) {
        String timeDimension = params != null ? (String) params.get("timeDimension") : null;
        String timeValue      = params != null ? (String) params.get("timeValue")     : null;
        @SuppressWarnings("unchecked")
        List<String> metricCodes = params != null ? (List<String>) params.get("metricCodes") : null;

        // 1. 查询叶子指标
        LambdaQueryWrapper<Indicator> iw = new LambdaQueryWrapper<Indicator>()
                .eq(Indicator::getIsLeaf, 1)
                .eq(Indicator::getStatus, 1);
        if (metricCodes != null && !metricCodes.isEmpty()) {
            iw.in(Indicator::getMetricCode, metricCodes);
        }
        List<Indicator> indicators = indicatorMapper.selectList(iw);

        // 2. 逐一获取结果并校验
        List<Map<String, Object>> issues = new ArrayList<>();
        int passCount = 0, failCount = 0, monitorCount = 0, noTargetCount = 0, noResultCount = 0;

        for (Indicator ind : indicators) {
            IndicatorResult result = latestResult(ind.getMetricCode(), timeDimension, timeValue);
            Map<String, Object> item = buildIssue(ind, result, timeDimension, timeValue);
            String status = (String) item.get("status");
            switch (status) {
                case "PASS":      passCount++;    break;
                case "FAIL":      failCount++;    break;
                case "MONITOR":   monitorCount++; break;
                case "NO_TARGET": noTargetCount++;break;
                default:          noResultCount++;break;
            }
            issues.add(item);
        }

        // 按严重程度排序：FAIL → NO_RESULT → MONITOR → NO_TARGET → PASS
        issues.sort(Comparator.comparingInt(m -> statusOrder((String) m.get("status"))));

        Map<String, Object> resp = new LinkedHashMap<>();
        resp.put("checkId",       UUID.randomUUID().toString());
        resp.put("timeDimension", timeDimension);
        resp.put("timeValue",     timeValue);
        resp.put("totalCount",    indicators.size());
        resp.put("passCount",     passCount);
        resp.put("failCount",     failCount);
        resp.put("monitorCount",  monitorCount);
        resp.put("noTargetCount", noTargetCount);
        resp.put("noResultCount", noResultCount);
        resp.put("overallStatus", failCount > 0 ? "FAIL"
                : (passCount > 0 ? "PASS"
                : (noTargetCount == indicators.size() ? "NO_TARGET" : "UNKNOWN")));
        resp.put("issues",        issues);
        return Result.success(resp);
    }

    // -------------------------------------------------------------------------
    // GET /api/data-validation/history
    // -------------------------------------------------------------------------
    @Operation(summary = "质检历史（按时间切片分页）",
               description = "返回 t_indicator_result 中已有的各时间切片的汇总质检结果，每个时间切片视为一次历史质检记录。")
    @GetMapping("/history")
    public Result<Map<String, Object>> history(
            @Parameter(description = "时间维度过滤，如 YEAR/MONTH") @RequestParam(required = false) String timeDimension,
            @Parameter(description = "当前页") @RequestParam(required = false, defaultValue = "1")  int current,
            @Parameter(description = "每页条数") @RequestParam(required = false, defaultValue = "10") int size) {

        // 查询所有指标最新结果的时间切片
        List<IndicatorResult> all = indicatorResultMapper.selectList(
                new LambdaQueryWrapper<IndicatorResult>()
                        .eq(timeDimension != null && !timeDimension.isEmpty(),
                                IndicatorResult::getTimeDimension, timeDimension)
                        .eq(IndicatorResult::getCalculationStatus, "SUCCESS")
                        .orderByDesc(IndicatorResult::getCreateTime));

        // 按 (timeDimension, timeValue) 分组
        Map<String, List<IndicatorResult>> grouped = new LinkedHashMap<>();
        for (IndicatorResult r : all) {
            String key = r.getTimeDimension() + "|" + r.getTimeValue();
            grouped.computeIfAbsent(key, k -> new ArrayList<>()).add(r);
        }

        // 查全部叶子指标（用于与结果对比）
        List<Indicator> leafIndicators = indicatorMapper.selectList(
                new LambdaQueryWrapper<Indicator>().eq(Indicator::getIsLeaf, 1).eq(Indicator::getStatus, 1));
        Map<String, Indicator> indMap = new HashMap<>();
        for (Indicator ind : leafIndicators) {
            indMap.put(ind.getMetricCode(), ind);
        }

        // 构造历史记录列表
        List<Map<String, Object>> records = new ArrayList<>();
        for (Map.Entry<String, List<IndicatorResult>> entry : grouped.entrySet()) {
            String[] parts = entry.getKey().split("\\|");
            List<IndicatorResult> results = entry.getValue();

            int pass = 0, fail = 0;
            for (IndicatorResult r : results) {
                Indicator ind = indMap.get(r.getMetricCode());
                if (ind == null || ind.getTargetValue() == null) continue;
                String dir = ind.getMonitorDirection();
                BigDecimal rv = r.getResultValue();
                BigDecimal tv = ind.getTargetValue();
                if (rv == null) continue;
                if ("INCREASE".equals(dir) && rv.compareTo(tv) >= 0) pass++;
                else if ("DECREASE".equals(dir) && rv.compareTo(tv) <= 0) pass++;
                else if ("INCREASE".equals(dir) || "DECREASE".equals(dir)) fail++;
            }

            Map<String, Object> rec = new LinkedHashMap<>();
            rec.put("timeDimension",  parts[0]);
            rec.put("timeValue",      parts.length > 1 ? parts[1] : "");
            rec.put("resultCount",    results.size());
            rec.put("passCount",      pass);
            rec.put("failCount",      fail);
            rec.put("overallStatus",  fail > 0 ? "FAIL" : (pass > 0 ? "PASS" : "NO_TARGET"));
            rec.put("checkTime",      results.get(0).getCreateTime());
            records.add(rec);
        }

        // 分页
        int total = records.size();
        int fromIdx = Math.min((current - 1) * size, total);
        int toIdx   = Math.min(fromIdx + size, total);
        List<Map<String, Object>> paged = records.subList(fromIdx, toIdx);

        Map<String, Object> resp = new LinkedHashMap<>();
        resp.put("records", paged);
        resp.put("total",   total);
        resp.put("pages",   (total + size - 1) / size);
        resp.put("current", current);
        resp.put("size",    size);
        return Result.success(resp);
    }

    // -------------------------------------------------------------------------
    // helpers
    // -------------------------------------------------------------------------
    private IndicatorResult latestResult(String metricCode, String timeDimension, String timeValue) {
        LambdaQueryWrapper<IndicatorResult> qw = new LambdaQueryWrapper<IndicatorResult>()
                .eq(IndicatorResult::getMetricCode, metricCode)
                .eq(IndicatorResult::getCalculationStatus, "SUCCESS");
        if (timeDimension != null && !timeDimension.isEmpty()) {
            qw.eq(IndicatorResult::getTimeDimension, timeDimension);
        }
        if (timeValue != null && !timeValue.isEmpty()) {
            qw.eq(IndicatorResult::getTimeValue, timeValue);
        }
        qw.orderByDesc(IndicatorResult::getCreateTime).last("LIMIT 1");
        return indicatorResultMapper.selectOne(qw);
    }

    private Map<String, Object> buildIssue(Indicator ind, IndicatorResult result,
                                            String timeDimension, String timeValue) {
        Map<String, Object> item = new LinkedHashMap<>();
        item.put("metricCode",       ind.getMetricCode());
        item.put("metricName",       ind.getMetricName());
        item.put("targetValue",      ind.getTargetValue());
        item.put("monitorDirection", ind.getMonitorDirection());
        item.put("unit",             ind.getUnit());

        if (result == null) {
            item.put("resultValue", null);
            item.put("timeValue",   timeValue);
            item.put("status",      "NO_RESULT");
            item.put("message",     timeDimension != null
                    ? "该时间段 [" + timeDimension + "/" + timeValue + "] 暂无计算结果"
                    : "暂无任何计算结果");
            return item;
        }

        item.put("resultValue", result.getResultValue());
        item.put("timeValue",   result.getTimeValue());

        BigDecimal rv = result.getResultValue();
        BigDecimal tv = ind.getTargetValue();
        String dir    = ind.getMonitorDirection();

        if (tv == null) {
            item.put("status",  "NO_TARGET");
            item.put("message", "未配置目标值，仅展示计算结果");
        } else if ("MONITOR".equals(dir) || dir == null) {
            item.put("status",  "MONITOR");
            item.put("message", "监测型指标，当前值=" + rv + "，参考目标=" + tv);
        } else if ("INCREASE".equals(dir)) {
            boolean pass = rv != null && rv.compareTo(tv) >= 0;
            item.put("status",  pass ? "PASS" : "FAIL");
            item.put("message", pass
                    ? "达标（结果" + rv + " ≥ 目标" + tv + "）"
                    : "未达标（结果" + rv + " < 目标" + tv + "，需逐步提高）");
        } else if ("DECREASE".equals(dir)) {
            boolean pass = rv != null && rv.compareTo(tv) <= 0;
            item.put("status",  pass ? "PASS" : "FAIL");
            item.put("message", pass
                    ? "达标（结果" + rv + " ≤ 目标" + tv + "）"
                    : "未达标（结果" + rv + " > 目标" + tv + "，需逐步降低）");
        } else {
            item.put("status",  "MONITOR");
            item.put("message", "未知监测方向 " + dir + "，当前值=" + rv);
        }
        return item;
    }

    private int statusOrder(String s) {
        switch (s) {
            case "FAIL":      return 0;
            case "NO_RESULT": return 1;
            case "MONITOR":   return 2;
            case "NO_TARGET": return 3;
            default:          return 4;
        }
    }
}
