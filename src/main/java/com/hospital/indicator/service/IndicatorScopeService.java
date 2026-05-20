package com.hospital.indicator.service;

import com.hospital.indicator.entity.IndicatorDeptScope;

import java.util.List;

/**
 * 指标科室可见范围配置 Service
 */
public interface IndicatorScopeService {

    /**
     * 查询某科室绑定的全部记录（含指标详情）
     */
    List<IndicatorDeptScope> listByDept(Long deptId);

    /**
     * 查询某指标绑定的全部科室记录
     */
    List<IndicatorDeptScope> listByMetric(String metricCode);

    /**
     * 新增单条绑定（重复则忽略）
     */
    void addBinding(Long deptId, String metricCode, Integer isPrimaryOwner);

    /**
     * 批量覆盖某科室的指标绑定（先删再插）
     */
    void replaceByDept(Long deptId, List<String> metricCodes, Integer isPrimaryOwner);

    /**
     * 批量覆盖某指标的科室绑定（先删再插）
     */
    void replaceByMetric(String metricCode, List<Long> deptIds, Integer isPrimaryOwner);

    /**
     * 删除单条绑定
     */
    void removeBinding(Long deptId, String metricCode);

    /**
     * 清空某科室的全部绑定
     */
    void clearByDept(Long deptId);

    /**
     * 清空某指标的全部科室绑定
     */
    void clearByMetric(String metricCode);
}
