package com.hospital.indicator.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 指标实体类
 *
 * @author Claude
 * @date 2025-12-30
 */
@Data
@TableName("t_indicator")
@Schema(description = "指标")
public class Indicator implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "指标编码（如 10.3.1）")
    @TableField("metric_code")
    private String metricCode;

    @Schema(description = "指标名称")
    @TableField("metric_name")
    private String metricName;

    @Schema(description = "父级指标编码")
    @TableField("parent_code")
    private String parentCode;

    @Schema(description = "指标层级")
    @TableField("indicator_level")
    private Integer indicatorLevel;

    @Schema(description = "是否叶子节点：0-否，1-是")
    @TableField("is_leaf")
    private Integer isLeaf;

    @Schema(description = "指标类型：QUANTITATIVE(定量)、QUALITATIVE(定性)")
    @TableField("metric_type")
    private String metricType;

    @Schema(description = "计算类型：ITEM(指标项)、EXPRESSION(表达式)")
    @TableField("calculation_type")
    private String calculationType;

    @Schema(description = "计算表达式")
    @TableField("expression")
    private String expression;

    @Schema(description = "关联的指标项编码（JSON数组）")
    @TableField("related_items")
    private String relatedItems;

    @Schema(description = "单位")
    @TableField("unit")
    private String unit;

    @Schema(description = "是否支持科室下钻：0-否，1-是")
    @TableField("support_dept_drill")
    private Integer supportDeptDrill;

    @Schema(description = "状态：0-禁用，1-启用")
    @TableField("status")
    private Integer status;

    @Schema(description = "备注说明")
    @TableField("remark")
    private String remark;

    @Schema(description = "排序号")
    @TableField("sort_order")
    private Integer sortOrder;

    @Schema(description = "创建时间")
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

}
