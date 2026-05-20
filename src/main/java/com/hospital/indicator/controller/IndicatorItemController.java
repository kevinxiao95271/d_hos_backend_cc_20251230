package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.dto.IndicatorItemExecuteResultDTO;
import com.hospital.indicator.dto.IndicatorItemSaveDTO;
import com.hospital.indicator.entity.IndicatorItem;
import com.hospital.indicator.service.IndicatorItemService;
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
 * 指标项管理 Controller
 *
 * @author Claude
 * @date 2025-12-30
 */
@Slf4j
@Tag(name = "指标项管理", description = "指标项的增删改查、SQL执行等功能")
@RestController
@RequestMapping("/api/indicator-item")
public class IndicatorItemController {

    @Autowired
    private IndicatorItemService indicatorItemService;

    @Operation(summary = "分页查询指标项列表", description = "支持按指标项编码、名称、类型等条件查询")
    @GetMapping("/page")
    public Result<IPage<IndicatorItem>> page(
            @Parameter(description = "当前页") @RequestParam(defaultValue = "1") Long current,
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Long size,
            @Parameter(description = "指标项编码") @RequestParam(required = false) String itemCode,
            @Parameter(description = "指标项名称") @RequestParam(required = false) String itemName,
            @Parameter(description = "指标项类型") @RequestParam(required = false) String itemType) {

        Page<IndicatorItem> page = new Page<>(current, size);
        LambdaQueryWrapper<IndicatorItem> queryWrapper = new LambdaQueryWrapper<>();

        if (StringUtils.isNotBlank(itemCode)) {
            queryWrapper.like(IndicatorItem::getItemCode, itemCode);
        }
        if (StringUtils.isNotBlank(itemName)) {
            queryWrapper.like(IndicatorItem::getItemName, itemName);
        }
        if (StringUtils.isNotBlank(itemType)) {
            queryWrapper.eq(IndicatorItem::getItemType, itemType);
        }

        queryWrapper.orderByAsc(IndicatorItem::getSortOrder);
        IPage<IndicatorItem> result = indicatorItemService.page(page, queryWrapper);
        return Result.success(result);
    }

    @Operation(summary = "查询所有指标项列表", description = "查询所有启用状态的指标项")
    @GetMapping("/list")
    public Result<List<IndicatorItem>> list() {
        LambdaQueryWrapper<IndicatorItem> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(IndicatorItem::getStatus, 1);
        queryWrapper.orderByAsc(IndicatorItem::getSortOrder);
        List<IndicatorItem> list = indicatorItemService.list(queryWrapper);
        return Result.success(list);
    }

    @Operation(summary = "根据ID查询指标项详情", description = "根据指标项ID查询详细信息")
    @GetMapping("/{id}")
    public Result<IndicatorItem> getById(@Parameter(description = "指标项ID") @PathVariable Long id) {
        IndicatorItem item = indicatorItemService.getById(id);
        return Result.success(item);
    }

    @Operation(summary = "根据编码查询指标项详情", description = "根据指标项编码查询详细信息")
    @GetMapping("/code/{itemCode}")
    public Result<IndicatorItem> getByCode(@Parameter(description = "指标项编码") @PathVariable String itemCode) {
        LambdaQueryWrapper<IndicatorItem> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(IndicatorItem::getItemCode, itemCode);
        IndicatorItem item = indicatorItemService.getOne(queryWrapper);
        return Result.success(item);
    }

    @Operation(summary = "保存或更新指标项", description = "新增或更新指标项配置")
    @PostMapping("/save")
    public Result<IndicatorItem> save(@Validated @RequestBody IndicatorItemSaveDTO dto) {
        IndicatorItem item = indicatorItemService.saveOrUpdateIndicatorItem(dto);
        return Result.success("保存成功", item);
    }

    @Operation(summary = "删除指标项", description = "根据ID删除指标项")
    @DeleteMapping("/{id}")
    public Result<Void> delete(@Parameter(description = "指标项ID") @PathVariable Long id) {
        indicatorItemService.removeById(id);
        return Result.success("删除成功", null);
    }

    @Operation(summary = "批量删除指标项", description = "根据ID列表批量删除指标项")
    @DeleteMapping("/batch")
    public Result<Void> batchDelete(@RequestBody List<Long> ids) {
        indicatorItemService.removeByIds(ids);
        return Result.success("批量删除成功", null);
    }

    @Operation(summary = "执行指标项查询", description = "根据指标项编码执行SQL查询，返回计算结果")
    @PostMapping("/{code}/execute")
    public Result<IndicatorItemExecuteResultDTO> execute(
            @Parameter(description = "指标项编码") @PathVariable String code,
            @Parameter(description = "开始日期", example = "2025-01-01") @RequestParam String startDate,
            @Parameter(description = "结束日期", example = "2025-01-31") @RequestParam String endDate,
            @Parameter(description = "扩展参数") @RequestBody(required = false) Map<String, Object> params) {

        IndicatorItemExecuteResultDTO result = indicatorItemService.executeQuery(code, startDate, endDate, params);

        if (result.getSuccess()) {
            return Result.success("执行指标项查询成功", result);
        } else {
            return Result.error("执行指标项查询失败：" + result.getErrorMessage());
        }
    }

    @Operation(summary = "校验SQL有效性", description = "校验指标项SQL语句是否符合规范")
    @PostMapping("/validate-sql")
    public Result<Map<String, Object>> validateSql(@Parameter(description = "SQL语句") @RequestBody String sql) {
        // 去掉 JSON 字符串首尾可能存在的双引号（兼容 application/json 和 text/plain 两种传参方式）
        if (sql != null && sql.startsWith("\"") && sql.endsWith("\"") && sql.length() >= 2) {
            sql = sql.substring(1, sql.length() - 1);
        }
        Map<String, Object> resp = new java.util.LinkedHashMap<>();
        if (org.apache.commons.lang3.StringUtils.isBlank(sql)) {
            resp.put("valid", false);
            resp.put("message", "SQL不能为空");
            return Result.success(resp);
        }
        boolean isValid = indicatorItemService.validateSql(sql);
        resp.put("valid", isValid);
        resp.put("message", isValid ? "SQL校验通过" : "SQL校验失败：请确保是SELECT查询且不包含危险操作");
        return Result.success(resp);
    }

}
