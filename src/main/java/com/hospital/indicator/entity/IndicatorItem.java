package com.hospital.indicator.entity;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 指标项实体类
 *
 * @author Claude
 * @date 2025-12-30
 */
@Data
@TableName("t_indicator_item")
@Schema(description = "指标项")
public class IndicatorItem implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "主键ID")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "指标项编码（如 a0050）")
    @TableField("item_code")
    private String itemCode;

    @Schema(description = "指标项名称")
    @TableField("item_name")
    private String itemName;

    @Schema(description = "指标项类型：COLLECTED(采集)、CALCULATED(计算)")
    @TableField("item_type")
    private String itemType;

    @Schema(description = "数据源表名")
    @TableField("data_source")
    private String dataSource;

    @Schema(description = "SQL查询语句（支持参数占位符 #{startDate}、#{endDate}）")
    @TableField("query_sql")
    private String querySql;

    @Schema(description = "聚合函数：COUNT、SUM、AVG、MAX、MIN")
    @TableField("aggregate_function")
    private String aggregateFunction;

    @Schema(description = "聚合字段名")
    @TableField("aggregate_field")
    private String aggregateField;

    @Schema(description = "计算条件描述")
    @TableField("calculation_condition")
    private String calculationCondition;

    @Schema(description = "单位")
    @TableField("unit")
    private String unit;

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
