package com.hospital.indicator.entity.report;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@TableName("t_report_task_scope")
@Schema(description = "填报任务科室范围与状态")
public class ReportTaskScope implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "任务ID")
    @TableField("task_id")
    private Long taskId;

    @Schema(description = "科室ID")
    @TableField("dept_id")
    private Long deptId;

    @Schema(description = "科室名称")
    @TableField("dept_name")
    private String deptName;

    @Schema(description = "分配的指标编码列表（JSON数组）")
    @TableField("metric_codes")
    private String metricCodes;

    @Schema(description = "填报状态：PENDING/FILLING/SUBMITTED/APPROVED/REJECTED")
    @TableField("fill_status")
    private String fillStatus;

    @Schema(description = "提交时间")
    @TableField("submit_time")
    private LocalDateTime submitTime;

    @Schema(description = "审核时间")
    @TableField("review_time")
    private LocalDateTime reviewTime;

    @Schema(description = "审核人")
    @TableField("review_by")
    private String reviewBy;

    @Schema(description = "打回原因")
    @TableField("review_comment")
    private String reviewComment;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
