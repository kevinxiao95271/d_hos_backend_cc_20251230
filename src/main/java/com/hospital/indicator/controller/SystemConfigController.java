package com.hospital.indicator.controller;

import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.entity.SystemConfig;
import com.hospital.indicator.service.SystemConfigService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 系统全局配置接口
 * <p>
 * GET  /api/system/config      查询所有配置
 * POST /api/system/config      批量更新配置
 * POST /api/system/config/{key} 更新单项配置
 */
@Tag(name = "系统配置", description = "院级全局配置管理（院名、报告标题等）")
@RestController
@RequestMapping("/api/system/config")
public class SystemConfigController {

    @Autowired
    private SystemConfigService configService;

    @Operation(summary = "查询所有系统配置")
    @GetMapping
    public Result<List<SystemConfig>> listAll() {
        return Result.success(configService.listAll());
    }

    @Operation(summary = "获取单项配置")
    @GetMapping("/{key}")
    public Result<String> getValue(@PathVariable String key) {
        return Result.success(configService.getValue(key));
    }

    @Operation(summary = "批量更新配置（仅超管）", description = "Body 为 {\"key\": \"value\"} Map，需要 dataScope=50 的管理员 token")
    @PostMapping
    public Result<Void> saveBatch(@RequestBody Map<String, String> configMap) {
        requireAdmin();
        String operator = currentUser();
        configService.saveBatch(configMap, operator);
        return Result.success();
    }

    @Operation(summary = "更新单项配置（仅超管）", description = "需要 dataScope=50 的管理员 token")
    @PostMapping("/{key}")
    public Result<Void> saveOne(@PathVariable String key, @RequestBody Map<String, String> body) {
        requireAdmin();
        String operator = currentUser();
        configService.save(key, body.get("value"), operator);
        return Result.success();
    }

    private void requireAdmin() {
        UserContext ctx = UserContext.get();
        if (ctx == null || ctx.getDataScope() == null || ctx.getDataScope() != 50) {
            throw new BusinessException(30403, "无权限：仅超级管理员（dataScope=50）可修改系统配置");
        }
    }

    private String currentUser() {
        UserContext ctx = UserContext.get();
        return ctx != null ? ctx.getUsername() : "system";
    }
}
