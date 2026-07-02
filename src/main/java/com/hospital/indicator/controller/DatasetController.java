package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.entity.IndicatorResult;
import com.hospital.indicator.mapper.IndicatorResultMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 数据集管理
 * <p>
 * "数据集"定义：t_indicator_result 中每个唯一的 (timeDimension, timeValue) 组合
 * 即一次批量计算的结果快照，含：时间维度、时间值、日期范围、指标数量、最新计算时间。
 * <p>
 * 无需新建数据库表，直接复用 t_indicator_result。
 */
@Tag(name = "数据集管理", description = "已计算的指标结果快照（按时间切片聚合）")
@RestController
@RequestMapping("/api/dataset")
public class DatasetController {

    @Autowired
    private IndicatorResultMapper indicatorResultMapper;

    @Operation(summary = "数据集列表（不分页）",
               description = "返回所有已完成批量计算的时间切片，每个切片即一个数据集。\n\n"
                   + "可通过 `type` 参数按时间维度过滤，如 `type=YEAR` / `type=MONTH`。")
    @GetMapping("/list")
    public Result<List<Map<String, Object>>> list(
            @Parameter(description = "时间维度过滤：YEAR / MONTH / QUARTER / DAY（空=全部）")
            @RequestParam(required = false) String type) {
        return Result.success(buildDatasets(type, 1, Integer.MAX_VALUE, false).get("records") instanceof List
                ? (List<Map<String, Object>>) buildDatasets(type, 1, Integer.MAX_VALUE, false).get("records")
                : Collections.emptyList());
    }

    @Operation(summary = "数据集列表（分页）",
               description = "分页返回已完成批量计算的时间切片。")
    @GetMapping("/page")
    public Result<Map<String, Object>> page(
            @Parameter(description = "时间维度过滤：YEAR / MONTH / QUARTER / DAY（空=全部）")
            @RequestParam(required = false) String type,
            @Parameter(description = "当前页，从 1 开始")
            @RequestParam(required = false, defaultValue = "1")  int current,
            @Parameter(description = "每页条数")
            @RequestParam(required = false, defaultValue = "10") int size) {
        return Result.success(buildDatasets(type, current, size, true));
    }

    @Operation(summary = "数据集详情",
               description = "返回指定时间切片的所有指标计算结果明细。\n\n"
                   + "路径参数 `id` 格式为 `{timeDimension}_{timeValue}`，如 `YEAR_2020` / `MONTH_2020-01`。")
    @GetMapping("/{id}")
    public Result<Map<String, Object>> detail(
            @Parameter(description = "数据集ID（格式 YEAR_2020 或 MONTH_2020-01）")
            @PathVariable String id) {

        String[] parts = id.split("_", 2);
        if (parts.length < 2) {
            return Result.error(30400, "数据集ID格式错误，应为 {timeDimension}_{timeValue}，如 YEAR_2020");
        }
        String timeDimension = parts[0];
        String timeValue     = parts[1];

        List<IndicatorResult> results = indicatorResultMapper.selectList(
                new LambdaQueryWrapper<IndicatorResult>()
                        .eq(IndicatorResult::getTimeDimension, timeDimension)
                        .eq(IndicatorResult::getTimeValue, timeValue)
                        .eq(IndicatorResult::getCalculationStatus, "SUCCESS")
                        .orderByAsc(IndicatorResult::getMetricCode));

        if (results.isEmpty()) {
            return Result.error(30404, "数据集不存在：" + id);
        }

        Map<String, Object> resp = new LinkedHashMap<>();
        resp.put("datasetId",     id);
        resp.put("timeDimension", timeDimension);
        resp.put("timeValue",     timeValue);
        resp.put("startDate",     results.get(0).getStartDate());
        resp.put("endDate",       results.get(0).getEndDate());
        resp.put("indicatorCount", results.size());
        resp.put("records",       results);
        return Result.success(resp);
    }

    // -------------------------------------------------------------------------
    // helpers
    // -------------------------------------------------------------------------
    @SuppressWarnings("unchecked")
    private Map<String, Object> buildDatasets(String type, int current, int size, boolean paginate) {
        LambdaQueryWrapper<IndicatorResult> qw = new LambdaQueryWrapper<IndicatorResult>()
                .eq(IndicatorResult::getCalculationStatus, "SUCCESS");
        if (type != null && !type.isEmpty()) {
            qw.eq(IndicatorResult::getTimeDimension, type);
        }
        qw.orderByDesc(IndicatorResult::getCreateTime);
        List<IndicatorResult> all = indicatorResultMapper.selectList(qw);

        // 按 (timeDimension, timeValue) 分组并聚合
        Map<String, Map<String, Object>> grouped = new LinkedHashMap<>();
        for (IndicatorResult r : all) {
            String key = r.getTimeDimension() + "_" + r.getTimeValue();
            if (!grouped.containsKey(key)) {
                Map<String, Object> ds = new LinkedHashMap<>();
                ds.put("datasetId",      key);
                ds.put("timeDimension",  r.getTimeDimension());
                ds.put("timeValue",      r.getTimeValue());
                ds.put("startDate",      r.getStartDate());
                ds.put("endDate",        r.getEndDate());
                ds.put("indicatorCount", 0);
                ds.put("latestCalcTime", r.getCreateTime());
                grouped.put(key, ds);
            }
            Map<String, Object> ds = grouped.get(key);
            ds.put("indicatorCount", (int) ds.get("indicatorCount") + 1);
        }

        List<Map<String, Object>> records = new ArrayList<>(grouped.values());
        int total = records.size();

        if (paginate) {
            int from = Math.min((current - 1) * size, total);
            int to   = Math.min(from + size, total);
            records = records.subList(from, to);
        }

        Map<String, Object> resp = new LinkedHashMap<>();
        resp.put("records", records);
        resp.put("total",   total);
        resp.put("pages",   size > 0 ? (total + size - 1) / size : 1);
        resp.put("current", current);
        resp.put("size",    size);
        return resp;
    }
}
