package com.hospital.indicator.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hospital.indicator.entity.IndicatorDeptScope;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 指标科室可见范围 Mapper
 */
@Mapper
public interface IndicatorDeptScopeMapper extends BaseMapper<IndicatorDeptScope> {

    /**
     * 查询某个科室绑定的所有指标编码
     */
    List<String> selectMetricCodesByDeptId(@Param("deptId") Long deptId);

    /**
     * 查询某个指标绑定的所有科室ID
     */
    List<Long> selectDeptIdsByMetricCode(@Param("metricCode") String metricCode);

    /**
     * 删除某科室的全部绑定（用于批量替换）
     */
    int deleteByDeptId(@Param("deptId") Long deptId);

    /**
     * 删除某指标的全部科室绑定
     */
    int deleteByMetricCode(@Param("metricCode") String metricCode);
}
