package com.hospital.indicator.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

/**
 * 指标树形结构DTO
 *
 * @author Claude
 * @date 2025-12-30
 */
@Data
@Schema(description = "指标树形结构DTO")
public class IndicatorTreeDTO {

    @Schema(description = "指标ID")
    private Long id;

    @Schema(description = "指标编码")
    private String metricCode;

    @Schema(description = "指标名称")
    private String metricName;

    @Schema(description = "父级指标编码")
    private String parentCode;

    @Schema(description = "指标层级")
    private Integer indicatorLevel;

    @Schema(description = "是否叶子节点：0-否，1-是")
    private Integer isLeaf;

    @Schema(description = "指标类型")
    private String metricType;

    @Schema(description = "计算类型")
    private String calculationType;

    @Schema(description = "计算表达式")
    private String expression;

    @Schema(description = "关联的指标项编码")
    private String relatedItems;

    @Schema(description = "单位")
    private String unit;

    @Schema(description = "是否支持科室下钻")
    private Integer supportDeptDrill;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "排序号")
    private Integer sortOrder;

    @Schema(description = "子节点列表")
    private List<IndicatorTreeDTO> children;

}
