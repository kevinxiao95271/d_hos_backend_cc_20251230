package com.hospital.indicator.entity.report;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("t_report_task")
@Schema(description = "填报任务主表")
public class ReportTask implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "任务名称")
    @TableField("name")
    private String name;

    @Schema(description = "时间维度：YEAR/QUARTER/MONTH")
    @TableField("time_dimension")
    private String timeDimension;

    @Schema(description = "统计开始日期")
    @TableField("start_date")
    private LocalDate startDate;

    @Schema(description = "统计结束日期")
    @TableField("end_date")
    private LocalDate endDate;

    @Schema(description = "填报截止日期")
    @TableField("deadline")
    private LocalDate deadline;

    @Schema(description = "任务状态：DRAFT/PUBLISHED/CLOSED")
    @TableField("status")
    private String status;

    @Schema(description = "填报方式（覆盖全局配置，为空则继承）")
    @TableField("input_mode")
    private String inputMode;

    @Schema(description = "审核流程（覆盖全局配置，为空则继承）")
    @TableField("review_mode")
    private String reviewMode;

    @Schema(description = "来源模板ID")
    @TableField("template_id")
    private Long templateId;

    @TableField("remark")
    private String remark;

    @TableField("created_by")
    private String createdBy;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
