package com.hospital.indicator.entity.report;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@TableName("t_report_template")
@Schema(description = "填报任务模板")
public class ReportTemplate implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "模板名称")
    @TableField("name")
    private String name;

    @Schema(description = "版本号")
    @TableField("version")
    private Integer version;

    @Schema(description = "是否为当前默认版本：1是/0否")
    @TableField("is_current")
    private Integer isCurrent;

    @Schema(description = "来源任务ID")
    @TableField("source_task_id")
    private Long sourceTaskId;

    @TableField("remark")
    private String remark;

    @TableField("created_by")
    private String createdBy;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
