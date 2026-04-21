package com.hospital.indicator.service.sys;

import com.hospital.indicator.entity.sys.Menu;
import com.hospital.indicator.entity.sys.User;

import java.util.List;
import java.util.Map;

public interface AuthService {
    /**
     * 登录
     */
    Map<String, Object> login(String username);

    /**
     * 获取用户菜单树
     */
    List<Menu> getMenuTree(Long roleId);
}
