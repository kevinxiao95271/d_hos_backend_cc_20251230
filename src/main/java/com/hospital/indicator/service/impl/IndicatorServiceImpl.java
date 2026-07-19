package com.hospital.indicator.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONException;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.common.ErrorCode;
import com.hospital.indicator.dto.IndicatorSaveDTO;
import com.hospital.indicator.dto.IndicatorTreeDTO;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.mapper.IndicatorMapper;
import com.hospital.indicator.service.IndicatorService;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.mapper.sys.IndicatorPermissionMapper;
import com.hospital.indicator.util.ExpressionParser;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 指标服务实现类
 */
@Slf4j
@Service
public class IndicatorServiceImpl extends ServiceImpl<IndicatorMapper, Indicator> implements IndicatorService {

    private static final Set<String> METRIC_TYPES =
            new HashSet<>(Arrays.asList("QUANTITATIVE", "QUALITATIVE"));
    private static final Set<String> CALCULATION_TYPES =
            new HashSet<>(Arrays.asList("NONE", "ITEM", "EXPRESSION"));
    private static final Set<String> INPUT_TYPES =
            new HashSet<>(Arrays.asList("AUTO", "MANUAL"));
    private static final Set<String> METRIC_POOLS =
            new HashSet<>(Arrays.asList("POOL_NATIONAL", "POOL_GRADE"));
    private static final Set<String> MONITOR_DIRECTIONS =
            new HashSet<>(Arrays.asList("INCREASE", "DECREASE", "MONITOR"));

    @Autowired
    private IndicatorPermissionMapper permissionMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Indicator saveOrUpdateIndicator(IndicatorSaveDTO dto) {
        normalize(dto);
        validateBasicValues(dto);

        Indicator existing = null;
        if (dto.getId() != null) {
            existing = this.getById(dto.getId());
            if (existing == null) {
                throw new BusinessException(ErrorCode.NOT_FOUND, "指标不存在，id=" + dto.getId());
            }
            if (!existing.getMetricCode().equals(dto.getMetricCode())) {
                throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                        "更新指标时不允许修改 metricCode，请新建指标或保持原编码");
            }
        }

        Indicator sameCode = this.getOne(new LambdaQueryWrapper<Indicator>()
                .eq(Indicator::getMetricCode, dto.getMetricCode())
                .last("LIMIT 1"));
        if (sameCode != null && (dto.getId() == null || !sameCode.getId().equals(dto.getId()))) {
            throw new BusinessException(ErrorCode.INDICATOR_CODE_DUPLICATE,
                    "指标编码已存在：" + dto.getMetricCode());
        }

        validateAndFillHierarchy(dto);
        validateTypeCombination(dto);

        Indicator indicator = new Indicator();
        BeanUtils.copyProperties(dto, indicator);
        try {
            this.saveOrUpdate(indicator);
        } catch (DuplicateKeyException e) {
            throw new BusinessException(ErrorCode.INDICATOR_CODE_DUPLICATE,
                    "指标编码已存在：" + dto.getMetricCode());
        }
        return indicator;
    }

    private void normalize(IndicatorSaveDTO dto) {
        dto.setMetricCode(StringUtils.trim(dto.getMetricCode()));
        dto.setMetricName(StringUtils.trim(dto.getMetricName()));
        dto.setParentCode(StringUtils.trimToNull(dto.getParentCode()));
        dto.setMetricType(StringUtils.upperCase(StringUtils.trim(dto.getMetricType())));
        dto.setCalculationType(StringUtils.upperCase(StringUtils.trim(dto.getCalculationType())));
        dto.setInputType(StringUtils.upperCase(StringUtils.defaultIfBlank(
                StringUtils.trim(dto.getInputType()), "AUTO")));
        dto.setMetricPool(StringUtils.upperCase(StringUtils.defaultIfBlank(
                StringUtils.trim(dto.getMetricPool()), "POOL_NATIONAL")));
        dto.setMonitorDirection(StringUtils.upperCase(StringUtils.trimToNull(dto.getMonitorDirection())));
        dto.setBusinessDirection(StringUtils.trimToNull(dto.getBusinessDirection()));
    }

    private void validateBasicValues(IndicatorSaveDTO dto) {
        if (!METRIC_TYPES.contains(dto.getMetricType())) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "metricType 仅支持 QUANTITATIVE 或 QUALITATIVE");
        }
        if (!CALCULATION_TYPES.contains(dto.getCalculationType())) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "calculationType 仅支持 NONE、ITEM 或 EXPRESSION");
        }
        if (!INPUT_TYPES.contains(dto.getInputType())) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "inputType 仅支持 AUTO 或 MANUAL");
        }
        if (!METRIC_POOLS.contains(dto.getMetricPool())) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "metricPool 仅支持 POOL_NATIONAL 或 POOL_GRADE");
        }
        if (dto.getMonitorDirection() != null
                && !MONITOR_DIRECTIONS.contains(dto.getMonitorDirection())) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "monitorDirection 仅支持 INCREASE、DECREASE 或 MONITOR");
        }
        if (dto.getIsLeaf() == null || (dto.getIsLeaf() != 0 && dto.getIsLeaf() != 1)) {
            throw new BusinessException(ErrorCode.PARAM_INVALID, "isLeaf 仅支持 0 或 1");
        }
        if (dto.getStatus() == null || (dto.getStatus() != 0 && dto.getStatus() != 1)) {
            throw new BusinessException(ErrorCode.PARAM_INVALID, "status 仅支持 0 或 1");
        }
        if (dto.getSupportDeptDrill() != null
                && dto.getSupportDeptDrill() != 0 && dto.getSupportDeptDrill() != 1) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "supportDeptDrill 仅支持 0 或 1");
        }
    }

    private void validateAndFillHierarchy(IndicatorSaveDTO dto) {
        if (dto.getId() != null && Integer.valueOf(1).equals(dto.getIsLeaf())) {
            long childCount = this.count(new LambdaQueryWrapper<Indicator>()
                    .eq(Indicator::getParentCode, dto.getMetricCode()));
            if (childCount > 0) {
                throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                        "当前指标已有子节点，不能设置为叶子节点");
            }
        }
        if (StringUtils.isBlank(dto.getParentCode())) {
            dto.setIndicatorLevel(1);
            return;
        }
        if (dto.getMetricCode().equals(dto.getParentCode())) {
            throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                    "指标不能将自身设置为父级");
        }

        Indicator parent = this.getOne(new LambdaQueryWrapper<Indicator>()
                .eq(Indicator::getMetricCode, dto.getParentCode())
                .last("LIMIT 1"));
        if (parent == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND,
                    "父级指标不存在，parentCode=" + dto.getParentCode());
        }
        if (Integer.valueOf(1).equals(parent.getIsLeaf())) {
            throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                    "父级指标必须是非叶子节点，parentCode=" + dto.getParentCode());
        }
        if (!dto.getMetricPool().equals(parent.getMetricPool())) {
            throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                    "子指标与父级指标必须属于同一指标池");
        }
        Indicator ancestor = parent;
        while (ancestor != null && StringUtils.isNotBlank(ancestor.getParentCode())) {
            if (dto.getMetricCode().equals(ancestor.getParentCode())) {
                throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                        "parentCode 会形成循环层级，禁止保存");
            }
            ancestor = this.getOne(new LambdaQueryWrapper<Indicator>()
                    .eq(Indicator::getMetricCode, ancestor.getParentCode())
                    .last("LIMIT 1"));
        }
        dto.setIndicatorLevel((parent.getIndicatorLevel() == null
                ? 1 : parent.getIndicatorLevel()) + 1);
    }

    private void validateTypeCombination(IndicatorSaveDTO dto) {
        boolean leaf = Integer.valueOf(1).equals(dto.getIsLeaf());
        if (!leaf) {
            if (!"NONE".equals(dto.getCalculationType())) {
                throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                        "非叶子节点的 calculationType 必须为 NONE");
            }
            dto.setExpression(null);
            dto.setRelatedItems(null);
            return;
        }

        if ("MANUAL".equals(dto.getInputType())) {
            if (!"NONE".equals(dto.getCalculationType())) {
                throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                        "手工填报指标的 calculationType 必须为 NONE");
            }
            return;
        }

        if (!"ITEM".equals(dto.getCalculationType())
                && !"EXPRESSION".equals(dto.getCalculationType())) {
            throw new BusinessException(ErrorCode.INDICATOR_CONFIG_CONFLICT,
                    "自动采集叶子指标的 calculationType 必须为 ITEM 或 EXPRESSION");
        }
        if (StringUtils.isBlank(dto.getExpression())) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "自动采集叶子指标必须填写 expression");
        }
        if (!ExpressionParser.validate(dto.getExpression())) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "expression 格式无效，请使用指标项编码和四则运算符");
        }
        if (StringUtils.isBlank(dto.getRelatedItems())) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "自动采集叶子指标必须填写 relatedItems JSON 数组");
        }
        try {
            if (JSON.parseArray(dto.getRelatedItems(), String.class).isEmpty()) {
                throw new BusinessException(ErrorCode.PARAM_INVALID,
                        "relatedItems 至少包含一个指标项编码");
            }
        } catch (JSONException e) {
            throw new BusinessException(ErrorCode.PARAM_INVALID,
                    "relatedItems 必须是 JSON 字符串数组，例如 [\"a0050\",\"a0052\"]");
        }
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
