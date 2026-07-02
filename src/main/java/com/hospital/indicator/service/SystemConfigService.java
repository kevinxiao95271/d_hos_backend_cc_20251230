package com.hospital.indicator.service;

import com.hospital.indicator.entity.SystemConfig;

import java.util.List;
import java.util.Map;

/**
 * 系统全局配置 Service
 */
public interface SystemConfigService {

    /** 获取单项配置值，不存在时返回 null */
    String getValue(String key);

    /** 获取单项配置值，不存在时返回 defaultValue */
    String getValue(String key, String defaultValue);

    /** 获取所有配置列表 */
    List<SystemConfig> listAll();

    /** 批量保存/更新配置（key -> value） */
    void saveBatch(Map<String, String> configMap, String operator);

    /** 保存单项配置 */
    void save(String key, String value, String operator);
}
