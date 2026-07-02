package com.hospital.indicator.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.hospital.indicator.entity.SystemConfig;
import com.hospital.indicator.mapper.SystemConfigMapper;
import com.hospital.indicator.service.SystemConfigService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class SystemConfigServiceImpl implements SystemConfigService {

    @Autowired
    private SystemConfigMapper configMapper;

    @Override
    public String getValue(String key) {
        return getValue(key, null);
    }

    @Override
    public String getValue(String key, String defaultValue) {
        SystemConfig config = configMapper.selectOne(
                new LambdaQueryWrapper<SystemConfig>().eq(SystemConfig::getConfigKey, key));
        return config != null && config.getConfigValue() != null
                ? config.getConfigValue()
                : defaultValue;
    }

    @Override
    public List<SystemConfig> listAll() {
        return configMapper.selectList(null);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveBatch(Map<String, String> configMap, String operator) {
        configMap.forEach((k, v) -> save(k, v, operator));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void save(String key, String value, String operator) {
        SystemConfig existing = configMapper.selectOne(
                new LambdaQueryWrapper<SystemConfig>().eq(SystemConfig::getConfigKey, key));
        if (existing == null) {
            SystemConfig config = new SystemConfig();
            config.setConfigKey(key);
            config.setConfigValue(value);
            config.setUpdateBy(operator);
            configMapper.insert(config);
        } else {
            configMapper.update(null, new LambdaUpdateWrapper<SystemConfig>()
                    .eq(SystemConfig::getConfigKey, key)
                    .set(SystemConfig::getConfigValue, value)
                    .set(SystemConfig::getUpdateBy, operator)
                    .set(SystemConfig::getUpdateTime, LocalDateTime.now()));
        }
        log.info("系统配置已更新 key={} operator={}", key, operator);
    }
}
