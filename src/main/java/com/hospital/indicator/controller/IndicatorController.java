package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.dto.IndicatorSaveDTO;
import com.hospital.indicator.dto.IndicatorTreeDTO;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.service.IndicatorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 指标管理 Controller
 *
 * @author Claude
 * @date 2025-12-30
 */
@Slf4j
@Tag(name = "指标管理", description = "指标的增删改查、树形结构查询、表达式校验等功能")
@RestController
@RequestMapping("/api/indicator")
public class IndicatorController {

    @Autowired
    private IndicatorService indicatorService;

    @Operation(summary = "分页查询指标列表", description = "支持按指标编码、名称、类型等条件查询")
    @GetMapping("/page")
    public Result<IPage<Indicator>> page(
            @Parameter(description = "当前页") @RequestParam(defaultValue = "1") Long current,
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Long size,
            @Parameter(description = "指标编码") @RequestParam(required = false) String metricCode,
            @Parameter(description = "指标名称") @RequestParam(required = false) String metricName,
            @Parameter(description = "指标类型") @RequestParam(required = false) String metricType,
            @Parameter(description = "是否叶子节点") @RequestParam(required = false) Integer isLeaf) {

        Page<Indicator> page = new Page<>(current, size);
        LambdaQueryWrapper<Indicator> queryWrapper = new LambdaQueryWrapper<>();

        if (StringUtils.isNotBlank(metricCode)) {
            queryWrapper.like(Indicator::getMetricCode, metricCode);
        }
        if (StringUtils.isNotBlank(metricName)) {
            queryWrapper.like(Indicator::getMetricName, metricName);
        }
        if (StringUtils.isNotBlank(metricType)) {
            queryWrapper.eq(Indicator::getMetricType, metricType);
        }
        if (isLeaf != null) {
            queryWrapper.eq(Indicator::getIsLeaf, isLeaf);
        }

        queryWrapper.orderByAsc(Indicator::getSortOrder);
        IPage<Indicator> result = indicatorService.page(page, queryWrapper);
        return Result.success(result);
    }

    @Operation(summary = "查询指标树形结构", description = "查询所有指标的树形层级结构")
    @GetMapping("/tree")
    public Result<List<IndicatorTreeDTO>> tree() {
        List<IndicatorTreeDTO> tree = indicatorService.getIndicatorTree();
        return Result.success(tree);
    }

    @Operation(summary = "根据ID查询指标详情", description = "根据指标ID查询详细信息")
    @GetMapping("/{id}")
    public Result<Indicator> getById(@Parameter(description = "指标ID") @PathVariable Long id) {
        Indicator indicator = indicatorService.getById(id);
        return Result.success(indicator);
    }

    @Operation(summary = "根据编码查询指标详情", description = "根据指标编码查询详细信息")
    @GetMapping("/code/{metricCode}")
    public Result<Indicator> getByCode(@Parameter(description = "指标编码") @PathVariable String metricCode) {
        LambdaQueryWrapper<Indicator> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Indicator::getMetricCode, metricCode);
        Indicator indicator = indicatorService.getOne(queryWrapper);
        return Result.success(indicator);
    }

    @Operation(summary = "根据父级编码查询子指标", description = "查询指定父级下的所有子指标")
    @GetMapping("/children/{parentCode}")
    public Result<List<Indicator>> getChildren(@Parameter(description = "父级编码") @PathVariable String parentCode) {
        List<Indicator> children = indicatorService.getByParentCode(parentCode);
        return Result.success(children);
    }

    @Operation(summary = "保存或更新指标", description = "新增或更新指标配置")
    @PostMapping("/save")
    public Result<Indicator> save(@Validated @RequestBody IndicatorSaveDTO dto) {
        Indicator indicator = indicatorService.saveOrUpdateIndicator(dto);
        return Result.success("保存成功", indicator);
    }

    @Operation(summary = "删除指标", description = "根据ID删除指标")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@Parameter(description = "指标ID") @PathVariable Long id) {
        indicatorService.removeById(id);
        return Result.success("删除成功", null);
    }

    @Operation(summary = "批量删除指标", description = "根据ID列表批量删除指标")
    @DeleteMapping("/batch")
    public Result<Void> batchDelete(@RequestBody List<Long> ids) {
        indicatorService.removeByIds(ids);
        return Result.success("批量删除成功", null);
    }

    @Operation(summary = "校验表达式有效性", description = "校验指标计算表达式是否符合规范")
    @PostMapping("/validate-expression")
    public Result<Boolean> validateExpression(@Parameter(description = "表达式") @RequestBody String expression) {
        boolean isValid = indicatorService.validateExpression(expression);
        if (isValid) {
            return Result.success("表达式校验通过", true);
        } else {
            return Result.error("表达式校验失败：请确保格式正确");
        }
    }

}
