package com.hospital.indicator.controller;

import com.hospital.indicator.common.Result;
import com.hospital.indicator.entity.IndicatorDeptScope;
import com.hospital.indicator.service.IndicatorScopeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 指标科室可见范围配置 Controller（仅超管使用）
 */
@Tag(name = "指标可见范围配置", description = "超管配置各科室可见的指标范围")
@RestController
@RequestMapping("/api/indicator-scope")
public class IndicatorScopeController {

    @Autowired
    private IndicatorScopeService scopeService;

    // ─────────────────────────── 查询 ───────────────────────────

    @Operation(summary = "查询科室已绑定的指标列表")
    @GetMapping("/by-dept/{deptId}")
    public Result<List<IndicatorDeptScope>> listByDept(
            @Parameter(description = "科室ID") @PathVariable Long deptId) {
        return Result.success(scopeService.listByDept(deptId));
    }

    @Operation(summary = "查询指标已绑定的科室列表")
    @GetMapping("/by-metric/{metricCode}")
    public Result<List<IndicatorDeptScope>> listByMetric(
            @Parameter(description = "指标编码") @PathVariable String metricCode) {
        return Result.success(scopeService.listByMetric(metricCode));
    }

    // ─────────────────────────── 新增单条 ───────────────────────────

    @Operation(summary = "新增单条科室-指标绑定",
               description = "若已存在则忽略（幂等）")
    @PostMapping("/binding")
    public Result<Void> addBinding(@RequestBody Map<String, Object> body) {
        Long deptId = Long.valueOf(body.get("deptId").toString());
        String metricCode = body.get("metricCode").toString();
        Integer isPrimaryOwner = body.containsKey("isPrimaryOwner")
                ? Integer.valueOf(body.get("isPrimaryOwner").toString()) : 1;
        scopeService.addBinding(deptId, metricCode, isPrimaryOwner);
        return Result.success("绑定成功", null);
    }

    // ─────────────────────────── 批量覆盖 ───────────────────────────

    @Operation(summary = "批量设置科室的可见指标（覆盖）",
               description = "传入科室ID + 指标编码列表，先清空再写入；传空列表则清空该科室所有绑定")
    @PostMapping("/replace-by-dept")
    public Result<Void> replaceByDept(@RequestBody Map<String, Object> body) {
        Long deptId = Long.valueOf(body.get("deptId").toString());
        @SuppressWarnings("unchecked")
        List<String> metricCodes = (List<String>) body.get("metricCodes");
        Integer isPrimaryOwner = body.containsKey("isPrimaryOwner")
                ? Integer.valueOf(body.get("isPrimaryOwner").toString()) : 1;
        scopeService.replaceByDept(deptId, metricCodes, isPrimaryOwner);
        return Result.success("设置完成，共绑定 " + (metricCodes == null ? 0 : metricCodes.size()) + " 个指标", null);
    }

    @Operation(summary = "批量设置指标的可见科室（覆盖）",
               description = "传入指标编码 + 科室ID列表，先清空再写入；传空列表则清空该指标所有科室绑定")
    @PostMapping("/replace-by-metric")
    public Result<Void> replaceByMetric(@RequestBody Map<String, Object> body) {
        String metricCode = body.get("metricCode").toString();
        @SuppressWarnings("unchecked")
        List<Object> rawIds = (List<Object>) body.get("deptIds");
        List<Long> deptIds = rawIds == null ? java.util.Collections.emptyList()
                : rawIds.stream().map(o -> Long.valueOf(o.toString())).collect(java.util.stream.Collectors.toList());
        Integer isPrimaryOwner = body.containsKey("isPrimaryOwner")
                ? Integer.valueOf(body.get("isPrimaryOwner").toString()) : 1;
        scopeService.replaceByMetric(metricCode, deptIds, isPrimaryOwner);
        return Result.success("设置完成，共绑定 " + deptIds.size() + " 个科室", null);
    }

    // ─────────────────────────── 删除 ───────────────────────────

    @Operation(summary = "删除单条科室-指标绑定")
    @DeleteMapping("/binding")
    public Result<Void> removeBinding(
            @Parameter(description = "科室ID") @RequestParam Long deptId,
            @Parameter(description = "指标编码") @RequestParam String metricCode) {
        scopeService.removeBinding(deptId, metricCode);
        return Result.success("解绑成功", null);
    }

    @Operation(summary = "清空某科室的全部指标绑定")
    @DeleteMapping("/by-dept/{deptId}")
    public Result<Void> clearByDept(
            @Parameter(description = "科室ID") @PathVariable Long deptId) {
        scopeService.clearByDept(deptId);
        return Result.success("已清空该科室所有指标绑定", null);
    }

    @Operation(summary = "清空某指标的全部科室绑定")
    @DeleteMapping("/by-metric/{metricCode}")
    public Result<Void> clearByMetric(
            @Parameter(description = "指标编码") @PathVariable String metricCode) {
        scopeService.clearByMetric(metricCode);
        return Result.success("已清空该指标所有科室绑定", null);
    }
}
