package com.hospital.indicator.service;

import com.hospital.indicator.entity.IndicatorResult;
import com.hospital.indicator.entity.IndicatorResultDept;

import java.time.LocalDate;
import java.util.List;

/**
 * 指标计算引擎服务接口
 *
 * @author Claude
 * @date 2025-12-30
 */
public interface IndicatorCalculationService {

    /**
     * 计算单个指标
     *
     * @param metricCode     指标编码
     * @param timeDimension  时间维度：YEAR、QUARTER、MONTH、DAY
     * @param startDate      开始日期
     * @param endDate        结束日期
     * @return 计算结果
     */
    IndicatorResult calculateIndicator(String metricCode, String timeDimension, LocalDate startDate, LocalDate endDate);

    /**
     * 批量计算指标（按时间范围）
     * 根据时间维度自动拆分为多个时间段进行计算
     * 例如：timeDimension=MONTH时，会按月拆分计算
     *
     * @param metricCodes    指标编码列表（null表示计算所有叶子指标）
     * @param timeDimension  时间维度
     * @param startDate      开始日期
     * @param endDate        结束日期
     * @return 计算结果列表
     */
    List<IndicatorResult> batchCalculateIndicators(List<String> metricCodes, String timeDimension, LocalDate startDate, LocalDate endDate);

    /**
     * 计算指标的科室下钻数据
     *
     * @param metricCode     指标编码
     * @param timeDimension  时间维度
     * @param startDate      开始日期
     * @param endDate        结束日期
     * @return 科室下钻计算结果列表
     */
    List<IndicatorResultDept> calculateDeptDrill(String metricCode, String timeDimension, LocalDate startDate, LocalDate endDate);

}
