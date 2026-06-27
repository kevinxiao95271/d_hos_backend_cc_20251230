package com.hospital.indicator.entity.report;

import com.baomidou.mybatisplus.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@TableName("t_report_config")
@Schema(description = "填报任务全局配置")
public class ReportConfig implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    @Schema(description = "填报方式：RESULT_ONLY/NUM_DEN/NUM_DEN_OR_RESULT")
    @TableField("input_mode")
    private String inputMode;

    @Schema(description = "模板版本策略：OVERWRITE/VERSIONED")
    @TableField("version_strategy")
    private String versionStrategy;

    @Schema(description = "审核流程：AUTO_APPROVE/ADMIN_REVIEW")
    @TableField("review_mode")
    private String reviewMode;

    @Schema(description = "任务默认截止天数")
    @TableField("default_deadline_days")
    private Integer defaultDeadlineDays;

    @Schema(description = "截止前N天自动催报")
    @TableField("remind_before_days")
    private Integer remindBeforeDays;

    @Schema(description = "提交后是否允许重新填报：0否/1是")
    @TableField("allow_resubmit")
    private Integer allowResubmit;

    @TableField("remark")
    private String remark;

    @TableField("update_by")
    private String updateBy;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
