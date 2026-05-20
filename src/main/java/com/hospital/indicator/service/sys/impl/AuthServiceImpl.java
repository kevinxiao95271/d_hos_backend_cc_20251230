package com.hospital.indicator.service.sys.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.entity.sys.Dept;
import com.hospital.indicator.entity.sys.Menu;
import com.hospital.indicator.entity.sys.User;
import com.hospital.indicator.mapper.sys.DeptMapper;
import com.hospital.indicator.mapper.sys.MenuMapper;
import com.hospital.indicator.mapper.sys.UserMapper;
import com.hospital.indicator.service.sys.AuthService;
import com.hospital.indicator.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private MenuMapper menuMapper;

    @Autowired
    private DeptMapper deptMapper;

    @Autowired
    private JwtUtils jwtUtils;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public Map<String, Object> login(String username, String password) {
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>().eq(User::getUsername, username));
        if (user == null) {
            throw new RuntimeException("用户名或密码错误");
        }
        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }

        Dept dept = deptMapper.selectById(user.getDeptId());

        // 构造 JWT 负载
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", user.getUserId());
        claims.put("sub", user.getUsername());
        claims.put("deptId", user.getDeptId());
        claims.put("dataScope", user.getDataScope());

        // 业务方向：优先取个人偏好，为空则取科室默认
        String businessDirections = user.getBusinessDirectionPreference();
        if (businessDirections == null && dept != null) {
            businessDirections = dept.getDefaultBusinessDirection();
        }
        claims.put("businessDirections", businessDirections);

        String token = jwtUtils.createToken(claims);

        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("user", user);
        return result;
    }

    @Override
    public List<Menu> getMenuTree(Long roleId) {
        List<Menu> menus = menuMapper.selectMenusByRoleId(roleId);
        return buildMenuTree(menus, 0L);
    }

    private List<Menu> buildMenuTree(List<Menu> menus, Long parentId) {
        return menus.stream()
                .filter(m -> m.getParentId().equals(parentId))
                .map(m -> {
                    // 这里可以扩展给 Menu 实体增加 children 列表，或者由前端处理
                    return m;
                })
                .collect(Collectors.toList());
    }
}
