package com.hospital.indicator.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.common.Result;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.entity.sys.Dept;
import com.hospital.indicator.entity.sys.Role;
import com.hospital.indicator.entity.sys.User;
import com.hospital.indicator.mapper.sys.RoleMapper;
import com.hospital.indicator.service.sys.DeptService;
import com.hospital.indicator.service.sys.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 系统管理别名控制器
 * <p>
 * 提供前端常用的复数路径别名：
 *   GET  /system/users   → 用户列表
 *   GET  /system/depts   → 科室列表
 *   GET  /system/roles   → 角色列表
 *   POST /system/roles/save → 保存角色
 */
@Tag(name = "系统管理", description = "用户/科室/角色管理（别名路径）")
@RestController
@RequestMapping("/system")
public class SystemController {

    @Autowired
    private UserService userService;

    @Autowired
    private DeptService deptService;

    @Autowired
    private RoleMapper roleMapper;

    /** 仅超管（dataScope=50）可调用管理接口，否则抛 403 */
    private void requireAdmin() {
        UserContext user = UserContext.get();
        if (user == null || !Integer.valueOf(50).equals(user.getDataScope())) {
            throw new BusinessException(30403, "无权限：该接口仅超级管理员可用");
        }
    }

    /* ───────────── 用户 ───────────── */

    @Operation(summary = "用户列表（仅超管）", description = "仅 dataScope=50 的超级管理员可访问")
    @GetMapping("/users")
    public Result<List<User>> users(@RequestParam(required = false) Long deptId) {
        requireAdmin();
        List<User> list = userService.list(new LambdaQueryWrapper<User>()
                .eq(deptId != null, User::getDeptId, deptId)
                .orderByAsc(User::getUserId));
        return Result.success(list);
    }

    /* ───────────── 科室 ───────────── */

    @Operation(summary = "科室列表（仅超管）", description = "仅 dataScope=50 的超级管理员可访问")
    @GetMapping("/depts")
    public Result<List<Dept>> depts() {
        requireAdmin();
        return Result.success(deptService.getDeptTree());
    }

    /* ───────────── 角色 ───────────── */

    @Operation(summary = "角色列表（仅超管）", description = "仅 dataScope=50 的超级管理员可访问")
    @GetMapping("/roles")
    public Result<List<Role>> roles() {
        requireAdmin();
        List<Role> list = roleMapper.selectList(new LambdaQueryWrapper<Role>()
                .orderByAsc(Role::getRoleSort));
        return Result.success(list);
    }

    @Operation(summary = "保存/更新角色（仅超管）")
    @PostMapping("/roles/save")
    public Result<Boolean> saveRole(@RequestBody Role role) {
        requireAdmin();
        if (role.getRoleId() == null) {
            return Result.success(roleMapper.insert(role) > 0);
        } else {
            return Result.success(roleMapper.updateById(role) > 0);
        }
    }
}
