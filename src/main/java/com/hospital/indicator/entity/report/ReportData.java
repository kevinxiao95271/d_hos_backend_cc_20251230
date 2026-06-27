package com.hospital.indicator.entity.report;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("t_report_data")
@Schema(description = "填报数据明细")
public class ReportData implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "任务ID")
    @TableField("task_id")
    private Long taskId;

    @Schema(description = "科室ID")
    @TableField("dept_id")
    private Long deptId;

    @Schema(description = "指标编码")
    @TableField("metric_code")
    private String metricCode;

    @Schema(description = "指标项编码（结果行为null）")
    @TableField("item_code")
    private String itemCode;

    @Schema(description = "指标项名称（结果行为null）")
    @TableField("item_name")
    private String itemName;

    @Schema(description = "是否为结果行：1是/0否")
    @TableField("is_result_row")
    private Integer isResultRow;

    @Schema(description = "本行采用的填报方式")
    @TableField("input_mode")
    private String inputMode;

    @Schema(description = "用户填入的原始值（指标项行）")
    @TableField("input_value")
    private BigDecimal inputValue;

    @Schema(description = "最终结果值（结果行）")
    @TableField("result_value")
    private BigDecimal resultValue;

    @Schema(description = "备注")
    @TableField("remark")
    private String remark;

    @TableField(value = "save_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime saveTime;
}
