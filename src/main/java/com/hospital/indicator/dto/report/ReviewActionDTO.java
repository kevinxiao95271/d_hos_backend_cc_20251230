package com.hospital.indicator.dto.report;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotNull;

@Data
@Schema(description = "审核操作DTO")
public class ReviewActionDTO {

    @Schema(description = "任务ID", required = true)
    @NotNull(message = "任务ID不能为空")
    private Long taskId;

    @Schema(description = "科室ID", required = true)
    @NotNull(message = "科室ID不能为空")
    private Long deptId;

    @Schema(description = "审核结果：APPROVED/REJECTED", required = true)
    private String action;

    @Schema(description = "打回原因（action=REJECTED时必填）")
    private String comment;
}
