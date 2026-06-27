package com.hospital.indicator.controller;

import com.hospital.indicator.common.Result;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.dto.report.ReportConfigDTO;
import com.hospital.indicator.entity.report.ReportConfig;
import com.hospital.indicator.service.report.ReportConfigService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@Tag(name = "填报配置管理", description = "管理员维护全局填报配置")
@RestController
@RequestMapping("/api/report/config")
public class ReportConfigController {

    @Autowired
    private ReportConfigService configService;

    @Operation(summary = "获取全局填报配置")
    @GetMapping
    public Result<ReportConfig> getConfig() {
        return Result.success(configService.getConfig());
    }

    @Operation(summary = "更新全局填报配置")
    @PutMapping
    public Result<ReportConfig> updateConfig(@RequestBody @Valid ReportConfigDTO dto) {
        UserContext ctx = UserContext.get();
        String operator = ctx != null ? ctx.getUsername() : "system";
        return Result.success(configService.updateConfig(dto, operator));
    }
}
