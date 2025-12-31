package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.entity.IndicatorResult;
import com.hospital.indicator.entity.IndicatorResultDept;
import com.hospital.indicator.mapper.IndicatorResultDeptMapper;
import com.hospital.indicator.mapper.IndicatorResultMapper;
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
import java.util.List;

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

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

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

        List<IndicatorResult> results = calculationService.batchCalculateIndicators(metricCodes, timeDimension, start, end);

        long successCount = results.stream().filter(r -> "SUCCESS".equals(r.getCalculationStatus())).count();
        long failedCount = results.size() - successCount;

        return Result.success(String.format("批量计算完成：成功%d条，失败%d条", successCount, failedCount), results);
    }

    @Operation(summary = "查询最新计算结果", description = "查询所有指标的最新计算结果")
    @GetMapping("/latest")
    public Result<List<IndicatorResult>> getLatest(
            @Parameter(description = "时间维度") @RequestParam(required = false) String timeDimension) {

        LambdaQueryWrapper<IndicatorResult> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.isNotBlank(timeDimension)) {
            wrapper.eq(IndicatorResult::getTimeDimension, timeDimension);
        }
        wrapper.orderByDesc(IndicatorResult::getCreateTime);
        wrapper.last("LIMIT 100");  // 限制返回数量

        List<IndicatorResult> results = resultMapper.selectList(wrapper);
        return Result.success(results);
    }

    @Operation(summary = "查询指标结果列表", description = "根据指标编码和时间范围查询计算结果")
    @GetMapping("/list")
    public Result<List<IndicatorResult>> list(
            @Parameter(description = "指标编码") @RequestParam(required = false) String metricCode,
            @Parameter(description = "时间维度") @RequestParam(required = false) String timeDimension,
            @Parameter(description = "时间值", example = "2025 或 2025-01") @RequestParam(required = false) String timeValue,
            @Parameter(description = "开始日期") @RequestParam(required = false) String startDate,
            @Parameter(description = "结束日期") @RequestParam(required = false) String endDate) {

        LambdaQueryWrapper<IndicatorResult> wrapper = new LambdaQueryWrapper<>();

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

        wrapper.orderByDesc(IndicatorResult::getTimeValue);
        List<IndicatorResult> results = resultMapper.selectList(wrapper);
        return Result.success(results);
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

}
