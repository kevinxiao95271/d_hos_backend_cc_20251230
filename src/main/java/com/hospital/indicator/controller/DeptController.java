package com.hospital.indicator.controller;

import com.hospital.indicator.entity.sys.Dept;
import com.hospital.indicator.service.sys.DeptService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "科室管理")
@RestController
@RequestMapping("/system/dept")
public class DeptController {

    @Autowired
    private DeptService deptService;

    @Operation(summary = "获取科室树结构")
    @GetMapping("/tree")
    public List<Dept> getTree() {
        return deptService.getDeptTree();
    }

    @Operation(summary = "获取当前用户可见的科室列表")
    @GetMapping("/list/visible")
    public List<Dept> getVisibleList() {
        return deptService.getVisibleDepts();
    }

    @Operation(summary = "新增/修改科室")
    @PostMapping("/save")
    public boolean save(@RequestBody Dept dept) {
        return deptService.saveOrUpdate(dept);
    }
}
