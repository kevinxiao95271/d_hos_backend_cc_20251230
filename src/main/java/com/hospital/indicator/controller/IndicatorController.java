package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.common.ErrorCode;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.context.UserContext;
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
import java.util.Map;

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
            @Parameter(description = "是否叶子节点") @RequestParam(required = false) Integer isLeaf,
            @Parameter(description = "指标池：POOL_NATIONAL(国考)、POOL_GRADE(等级评审)") @RequestParam(required = false) String metricPool) {

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
        if (StringUtils.isNotBlank(metricPool)) {
            queryWrapper.eq(Indicator::getMetricPool, metricPool);
        }

        queryWrapper.orderByAsc(Indicator::getSortOrder);
        IPage<Indicator> result = indicatorService.page(page, queryWrapper);
        return Result.success(result);
    }

    @Operation(summary = "查询指标树形结构", description = "查询指定指标池的树形层级结构，默认国考")
    @GetMapping("/tree")
    public Result<List<IndicatorTreeDTO>> tree(
            @Parameter(description = "指标池：POOL_NATIONAL(国考，默认)、POOL_GRADE(等级评审)") @RequestParam(defaultValue = "POOL_NATIONAL") String metricPool) {
        List<IndicatorTreeDTO> tree = indicatorService.getIndicatorTree(metricPool);
        return Result.success(tree);
    }

    @Operation(summary = "根据ID查询指标详情", description = "根据指标ID查询详细信息，不存在时返回 404")
    @GetMapping("/{id}")
    public Result<Indicator> getById(@Parameter(description = "指标ID") @PathVariable Long id) {
        Indicator indicator = indicatorService.getById(id);
        if (indicator == null) {
            return Result.error(30404, "指标不存在，id=" + id);
        }
        return Result.success(indicator);
    }

    @Operation(summary = "根据编码查询指标详情", description = "根据指标编码查询详细信息，不存在时返回 30404")
    @GetMapping("/code/{metricCode}")
    public Result<Indicator> getByCode(@Parameter(description = "指标编码") @PathVariable String metricCode) {
        LambdaQueryWrapper<Indicator> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Indicator::getMetricCode, metricCode);
        Indicator indicator = indicatorService.getOne(queryWrapper);
        if (indicator == null) {
            return Result.error(30404, "指标不存在，metricCode=" + metricCode);
        }
        return Result.success(indicator);
    }

    @Operation(summary = "根据父级编码查询子指标", description = "查询指定父级下的所有子指标")
    @GetMapping("/children/{parentCode}")
    public Result<List<Indicator>> getChildren(@Parameter(description = "父级编码") @PathVariable String parentCode) {
        List<Indicator> children = indicatorService.getByParentCode(parentCode);
        return Result.success(children);
    }

    @Operation(summary = "保存或更新指标（仅超管）",
            description = "仅 dataScope=50 可操作。新增时不传 id，更新时必须传现有 id 且 metricCode 不可修改；indicatorLevel 由后端根据 parentCode 自动计算。")
    @PostMapping("/save")
    public Result<Indicator> save(@Validated @RequestBody IndicatorSaveDTO dto) {
        requireAdmin();
        Indicator indicator = indicatorService.saveOrUpdateIndicator(dto);
        return Result.success("保存成功", indicator);
    }

    @Operation(summary = "删除指标（仅超管）", description = "根据ID删除指标")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@Parameter(description = "指标ID") @PathVariable Long id) {
        requireAdmin();
        Indicator indicator = indicatorService.getById(id);
        if (indicator == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND, "指标不存在，id=" + id);
        }
        if (!indicatorService.getByParentCode(indicator.getMetricCode()).isEmpty()) {
            throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                    "该指标存在子节点，请先删除子节点");
        }
        indicatorService.removeById(id);
        return Result.success("删除成功", null);
    }

    @Operation(summary = "批量删除指标（仅超管）", description = "根据ID列表批量删除指标")
    @DeleteMapping("/batch")
    public Result<Void> batchDelete(@RequestBody List<Long> ids) {
        requireAdmin();
        if (ids == null || ids.isEmpty()) {
            throw new BusinessException(ErrorCode.PARAM_INVALID, "ids 不能为空");
        }
        List<Indicator> indicators = indicatorService.listByIds(ids);
        if (indicators.size() != ids.size()) {
            throw new BusinessException(ErrorCode.NOT_FOUND, "批量删除列表中包含不存在的指标ID");
        }
        java.util.Set<String> deletingCodes = indicators.stream()
                .map(Indicator::getMetricCode)
                .collect(java.util.stream.Collectors.toSet());
        for (Indicator indicator : indicators) {
            boolean hasRemainingChild = indicatorService.getByParentCode(indicator.getMetricCode())
                    .stream()
                    .anyMatch(child -> !deletingCodes.contains(child.getMetricCode()));
            if (hasRemainingChild) {
                throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                        "指标 " + indicator.getMetricCode() + " 存在未包含在本次删除中的子节点");
            }
        }
        indicatorService.removeByIds(ids);
        return Result.success("批量删除成功", null);
    }

    @Operation(summary = "校验表达式有效性", description = "校验指标计算表达式是否符合规范")
    @PostMapping("/validate-expression")
    public Result<Map<String, Object>> validateExpression(@Parameter(description = "表达式") @RequestBody String expression) {
        // 去掉 JSON 字符串首尾可能存在的双引号
        if (expression != null && expression.startsWith("\"") && expression.endsWith("\"") && expression.length() >= 2) {
            expression = expression.substring(1, expression.length() - 1);
        }
        Map<String, Object> resp = new java.util.LinkedHashMap<>();
        if (org.apache.commons.lang3.StringUtils.isBlank(expression)) {
            resp.put("valid", false);
            resp.put("message", "表达式不能为空");
            return Result.success(resp);
        }
        boolean isValid = indicatorService.validateExpression(expression);
        resp.put("valid", isValid);
        resp.put("message", isValid ? "表达式校验通过" : "表达式校验失败：请使用 a0050/a0029 等指标项编码和四则运算符，如 a0029 * 1.0 / a0030");
        if (!isValid) {
            return Result.error(30400, (String) resp.get("message"));
        }
        return Result.success(resp);
    }

    private void requireAdmin() {
        UserContext user = UserContext.get();
        if (user == null || !Integer.valueOf(50).equals(user.getDataScope())) {
            throw new BusinessException(ErrorCode.FORBIDDEN,
                    "无权限：仅超级管理员（dataScope=50）可维护指标");
        }
    }

}
