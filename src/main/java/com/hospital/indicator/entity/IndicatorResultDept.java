package com.hospital.indicator.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 指标科室下钻结果实体类
 *
 * @author Claude
 * @date 2025-12-30
 */
@Data
@TableName("t_indicator_result_dept")
@Schema(description = "指标科室下钻结果")
public class IndicatorResultDept implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "关联的指标结果ID")
    @TableField(value = "result_id", insertStrategy = FieldStrategy.NOT_NULL)
    private Long resultId;

    @Schema(description = "指标编码")
    @TableField("metric_code")
    private String metricCode;

    @Schema(description = "时间维度")
    @TableField("time_dimension")
    private String timeDimension;

    @Schema(description = "时间值")
    @TableField("time_value")
    private String timeValue;

    @Schema(description = "科室编码")
    @TableField("dept_code")
    private String deptCode;

    @Schema(description = "科室名称")
    @TableField("dept_name")
    private String deptName;

    @Schema(description = "科室维度计算结果值")
    @TableField("result_value")
    private BigDecimal resultValue;

    @Schema(description = "完整结果JSON")
    @TableField("result_json")
    private String resultJson;

    @Schema(description = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

}
