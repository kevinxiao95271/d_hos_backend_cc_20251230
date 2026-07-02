package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.entity.report.ReportTask;
import com.hospital.indicator.mapper.report.ReportTaskMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 报告列表聚合接口
 * <p>
 * GET /api/report/list  — 报告任务列表（不分页）
 * GET /api/report/page  — 报告任务列表（分页）
 */
@Tag(name = "报告列表", description = "填报任务列表聚合视图（/api/report/list、/api/report/page）")
@RestController
@RequestMapping("/api/report")
public class ReportListController {

    @Autowired
    private ReportTaskMapper reportTaskMapper;

    @Operation(summary = "报告任务列表（不分页）", description = "返回最近的填报任务摘要（最多100条）")
    @GetMapping("/list")
    public Result<List<ReportTask>> list(
            @RequestParam(required = false) String status,
            @RequestParam(required = false, defaultValue = "20") int limit) {
        LambdaQueryWrapper<ReportTask> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq(ReportTask::getStatus, status);
        }
        wrapper.orderByDesc(ReportTask::getCreateTime).last("LIMIT " + Math.min(limit, 100));
        return Result.success(reportTaskMapper.selectList(wrapper));
    }

    @Operation(summary = "报告任务列表（分页）")
    @GetMapping("/page")
    public Result<Map<String, Object>> page(
            @RequestParam(required = false) String status,
            @RequestParam(required = false, defaultValue = "1")  int current,
            @RequestParam(required = false, defaultValue = "10") int size) {
        Page<ReportTask> p = new Page<>(current, size);
        LambdaQueryWrapper<ReportTask> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq(ReportTask::getStatus, status);
        }
        wrapper.orderByDesc(ReportTask::getCreateTime);
        IPage<ReportTask> result = reportTaskMapper.selectPage(p, wrapper);

        Map<String, Object> paged = new LinkedHashMap<>();
        paged.put("records", result.getRecords());
        paged.put("total",   result.getTotal());
        paged.put("pages",   result.getPages());
        paged.put("current", result.getCurrent());
        paged.put("size",    result.getSize());
        return Result.success(paged);
    }
}
