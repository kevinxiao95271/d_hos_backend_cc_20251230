package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.entity.IndicatorResult;
import com.hospital.indicator.entity.IndicatorResultDept;
import com.hospital.indicator.mapper.IndicatorMapper;
import com.hospital.indicator.mapper.IndicatorResultDeptMapper;
import com.hospital.indicator.mapper.IndicatorResultMapper;
import com.hospital.indicator.mapper.sys.IndicatorPermissionMapper;
import com.hospital.indicator.service.IndicatorCalculationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 指标计算与结果查询 Controller
 *
 * @author Claude
 * @date 2025-12-30
 */
@Slf4j
@Tag(name = "指标计算与结果查询", description = "指标计算执行、结果查询、科室下钻等功能")
@RestController
@RequestMapping("/api/indicator-result")
public class IndicatorResultController {

    @Autowired
    private IndicatorCalculationService calculationService;

    @Autowired
    private IndicatorResultMapper resultMapper;

    @Autowired
    private IndicatorResultDeptMapper resultDeptMapper;

    @Autowired
    private IndicatorPermissionMapper permissionMapper;

    @Autowired
    private IndicatorMapper indicatorMapper;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /** dataScope=50 表示超管，可查看全部 */
    private static final int DATA_SCOPE_ADMIN = 50;


    /**
     * 根据当前登录用户获取其可见的指标编码列表。
     * 超管返回 null（表示不限制），普通用户返回绑定的 metric_code 列表。
     */
    private List<String> getVisibleMetricCodes() {
        UserContext user = UserContext.get();
        if (user == null || DATA_SCOPE_ADMIN == user.getDataScope()) {
            return null;
        }
        List<String> codes = permissionMapper.selectVisibleMetricCodes(user.getDeptId());
        return codes.isEmpty() ? Collections.emptyList() : codes;
    }

    @Operation(summary = "执行单个指标计算", description = "根据指标编码和时间范围执行计算")
    @PostMapping("/calculate")
    public Result<IndicatorResult> calculate(
            @Parameter(description = "指标编码", required = true) @RequestParam String metricCode,
            @Parameter(description = "时间维度：YEAR/QUARTER/MONTH/DAY", required = true) @RequestParam String timeDimension,
            @Parameter(description = "开始日期", required = true, example = "2025-01-01") @RequestParam String startDate,
            @Parameter(description = "结束日期", required = true, example = "2025-01-31") @RequestParam String endDate) {

        LocalDate start = LocalDate.parse(startDate, DATE_FORMATTER);
        LocalDate end = LocalDate.parse(endDate, DATE_FORMATTER);

        IndicatorResult result = calculationService.calculateIndicator(metricCode, timeDimension, start, end);

        if ("SUCCESS".equals(result.getCalculationStatus())) {
            return Result.success("指标计算成功", result);
        } else {
            return Result.error("指标计算失败：" + result.getErrorMessage());
        }
    }

    @Operation(summary = "批量计算指标", description = "批量执行多个指标的计算，支持按时间维度自动拆分")
    @PostMapping("/batch-calculate")
    public Result<List<IndicatorResult>> batchCalculate(
            @Parameter(description = "指标编码列表（为空时计算所有叶子指标）") @RequestBody(required = false) List<String> metricCodes,
            @Parameter(description = "时间维度：YEAR/QUARTER/MONTH/DAY", required = true) @RequestParam String timeDimension,
            @Parameter(description = "开始日期", required = true, example = "2025-01-01") @RequestParam String startDate,
            @Parameter(description = "结束日期", required = true, example = "2025-03-31") @RequestParam String endDate) {

        LocalDate start = LocalDate.parse(startDate, DATE_FORMATTER);
        LocalDate end = LocalDate.parse(endDate, DATE_FORMATTER);

        // B5 fix: 防止月度跨多期导致服务器超时
        // MONTH/DAY 维度跨度不能超过 3 期；YEAR/QUARTER 不限（每期跨度大，指标少）
        if ("MONTH".equals(timeDimension)) {
            long months = java.time.temporal.ChronoUnit.MONTHS.between(
                    start.withDayOfMonth(1), end.withDayOfMonth(1)) + 1;
            if (months > 3) {
                return Result.error(30400, String.format(
                    "MONTH 维度单次最多跨 3 个月（当前请求 %d 个月）。请分批调用，或使用 YEAR 维度进行年度汇总。", months));
            }
        } else if ("DAY".equals(timeDimension)) {
            long days = java.time.temporal.ChronoUnit.DAYS.between(start, end) + 1;
            if (days > 7) {
                return Result.error(30400, String.format(
                    "DAY 维度单次最多跨 7 天（当前请求 %d 天）。请分批调用。", days));
            }
        }

        List<IndicatorResult> results = calculationService.batchCalculateIndicators(metricCodes, timeDimension, start, end);

        long successCount = results.stream().filter(r -> "SUCCESS".equals(r.getCalculationStatus())).count();
        long failedCount = results.size() - successCount;

        return Result.success(String.format("批量计算完成：成功%d条，失败%d条", successCount, failedCount), results);
    }

    @Operation(summary = "查询最新计算结果", description = "查询所有指标的最新计算结果，支持按数据来源类型筛选")
    @GetMapping("/latest")
    public Result<List<IndicatorResult>> getLatest(
            @Parameter(description = "时间维度") @RequestParam(required = false) String timeDimension,
            @Parameter(description = "数据来源类型：AUTO/MANUAL（为空查全部）") @RequestParam(required = false) String sourceType) {

        List<String> visibleCodes = getVisibleMetricCodes();
        if (visibleCodes != null && visibleCodes.isEmpty()) {
            return Result.success(Collections.emptyList());
        }

        LambdaQueryWrapper<IndicatorResult> wrapper = new LambdaQueryWrapper<>();
        if (visibleCodes != null) {
            wrapper.in(IndicatorResult::getMetricCode, visibleCodes);
        }
        if (StringUtils.isNotBlank(timeDimension)) {
            wrapper.eq(IndicatorResult::getTimeDimension, timeDimension);
        }
        // sourceType 过滤：查出对应 input_type 的指标编码集合
        applySourceTypeFilter(wrapper, sourceType, visibleCodes);
        wrapper.orderByDesc(IndicatorResult::getCreateTime);
        wrapper.last("LIMIT 100");

        List<IndicatorResult> results = resultMapper.selectList(wrapper);
        return Result.success(results);
    }

    @Operation(summary = "查询指标结果列表", description = "根据指标编码和时间范围查询计算结果，支持按数据来源类型筛选")
    @GetMapping("/list")
    public Result<List<IndicatorResult>> list(
            @Parameter(description = "指标编码") @RequestParam(required = false) String metricCode,
            @Parameter(description = "时间维度") @RequestParam(required = false) String timeDimension,
            @Parameter(description = "时间值", example = "2025 或 2025-01") @RequestParam(required = false) String timeValue,
            @Parameter(description = "开始日期") @RequestParam(required = false) String startDate,
            @Parameter(description = "结束日期") @RequestParam(required = false) String endDate,
            @Parameter(description = "数据来源类型：AUTO/MANUAL（为空查全部）") @RequestParam(required = false) String sourceType) {

        List<String> visibleCodes = getVisibleMetricCodes();
        if (visibleCodes != null && visibleCodes.isEmpty()) {
            return Result.success(Collections.emptyList());
        }

        LambdaQueryWrapper<IndicatorResult> wrapper = new LambdaQueryWrapper<>();
        if (visibleCodes != null) {
            wrapper.in(IndicatorResult::getMetricCode, visibleCodes);
        }
        if (StringUtils.isNotBlank(metricCode)) {
            wrapper.eq(IndicatorResult::getMetricCode, metricCode);
        }
        if (StringUtils.isNotBlank(timeDimension)) {
            wrapper.eq(IndicatorResult::getTimeDimension, timeDimension);
        }
        if (StringUtils.isNotBlank(timeValue)) {
            wrapper.eq(IndicatorResult::getTimeValue, timeValue);
        }
        if (StringUtils.isNotBlank(startDate)) {
            LocalDate start = LocalDate.parse(startDate, DATE_FORMATTER);
            wrapper.ge(IndicatorResult::getStartDate, start);
        }
        if (StringUtils.isNotBlank(endDate)) {
            LocalDate end = LocalDate.parse(endDate, DATE_FORMATTER);
            wrapper.le(IndicatorResult::getEndDate, end);
        }
        applySourceTypeFilter(wrapper, sourceType, visibleCodes);

        wrapper.orderByDesc(IndicatorResult::getTimeValue);
        List<IndicatorResult> results = resultMapper.selectList(wrapper);
        return Result.success(results);
    }

    /**
     * 根据 sourceType（AUTO/MANUAL）过滤指标编码集合，追加到 wrapper。
     * AUTO/MANUAL 对应 t_indicator.input_type 字段。
     */
    private void applySourceTypeFilter(LambdaQueryWrapper<IndicatorResult> wrapper,
                                       String sourceType, List<String> alreadyVisibleCodes) {
        if (StringUtils.isBlank(sourceType)) return;
        List<Indicator> matched = indicatorMapper.selectList(
                new LambdaQueryWrapper<Indicator>().eq(Indicator::getInputType, sourceType.toUpperCase()));
        Set<String> filteredCodes = matched.stream().map(Indicator::getMetricCode).collect(Collectors.toSet());
        if (alreadyVisibleCodes != null) {
            filteredCodes.retainAll(alreadyVisibleCodes);
        }
        if (filteredCodes.isEmpty()) {
            wrapper.apply("1=0");
        } else {
            wrapper.in(IndicatorResult::getMetricCode, filteredCodes);
        }
    }

    @Operation(summary = "查询指标结果详情", description = "根据ID查询指标结果详情")
    @GetMapping("/{id}")
    public Result<IndicatorResult> getById(@Parameter(description = "结果ID") @PathVariable Long id) {
        IndicatorResult result = resultMapper.selectById(id);
        return Result.success(result);
    }

    @Operation(summary = "查询科室下钻结果", description = "查询指定指标的科室维度下钻数据")
    @GetMapping("/dept-drill/{metricCode}")
    public Result<List<IndicatorResultDept>> getDeptDrill(
            @Parameter(description = "指标编码") @PathVariable String metricCode,
            @Parameter(description = "时间维度") @RequestParam(required = false) String timeDimension,
            @Parameter(description = "时间值") @RequestParam(required = false) String timeValue) {

        List<String> visibleCodes = getVisibleMetricCodes();
        if (visibleCodes != null && !visibleCodes.contains(metricCode)) {
            return Result.success(Collections.emptyList());
        }

        LambdaQueryWrapper<IndicatorResultDept> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(IndicatorResultDept::getMetricCode, metricCode);

        if (StringUtils.isNotBlank(timeDimension)) {
            wrapper.eq(IndicatorResultDept::getTimeDimension, timeDimension);
        }
        if (StringUtils.isNotBlank(timeValue)) {
            wrapper.eq(IndicatorResultDept::getTimeValue, timeValue);
        }

        wrapper.orderByDesc(IndicatorResultDept::getResultValue);
        List<IndicatorResultDept> results = resultDeptMapper.selectList(wrapper);
        return Result.success(results);
    }

    @Operation(summary = "科室下钻计算", description = "执行指定指标的科室维度下钻计算")
    @PostMapping("/dept-drill-down")
    public Result<List<IndicatorResultDept>> deptDrillDown(
            @Parameter(description = "指标编码", required = true) @RequestParam String metricCode,
            @Parameter(description = "时间维度：YEAR/QUARTER/MONTH/DAY", required = true) @RequestParam String timeDimension,
            @Parameter(description = "开始日期", required = true, example = "2025-01-01") @RequestParam String startDate,
            @Parameter(description = "结束日期", required = true, example = "2025-12-31") @RequestParam String endDate) {

        LocalDate start = LocalDate.parse(startDate, DATE_FORMATTER);
        LocalDate end = LocalDate.parse(endDate, DATE_FORMATTER);

        List<IndicatorResultDept> results = calculationService.calculateDeptDrill(metricCode, timeDimension, start, end);

        return Result.success("科室下钻计算完成，共计算 " + results.size() + " 个科室", results);
    }

    @Operation(summary = "删除计算结果", description = "根据ID删除指标计算结果")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@Parameter(description = "结果ID") @PathVariable Long id) {
        resultMapper.deleteById(id);
        return Result.success("删除成功", null);
    }

    // =========================================================================
    // 目标值对比 / 达标率
    // =========================================================================
    @Operation(summary = "目标值达标率分析",
               description = "对比各叶子指标最新计算结果与配置的目标值，返回达标/未达标/监测/无目标 四类汇总。\n\n"
                   + "**参数**：\n"
                   + "- `timeDimension`：YEAR/MONTH/QUARTER（空则取各指标最新一条）\n"
                   + "- `timeValue`：如 2020、2020-01\n\n"
                   + "**complianceStatus 枚举**：\n"
                   + "- `PASS`：达标\n"
                   + "- `FAIL`：未达标\n"
                   + "- `MONITOR`：监测型，不判断达标\n"
                   + "- `NO_TARGET`：未配置目标值")
    @GetMapping("/compliance")
    public Result<java.util.Map<String, Object>> compliance(
            @Parameter(description = "时间维度") @RequestParam(required = false) String timeDimension,
            @Parameter(description = "时间值，如 2020 或 2020-01") @RequestParam(required = false) String timeValue) {

        // 1. 查可见叶子指标
        List<String> visibleCodes = getVisibleMetricCodes();
        LambdaQueryWrapper<Indicator> iw = new LambdaQueryWrapper<Indicator>()
                .eq(Indicator::getIsLeaf, 1)
                .eq(Indicator::getStatus, 1);
        if (visibleCodes != null && !visibleCodes.isEmpty()) {
            iw.in(Indicator::getMetricCode, visibleCodes);
        } else if (visibleCodes != null) {
            return Result.success(buildComplianceResp(java.util.Collections.emptyList()));
        }
        List<Indicator> indicators = indicatorMapper.selectList(iw);

        // 2. 逐指标取最新结果
        java.util.List<java.util.Map<String, Object>> items = new java.util.ArrayList<>();
        int passCount = 0, failCount = 0, monitorCount = 0, noTargetCount = 0;

        for (Indicator ind : indicators) {
            LambdaQueryWrapper<IndicatorResult> rw = new LambdaQueryWrapper<IndicatorResult>()
                    .eq(IndicatorResult::getMetricCode, ind.getMetricCode())
                    .eq(IndicatorResult::getCalculationStatus, "SUCCESS");
            if (StringUtils.isNotBlank(timeDimension)) rw.eq(IndicatorResult::getTimeDimension, timeDimension);
            if (StringUtils.isNotBlank(timeValue))     rw.eq(IndicatorResult::getTimeValue, timeValue);
            rw.orderByDesc(IndicatorResult::getCreateTime).last("LIMIT 1");
            IndicatorResult res = resultMapper.selectOne(rw);

            java.util.Map<String, Object> row = new java.util.LinkedHashMap<>();
            row.put("metricCode",       ind.getMetricCode());
            row.put("metricName",       ind.getMetricName());
            row.put("unit",             ind.getUnit());
            row.put("targetValue",      ind.getTargetValue());
            row.put("monitorDirection", ind.getMonitorDirection());
            row.put("resultValue",      res != null ? res.getResultValue() : null);
            row.put("timeValue",        res != null ? res.getTimeValue() : null);

            java.math.BigDecimal tv = ind.getTargetValue();
            java.math.BigDecimal rv = res != null ? res.getResultValue() : null;
            String dir = ind.getMonitorDirection();
            String status;
            if (tv == null) {
                status = "NO_TARGET"; noTargetCount++;
            } else if ("MONITOR".equals(dir) || dir == null) {
                status = "MONITOR"; monitorCount++;
            } else if (rv == null) {
                status = "NO_TARGET"; noTargetCount++;
            } else if ("INCREASE".equals(dir)) {
                status = rv.compareTo(tv) >= 0 ? "PASS" : "FAIL";
                if ("PASS".equals(status)) passCount++; else failCount++;
            } else {
                status = rv.compareTo(tv) <= 0 ? "PASS" : "FAIL";
                if ("PASS".equals(status)) passCount++; else failCount++;
            }
            row.put("complianceStatus", status);
            items.add(row);
        }

        // 按 FAIL → NO_TARGET → MONITOR → PASS 排序
        items.sort(java.util.Comparator.comparingInt(m -> {
            switch ((String) m.get("complianceStatus")) {
                case "FAIL": return 0; case "NO_TARGET": return 1;
                case "MONITOR": return 2; default: return 3;
            }
        }));

        java.util.Map<String, Object> resp = new java.util.LinkedHashMap<>();
        resp.put("timeDimension", timeDimension);
        resp.put("timeValue",     timeValue);
        resp.put("totalCount",    indicators.size());
        resp.put("passCount",     passCount);
        resp.put("failCount",     failCount);
        resp.put("monitorCount",  monitorCount);
        resp.put("noTargetCount", noTargetCount);
        resp.put("complianceRate", indicators.size() > 0
                ? String.format("%.1f%%", passCount * 100.0 / indicators.size()) : "N/A");
        resp.put("items", items);
        return Result.success(resp);
    }

    private java.util.Map<String, Object> buildComplianceResp(java.util.List<?> items) {
        java.util.Map<String, Object> m = new java.util.LinkedHashMap<>();
        m.put("totalCount", 0); m.put("passCount", 0); m.put("failCount", 0);
        m.put("complianceRate", "N/A"); m.put("items", items);
        return m;
    }

    // =========================================================================
    // 对比分析
    // =========================================================================
    @Operation(summary = "指标对比分析",
               description = "支持两种对比模式，返回 ECharts 友好的 series 格式。\n\n"
                   + "**模式一：单指标多时间段（趋势分析）**\n"
                   + "- 参数：`metricCode`（单个）+ `timeDimension` + `timeValues`（逗号分隔，如 `2020,2021,2022`）\n"
                   + "- 示例：`?metricCode=rate_incision_infection&timeDimension=YEAR&timeValues=2020,2021,2022`\n\n"
                   + "**模式二：多指标单时间段（横向对比）**\n"
                   + "- 参数：`metricCodes`（逗号分隔）+ `timeDimension` + `timeValue`（单个）\n"
                   + "- 示例：`?metricCodes=rate_incision_infection,rate_surgery_complication&timeDimension=YEAR&timeValue=2020`\n\n"
                   + "**返回字段说明**\n"
                   + "- `mode`: TREND=趋势模式，CROSS=横向对比模式\n"
                   + "- `xAxis`: 前端 X 轴标签数组（模式一=时间值，模式二=指标名）\n"
                   + "- `series[].data`: 每个点含 timeValue / resultValue / startDate / endDate")
    @GetMapping("/compare")
    public Result<Map<String, Object>> compare(
            @Parameter(description = "单指标编码（模式一）") @RequestParam(required = false) String metricCode,
            @Parameter(description = "多指标编码，逗号分隔（模式二）") @RequestParam(required = false) String metricCodes,
            @Parameter(description = "时间维度：YEAR/MONTH/QUARTER", required = true) @RequestParam String timeDimension,
            @Parameter(description = "单个时间值（模式二），如 2020") @RequestParam(required = false) String timeValue,
            @Parameter(description = "多个时间值，逗号分隔（模式一），如 2020,2021,2022") @RequestParam(required = false) String timeValues) {

        // ---------- 参数解析 ----------
        List<String> codeList  = new ArrayList<>();
        List<String> valueList = new ArrayList<>();
        boolean isTrendMode;

        if (StringUtils.isNotBlank(metricCode) && StringUtils.isNotBlank(timeValues)) {
            isTrendMode = true;
            codeList.add(metricCode.trim());
            for (String v : timeValues.split(",")) { if (!v.trim().isEmpty()) valueList.add(v.trim()); }
        } else if (StringUtils.isNotBlank(metricCodes) && StringUtils.isNotBlank(timeValue)) {
            isTrendMode = false;
            for (String c : metricCodes.split(",")) { if (!c.trim().isEmpty()) codeList.add(c.trim()); }
            valueList.add(timeValue.trim());
        } else {
            return Result.error(30400,
                "参数错误：模式一（趋势）需传 metricCode+timeDimension+timeValues；"
                + "模式二（横向）需传 metricCodes+timeDimension+timeValue");
        }

        // ---------- 权限过滤 ----------
        List<String> visible = getVisibleMetricCodes();
        if (visible != null && !visible.isEmpty()) codeList.retainAll(visible);
        if (codeList.isEmpty()) {
            return Result.success(buildCompareResp(isTrendMode, timeDimension,
                    Collections.emptyList(), Collections.emptyList(), Collections.emptyList()));
        }

        // ---------- 查指标配置（不过滤 status，确保 xAxis 能显示名称）----------
        List<Indicator> indList = indicatorMapper.selectList(
                new LambdaQueryWrapper<Indicator>()
                        .in(Indicator::getMetricCode, codeList));
        Map<String, Indicator> indMap = new LinkedHashMap<>();
        for (Indicator ind : indList) indMap.put(ind.getMetricCode(), ind);

        // ---------- 查结果 ----------
        List<IndicatorResult> results = resultMapper.selectList(
                new LambdaQueryWrapper<IndicatorResult>()
                        .in(IndicatorResult::getMetricCode, codeList)
                        .eq(IndicatorResult::getTimeDimension, timeDimension)
                        .in(IndicatorResult::getTimeValue, valueList)
                        .eq(IndicatorResult::getCalculationStatus, "SUCCESS")
                        .orderByAsc(IndicatorResult::getTimeValue));

        // ---------- 构建结果索引 metricCode → timeValue → result ----------
        Map<String, Map<String, IndicatorResult>> idx = new LinkedHashMap<>();
        for (String code : codeList) idx.put(code, new LinkedHashMap<>());
        for (IndicatorResult r : results) {
            idx.computeIfAbsent(r.getMetricCode(), k -> new LinkedHashMap<>()).put(r.getTimeValue(), r);
        }

        // ---------- 组装 series ----------
        List<String> xAxis  = new ArrayList<>();
        List<Map<String, Object>> series = new ArrayList<>();

        if (isTrendMode) {
            xAxis.addAll(valueList);
            String code = codeList.get(0);
            Indicator ind = indMap.get(code);
            List<Map<String, Object>> data = new ArrayList<>();
            for (String tv : valueList) {
                IndicatorResult r = idx.getOrDefault(code, Collections.emptyMap()).get(tv);
                Map<String, Object> pt = new LinkedHashMap<>();
                pt.put("timeValue",   tv);
                pt.put("resultValue", r != null ? r.getResultValue() : null);
                pt.put("startDate",   r != null ? r.getStartDate()   : null);
                pt.put("endDate",     r != null ? r.getEndDate()     : null);
                data.add(pt);
            }
            Map<String, Object> s = new LinkedHashMap<>();
            s.put("metricCode",  code);
            s.put("metricName",  ind != null ? ind.getMetricName()  : code);
            s.put("unit",        ind != null ? ind.getUnit()         : null);
            s.put("targetValue", ind != null ? ind.getTargetValue()  : null);
            s.put("data", data);
            series.add(s);
        } else {
            String tv = valueList.get(0);
            for (String code : codeList) {
                Indicator ind = indMap.get(code);
                xAxis.add(ind != null ? ind.getMetricName() : code);
                IndicatorResult r = idx.getOrDefault(code, Collections.emptyMap()).get(tv);
                Map<String, Object> pt = new LinkedHashMap<>();
                pt.put("timeValue",   tv);
                pt.put("resultValue", r != null ? r.getResultValue() : null);
                pt.put("startDate",   r != null ? r.getStartDate()   : null);
                pt.put("endDate",     r != null ? r.getEndDate()     : null);
                Map<String, Object> s = new LinkedHashMap<>();
                s.put("metricCode",  code);
                s.put("metricName",  ind != null ? ind.getMetricName()  : code);
                s.put("unit",        ind != null ? ind.getUnit()         : null);
                s.put("targetValue", ind != null ? ind.getTargetValue()  : null);
                s.put("data", Collections.singletonList(pt));
                series.add(s);
            }
        }

        return Result.success(buildCompareResp(isTrendMode, timeDimension, xAxis, valueList, series));
    }

    private Map<String, Object> buildCompareResp(boolean isTrend, String timeDimension,
            List<String> xAxis, List<String> timeValues, List<?> series) {
        Map<String, Object> resp = new LinkedHashMap<>();
        resp.put("mode",          isTrend ? "TREND" : "CROSS");
        resp.put("timeDimension", timeDimension);
        resp.put("xAxis",         xAxis);
        resp.put("timeValues",    timeValues);
        resp.put("series",        series);
        return resp;
    }

}
