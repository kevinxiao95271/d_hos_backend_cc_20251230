package com.hospital.indicator.controller;

import com.hospital.indicator.common.Result;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.entity.sys.Menu;
import com.hospital.indicator.mapper.sys.UserMapper;
import com.hospital.indicator.service.sys.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Tag(name = "身份认证与权限")
@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserMapper userMapper;

    @Operation(summary = "获取当前登录用户信息", description = "从 JWT 上下文中读取当前用户信息")
    @GetMapping("/userInfo")
    public Result<Map<String, Object>> userInfo() {
        UserContext ctx = UserContext.get();
        if (ctx == null) {
            return Result.error(30401, "未登录或 Token 已过期");
        }
        Map<String, Object> info = new HashMap<>();
        info.put("userId",    ctx.getUserId());
        info.put("username",  ctx.getUsername());
        info.put("deptId",    ctx.getDeptId());
        info.put("dataScope", ctx.getDataScope());
        // 查完整用户记录（密码字段已 @JsonIgnore）
        com.hospital.indicator.entity.sys.User user = userMapper.selectById(ctx.getUserId());
        if (user != null) {
            info.put("realName",   user.getRealName());
            info.put("roleId",     user.getRoleId());
            info.put("status",     user.getStatus());
        }
        return Result.success(info);
    }

    @Operation(summary = "登录获取Token")
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestParam String username,
                                             @RequestParam String password) {
        try {
            Map<String, Object> data = authService.login(username, password);
            return Result.success(data);
        } catch (RuntimeException e) {
            return Result.error(30401, "用户名或密码错误");
        }
    }

    @Operation(summary = "获取当前用户的菜单树")
    @GetMapping("/menus")
    public Result<List<Menu>> getMenus(@RequestParam(required = false) Long roleId) {
        if (roleId == null) {
            com.hospital.indicator.context.UserContext ctx = com.hospital.indicator.context.UserContext.get();
            if (ctx != null) {
                roleId = ctx.getUserId();
            }
        }
        return Result.success(authService.getMenuTree(roleId));
    }
}
