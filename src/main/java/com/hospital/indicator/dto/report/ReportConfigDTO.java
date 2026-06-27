package com.hospital.indicator.dto.report;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Data
@Schema(description = "填报全局配置保存DTO")
public class ReportConfigDTO {

    @Schema(description = "填报方式：RESULT_ONLY/NUM_DEN/NUM_DEN_OR_RESULT", required = true)
    @NotBlank(message = "填报方式不能为空")
    private String inputMode;

    @Schema(description = "模板版本策略：OVERWRITE/VERSIONED", required = true)
    @NotBlank(message = "版本策略不能为空")
    private String versionStrategy;

    @Schema(description = "审核流程：AUTO_APPROVE/ADMIN_REVIEW", required = true)
    @NotBlank(message = "审核流程不能为空")
    private String reviewMode;

    @Schema(description = "任务默认截止天数，默认15")
    private Integer defaultDeadlineDays;

    @Schema(description = "截止前N天催报，默认3")
    private Integer remindBeforeDays;

    @Schema(description = "提交后是否允许重新填报：1是/0否")
    private Integer allowResubmit;

    @Schema(description = "配置说明")
    private String remark;
}
