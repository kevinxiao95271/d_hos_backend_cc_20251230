package com.hospital.indicator.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.dto.IndicatorSaveDTO;
import com.hospital.indicator.dto.IndicatorTreeDTO;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.mapper.IndicatorMapper;
import com.hospital.indicator.service.IndicatorService;
import com.hospital.indicator.util.ExpressionParser;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 指标服务实现类
 *
 * @author Claude
 * @date 2025-12-30
 */
@Slf4j
@Service
public class IndicatorServiceImpl extends ServiceImpl<IndicatorMapper, Indicator> implements IndicatorService {

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Indicator saveOrUpdateIndicator(IndicatorSaveDTO dto) {
        // 1. 校验指标编码唯一性
        LambdaQueryWrapper<Indicator> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Indicator::getMetricCode, dto.getMetricCode());
        if (dto.getId() != null) {
            queryWrapper.ne(Indicator::getId, dto.getId());
        }
        if (this.count(queryWrapper) > 0) {
            throw new BusinessException("指标编码已存在：" + dto.getMetricCode());
        }

        // 2. 如果是叶子节点且有表达式，校验表达式有效性
        if (dto.getIsLeaf() == 1 && StringUtils.isNotBlank(dto.getExpression())) {
            if (!validateExpression(dto.getExpression())) {
                throw new BusinessException("表达式格式不正确");
            }

            // 3. 自动提取表达式中的指标项编码
            List<String> itemCodes = ExpressionParser.extractItemCodes(dto.getExpression());
            if (!itemCodes.isEmpty()) {
                // 转换为JSON数组格式
                dto.setRelatedItems(com.alibaba.fastjson.JSON.toJSONString(itemCodes));
            }
        }

        // 4. 如果有父级编码，自动计算层级
        if (StringUtils.isNotBlank(dto.getParentCode())) {
            LambdaQueryWrapper<Indicator> parentWrapper = new LambdaQueryWrapper<>();
            parentWrapper.eq(Indicator::getMetricCode, dto.getParentCode());
            Indicator parent = this.getOne(parentWrapper);
            if (parent != null) {
                dto.setIndicatorLevel(parent.getIndicatorLevel() + 1);
            }
        } else {
            // 顶级指标，层级为1
            dto.setIndicatorLevel(1);
        }

        // 5. 转换DTO为实体
        Indicator entity = new Indicator();
        BeanUtils.copyProperties(dto, entity);

        // 6. 保存或更新
        this.saveOrUpdate(entity);
        return entity;
    }

    @Override
    public List<IndicatorTreeDTO> getIndicatorTree() {
        // 1. 查询所有启用的指标
        LambdaQueryWrapper<Indicator> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Indicator::getStatus, 1);
        queryWrapper.orderByAsc(Indicator::getSortOrder);
        List<Indicator> allIndicators = this.list(queryWrapper);

        // 2. 转换为DTO
        List<IndicatorTreeDTO> allDtos = allIndicators.stream().map(this::convertToTreeDTO).collect(Collectors.toList());

        // 3. 构建树形结构（从顶级节点开始）
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
