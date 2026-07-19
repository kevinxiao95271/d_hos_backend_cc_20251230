package com.hospital.indicator.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 指标保存DTO
 *
 * @author Claude
 * @date 2025-12-30
 */
@Data
@Schema(description = "指标保存DTO")
public class IndicatorSaveDTO {

    @Schema(description = "主键ID（更新时必填）")
    private Long id;

    @Schema(description = "指标编码", required = true, example = "10.3.1")
    @NotBlank(message = "指标编码不能为空")
    private String metricCode;

    @Schema(description = "指标名称", required = true)
    @NotBlank(message = "指标名称不能为空")
    private String metricName;

    @Schema(description = "父级指标编码", example = "10.3")
    private String parentCode;

    @Schema(description = "指标层级（后端根据父级自动计算，前端可不传）", example = "3")
    private Integer indicatorLevel;

    @Schema(description = "是否叶子节点：0-否，1-是", required = true)
    @NotNull(message = "是否叶子节点不能为空")
    private Integer isLeaf;

    @Schema(description = "指标类型：QUANTITATIVE(定量)、QUALITATIVE(定性)", required = true)
    @NotBlank(message = "指标类型不能为空")
    private String metricType;

    @Schema(description = "计算类型：NONE(非叶子/手工指标)、ITEM(单指标项)、EXPRESSION(表达式)", required = true,
            allowableValues = {"NONE", "ITEM", "EXPRESSION"})
    @NotBlank(message = "计算类型不能为空")
    private String calculationType;

    @Schema(description = "计算表达式", example = "a0052/a0050 或 SUM(a0050)/SUM(a0052)")
    private String expression;

    @Schema(description = "关联的指标项编码（JSON数组）", example = "[\"a0050\",\"a0052\"]")
    private String relatedItems;

    @Schema(description = "单位")
    private String unit;

    @Schema(description = "是否支持科室下钻：0-否，1-是")
    private Integer supportDeptDrill;

    @Schema(description = "状态：0-禁用，1-启用", required = true)
    @NotNull(message = "状态不能为空")
    private Integer status;

    @Schema(description = "备注说明")
    private String remark;

    @Schema(description = "排序号")
    private Integer sortOrder;

    @Schema(description = "指标池：POOL_NATIONAL(国考)、POOL_GRADE(等级评审)", example = "POOL_NATIONAL")
    private String metricPool;

    @Schema(description = "指标数据来源类型：AUTO=自动采集计算，MANUAL=手工填报", example = "AUTO")
    private String inputType;

    @Schema(description = "业务方向，多个值用逗号分隔", example = "INPATIENT,OUTPATIENT")
    private String businessDirection;

    @Schema(description = "指标分类：医疗质量、运营效率、财务成本、患者安全等", example = "医疗质量")
    private String metricCategory;

    @Schema(description = "目标值（用于达标率/质检判断）", example = "0.005")
    private java.math.BigDecimal targetValue;

    @Schema(description = "监测方向：INCREASE(逐步提高) / DECREASE(逐步降低) / MONITOR(仅监测)",
            example = "DECREASE", allowableValues = {"INCREASE", "DECREASE", "MONITOR"})
    private String monitorDirection;

}
