package com.hospital.indicator.entity.report;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;

@Data
@TableName("t_report_template_item")
@Schema(description = "填报模板明细")
public class ReportTemplateItem implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "模板ID")
    @TableField("template_id")
    private Long templateId;

    @Schema(description = "科室ID")
    @TableField("dept_id")
    private Long deptId;

    @Schema(description = "科室名称")
    @TableField("dept_name")
    private String deptName;

    @Schema(description = "分配的指标编码列表（JSON数组）")
    @TableField("metric_codes")
    private String metricCodes;
}
