package com.hospital.indicator.mapper.sys;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hospital.indicator.entity.Indicator;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IndicatorPermissionMapper extends BaseMapper<Indicator> {
    /**
     * 根据科室ID和业务方向查询可见指标
     * @param deptId 科室ID
     * @param directions 业务方向列表（如 INPATIENT,OUTPATIENT）
     * @param pool 指标池（POOL_NATIONAL/POOL_GRADE）
     * @return 指标列表
     */
    List<Indicator> selectVisibleIndicators(
            @Param("deptId") Long deptId,
            @Param("directions") List<String> directions,
            @Param("pool") String pool);

    /**
     * 超管查询所有指标
     */
    List<Indicator> selectAllIndicators(@Param("pool") String pool);

    /**
     * 根据科室ID查询可见的指标编码列表
     * 用户在子科室时，向上查找父级科室的绑定范围
     */
    List<String> selectVisibleMetricCodes(@Param("deptId") Long deptId);
}
