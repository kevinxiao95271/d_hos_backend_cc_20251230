package com.hospital.indicator.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.hospital.indicator.dto.IndicatorSaveDTO;
import com.hospital.indicator.dto.IndicatorTreeDTO;
import com.hospital.indicator.entity.Indicator;

import java.util.List;

/**
 * 指标服务接口
 *
 * @author Claude
 * @date 2025-12-30
 */
public interface IndicatorService extends IService<Indicator> {

    /**
     * 保存或更新指标
     *
     * @param dto 指标保存DTO
     * @return 保存后的指标
     */
    Indicator saveOrUpdateIndicator(IndicatorSaveDTO dto);

    /**
     * 查询指标树形结构
     *
     * @return 指标树
     */
    List<IndicatorTreeDTO> getIndicatorTree();

    /**
     * 根据父级编码查询子指标
     *
     * @param parentCode 父级编码
     * @return 子指标列表
     */
    List<Indicator> getByParentCode(String parentCode);

    /**
     * 校验表达式的有效性
     *
     * @param expression 表达式
     * @return 是否有效
     */
    boolean validateExpression(String expression);

}
