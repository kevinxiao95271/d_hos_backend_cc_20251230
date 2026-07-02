package com.hospital.indicator.controller;

import com.hospital.indicator.common.Result;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 数据填报列表接口（聚合视图，功能规划中）
 * 注意：具体填报操作请使用 /api/report/data/* 接口
 */
@Tag(name = "数据填报管理", description = "数据填报列表聚合视图")
@RestController
@RequestMapping("/api/data-entry")
public class DataEntryController {

    @Operation(summary = "数据填报列表（不分页）")
    @GetMapping("/list")
    public Result<List<Object>> list(
            @RequestParam(required = false) Long taskId,
            @RequestParam(required = false) Long deptId) {
        return Result.success(Collections.emptyList());
    }

    @Operation(summary = "数据填报列表（分页）")
    @GetMapping("/page")
    public Result<Map<String, Object>> page(
            @RequestParam(required = false) Long taskId,
            @RequestParam(required = false) Long deptId,
            @RequestParam(required = false, defaultValue = "1")  int current,
            @RequestParam(required = false, defaultValue = "10") int size) {
        Map<String, Object> paged = new LinkedHashMap<>();
        paged.put("records", Collections.emptyList());
        paged.put("total",   0);
        paged.put("pages",   0);
        paged.put("current", current);
        paged.put("size",    size);
        return Result.success(paged);
    }
}
