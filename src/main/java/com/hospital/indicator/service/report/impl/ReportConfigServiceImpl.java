package com.hospital.indicator.service.report.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.dto.report.ReportConfigDTO;
import com.hospital.indicator.entity.report.ReportConfig;
import com.hospital.indicator.mapper.report.ReportConfigMapper;
import com.hospital.indicator.service.report.ReportConfigService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Slf4j
@Service
public class ReportConfigServiceImpl implements ReportConfigService {

    private static final List<String> VALID_INPUT_MODES =
            Arrays.asList("RESULT_ONLY", "NUM_DEN", "NUM_DEN_OR_RESULT");
    private static final List<String> VALID_VERSION_STRATEGIES =
            Arrays.asList("OVERWRITE", "VERSIONED");
    private static final List<String> VALID_REVIEW_MODES =
            Arrays.asList("AUTO_APPROVE", "ADMIN_REVIEW");

    @Autowired
    private ReportConfigMapper configMapper;

    @Override
    public ReportConfig getConfig() {
        List<ReportConfig> list = configMapper.selectList(
                new LambdaQueryWrapper<ReportConfig>().orderByAsc(ReportConfig::getId).last("LIMIT 1"));
        if (list.isEmpty()) {
            throw new BusinessException("填报配置未初始化，请联系管理员");
        }
        return list.get(0);
    }

    @Override
    public ReportConfig updateConfig(ReportConfigDTO dto, String operator) {
        if (!VALID_INPUT_MODES.contains(dto.getInputMode())) {
            throw new BusinessException("填报方式不合法：" + dto.getInputMode());
        }
        if (!VALID_VERSION_STRATEGIES.contains(dto.getVersionStrategy())) {
            throw new BusinessException("版本策略不合法：" + dto.getVersionStrategy());
        }
        if (!VALID_REVIEW_MODES.contains(dto.getReviewMode())) {
            throw new BusinessException("审核流程不合法：" + dto.getReviewMode());
        }

        ReportConfig config = getConfig();
        BeanUtils.copyProperties(dto, config);
        config.setUpdateBy(operator);
        config.setUpdateTime(LocalDateTime.now());
        configMapper.updateById(config);
        log.info("填报全局配置已更新，操作人：{}", operator);
        return config;
    }
}
