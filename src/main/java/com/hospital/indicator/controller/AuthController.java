package com.hospital.indicator.controller;

import com.hospital.indicator.entity.sys.Menu;
import com.hospital.indicator.entity.sys.User;
import com.hospital.indicator.service.sys.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Tag(name = "身份认证与权限")
@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @Operation(summary = "登录获取Token")
    @PostMapping("/login")
    public Map<String, Object> login(@RequestParam String username) {
        return authService.login(username);
    }

    @Operation(summary = "获取当前用户的菜单树")
    @GetMapping("/menus")
    public List<Menu> getMenus(@RequestParam Long roleId) {
        return authService.getMenuTree(roleId);
    }
}
