package com.hospital.indicator.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.dto.IndicatorSaveDTO;
import com.hospital.indicator.dto.IndicatorTreeDTO;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.mapper.IndicatorMapper;
import com.hospital.indicator.service.IndicatorService;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.mapper.sys.IndicatorPermissionMapper;
import com.hospital.indicator.service.IndicatorService;
import com.hospital.indicator.util.ExpressionParser;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 指标服务实现类
 */
@Slf4j
@Service
public class IndicatorServiceImpl extends ServiceImpl<IndicatorMapper, Indicator> implements IndicatorService {

    @Autowired
    private IndicatorPermissionMapper permissionMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Indicator saveOrUpdateIndicator(IndicatorSaveDTO dto) {
        Indicator indicator = new Indicator();
        BeanUtils.copyProperties(dto, indicator);
        // metricPool 未传时默认国考池
        if (StringUtils.isBlank(indicator.getMetricPool())) {
            indicator.setMetricPool("POOL_NATIONAL");
        }
        this.saveOrUpdate(indicator);
        return indicator;
    }

    @Override
    public List<IndicatorTreeDTO> getIndicatorTree(String metricPool) {
        UserContext user = UserContext.get();
        List<Indicator> visibleIndicators;

        if (user != null && user.getDataScope() != null && user.getDataScope() == 50) {
            // 质控科/超管：看全院所有指标，按指定池过滤
            visibleIndicators = this.list(new LambdaQueryWrapper<Indicator>()
                    .eq(Indicator::getStatus, 1)
                    .eq(StringUtils.isNotBlank(metricPool), Indicator::getMetricPool, metricPool)
                    .orderByAsc(Indicator::getSortOrder));
        } else if (user != null) {
            // 普通科室：按科室绑定和业务方向过滤
            List<String> directions = StringUtils.isNotBlank(user.getBusinessDirections())
                    ? Arrays.asList(user.getBusinessDirections().split(","))
                    : new ArrayList<>();

            visibleIndicators = permissionMapper.selectVisibleIndicators(
                    user.getDeptId(),
                    directions,
                    metricPool
            );
        } else {
            visibleIndicators = new ArrayList<>();
        }

        // 2. 转换为DTO
        List<IndicatorTreeDTO> allDtos = visibleIndicators.stream().map(this::convertToTreeDTO).collect(Collectors.toList());

        // 3. 构建树形结构
        return buildTree(allDtos, null);
    }

    @Override
    public List<Indicator> getByParentCode(String parentCode) {
        LambdaQueryWrapper<Indicator> queryWrapper = new LambdaQueryWrapper<>();
        if (StringUtils.isBlank(parentCode)) {
            queryWrapper.isNull(Indicator::getParentCode).or().eq(Indicator::getParentCode, "");
        } else {
            queryWrapper.eq(Indicator::getParentCode, parentCode);
        }
        queryWrapper.orderByAsc(Indicator::getSortOrder);
        return this.list(queryWrapper);
    }

    @Override
    public boolean validateExpression(String expression) {
        if (StringUtils.isBlank(expression)) {
            return false;
        }
        return ExpressionParser.validate(expression);
    }

    /**
     * 转换实体为树形DTO
     */
    private IndicatorTreeDTO convertToTreeDTO(Indicator entity) {
        IndicatorTreeDTO dto = new IndicatorTreeDTO();
        BeanUtils.copyProperties(entity, dto);
        dto.setChildren(new ArrayList<>());
        return dto;
    }

    /**
     * 递归构建树形结构
     *
     * @param allDtos    所有DTO列表
     * @param parentCode 父级编码（null表示顶级）
     * @return 树形结构列表
     */
    private List<IndicatorTreeDTO> buildTree(List<IndicatorTreeDTO> allDtos, String parentCode) {
        List<IndicatorTreeDTO> result = new ArrayList<>();

        for (IndicatorTreeDTO dto : allDtos) {
            // 判断是否为当前父级的子节点
            boolean isChild = (parentCode == null && StringUtils.isBlank(dto.getParentCode())) ||
                    (parentCode != null && parentCode.equals(dto.getParentCode()));

            if (isChild) {
                // 递归查找子节点
                List<IndicatorTreeDTO> children = buildTree(allDtos, dto.getMetricCode());
                dto.setChildren(children);
                result.add(dto);
            }
        }

        return result;
    }

}
