package com.hospital.indicator.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

/**
 * 指标项保存DTO
 *
 * @author Claude
 * @date 2025-12-30
 */
@Data
@Schema(description = "指标项保存DTO")
public class IndicatorItemSaveDTO {

    @Schema(description = "主键ID（更新时必填）")
    private Long id;

    @Schema(description = "指标项编码", required = true, example = "a0050")
    @NotBlank(message = "指标项编码不能为空")
    @Pattern(regexp = "^[a-zA-Z][a-zA-Z0-9]*$", message = "指标项编码格式非法：只允许字母开头，仅含字母和数字，不得包含特殊字符或空格")
    private String itemCode;

    @Schema(description = "指标项名称", required = true)
    @NotBlank(message = "指标项名称不能为空")
    private String itemName;

    @Schema(description = "指标项类型：COLLECTED(采集)、CALCULATED(计算)", required = true)
    @NotBlank(message = "指标项类型不能为空")
    private String itemType;

    @Schema(description = "数据源表名")
    private String dataSource;

    @Schema(description = "SQL查询语句（支持参数占位符 #{startDate}、#{endDate}）")
    private String querySql;

    @Schema(description = "聚合函数：COUNT、SUM、AVG、MAX、MIN")
    private String aggregateFunction;

    @Schema(description = "聚合字段名")
    private String aggregateField;

    @Schema(description = "计算条件描述")
    private String calculationCondition;

    @Schema(description = "单位")
    private String unit;

    @Schema(description = "状态：0-禁用，1-启用", required = true)
    @NotNull(message = "状态不能为空")
    private Integer status;

    @Schema(description = "备注说明")
    private String remark;

    @Schema(description = "排序号")
    private Integer sortOrder;

}
