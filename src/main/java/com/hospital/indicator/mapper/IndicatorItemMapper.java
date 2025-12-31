package com.hospital.indicator.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hospital.indicator.entity.IndicatorItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 指标项 Mapper
 *
 * @author Claude
 * @date 2025-12-30
 */
@Mapper
public interface IndicatorItemMapper extends BaseMapper<IndicatorItem> {

    /**
     * 执行动态SQL查询（用于指标项数据采集）
     *
     * @param sql SQL语句
     * @return 查询结果
     */
    List<Map<String, Object>> executeDynamicQuery(@Param("sql") String sql);

    /**
     * 执行单值查询（返回单个数值结果）
     *
     * @param sql SQL语句
     * @return 数值结果
     */
    Object executeSingleValueQuery(@Param("sql") String sql);

}
