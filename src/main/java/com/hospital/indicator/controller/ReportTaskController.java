package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.dto.report.*;
import com.hospital.indicator.entity.report.ReportTask;
import com.hospital.indicator.service.report.ReportTaskService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;
import java.util.List;

@Tag(name = "填报任务管理", description = "管理员创建、发布、关闭填报任务；管理模板；审核科室填报")
@RestController
@RequestMapping("/api/report/task")
public class ReportTaskController {

    @Autowired
    private ReportTaskService taskService;

    // ─────────── 任务 CRUD ───────────

    @Operation(summary = "创建填报任务（含科室-指标分配）")
    @PostMapping
    public Result<ReportTask> createTask(@RequestBody @Valid ReportTaskCreateDTO dto) {
        String operator = getOperator();
        return Result.success(taskService.createTask(dto, operator));
    }

    @Operation(summary = "从模板一键下发任务")
    @PostMapping("/from-template/{templateId}")
    public Result<ReportTask> createFromTemplate(
            @PathVariable Long templateId,
            @RequestBody @Valid ReportTaskCreateDTO baseInfo) {
        return Result.success(taskService.createFromTemplate(templateId, baseInfo, getOperator()));
    }

    @Operation(summary = "分页查询任务列表")
    @GetMapping("/page")
    public Result<IPage<ReportTask>> pageTask(
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") int current,
            @Parameter(description = "每页条数") @RequestParam(defaultValue = "10") int size,
            @Parameter(description = "任务名称（模糊）") @RequestParam(required = false) String name,
            @Parameter(description = "任务状态") @RequestParam(required = false) String status,
            @Parameter(description = "时间维度") @RequestParam(required = false) String timeDimension) {
        return Result.success(taskService.pageTask(current, size, name, status, timeDimension));
    }

    @Operation(summary = "查询任务详情（含科室填报范围与状态）")
    @GetMapping("/{taskId}")
    public Result<ReportTaskDetailVO> getDetail(@PathVariable Long taskId) {
        return Result.success(taskService.getTaskDetail(taskId));
    }

    @Operation(summary = "发布任务（DRAFT → PUBLISHED）")
    @PostMapping("/{taskId}/publish")
    public Result<Void> publishTask(@PathVariable Long taskId) {
        taskService.publishTask(taskId, getOperator());
        return Result.success();
    }

    @Operation(summary = "关闭任务（PUBLISHED → CLOSED）")
    @PostMapping("/{taskId}/close")
    public Result<Void> closeTask(@PathVariable Long taskId) {
        taskService.closeTask(taskId, getOperator());
        return Result.success();
    }

    // ─────────── 模板 ───────────

    @Operation(summary = "将任务分配方案另存为模板")
    @PostMapping("/{taskId}/save-as-template")
    public Result<Long> saveAsTemplate(
            @PathVariable Long taskId,
            @RequestParam String templateName) {
        return Result.success(taskService.saveAsTemplate(taskId, templateName, getOperator()));
    }

    @Operation(summary = "查看模板中的科室分配明细")
    @GetMapping("/template/{templateId}/scopes")
    public Result<List<ReportTaskDetailVO.ScopeVO>> listTemplateScopes(@PathVariable Long templateId) {
        return Result.success(taskService.listTemplateScopes(templateId));
    }

    // ─────────── 审核 ───────────

    @Operation(summary = "管理员审核科室填报（通过/打回）")
    @PostMapping("/review")
    public Result<Void> review(@RequestBody @Valid ReviewActionDTO dto) {
        taskService.reviewDeptFill(dto, getOperator());
        return Result.success();
    }

    // ─────────── 导出模板 ───────────

    @Operation(summary = "导出空白填报模板（科室下载用）")
    @GetMapping("/export-template")
    public void exportFillTemplate(
            @RequestParam Long taskId,
            @RequestParam Long deptId,
            HttpServletResponse response) throws IOException {
        taskService.exportFillTemplate(taskId, deptId, response);
    }

    private String getOperator() {
        UserContext ctx = UserContext.get();
        return ctx != null ? ctx.getUsername() : "system";
    }
}
