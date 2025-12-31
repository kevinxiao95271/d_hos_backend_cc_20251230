package com.hospital.indicator.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 指标计算结果实体类
 *
 * @author Claude
 * @date 2025-12-30
 */
@Data
@TableName("t_indicator_result")
@Schema(description = "指标计算结果")
public class IndicatorResult implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "指标编码")
    @TableField("metric_code")
    private String metricCode;

    @Schema(description = "时间维度：YEAR(年)、QUARTER(季)、MONTH(月)、DAY(日)")
    @TableField("time_dimension")
    private String timeDimension;

    @Schema(description = "时间值（如 2025、2025-Q1、2025-01）")
    @TableField("time_value")
    private String timeValue;

    @Schema(description = "统计开始日期")
    @TableField("start_date")
    private LocalDate startDate;

    @Schema(description = "统计结束日期")
    @TableField("end_date")
    private LocalDate endDate;

    @Schema(description = "计算结果值")
    @TableField("result_value")
    private BigDecimal resultValue;

    @Schema(description = "完整结果JSON（包含所有关联指标项的值）")
    @TableField("result_json")
    private String resultJson;

    @Schema(description = "同比增长率（%）")
    @TableField("year_over_year")
    private BigDecimal yearOverYear;

    @Schema(description = "环比增长率（%）")
    @TableField("month_over_month")
    private BigDecimal monthOverMonth;

    @Schema(description = "计算状态：SUCCESS、FAILED、PENDING")
    @TableField("calculation_status")
    private String calculationStatus;

    @Schema(description = "错误信息")
    @TableField("error_message")
    private String errorMessage;

    @Schema(description = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

}
