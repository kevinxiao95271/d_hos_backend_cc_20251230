package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.entity.sys.User;
import com.hospital.indicator.service.sys.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "用户管理")
@RestController
@RequestMapping("/system/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Operation(summary = "获取用户列表（按科室筛选）")
    @GetMapping("/list")
    public List<User> list(@RequestParam(required = false) Long deptId) {
        return userService.list(new LambdaQueryWrapper<User>()
                .eq(deptId != null, User::getDeptId, deptId));
    }

    @Operation(summary = "保存/更新用户")
    @PostMapping("/save")
    public boolean save(@RequestBody User user) {
        return userService.saveOrUpdate(user);
    }
}
