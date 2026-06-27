package com.hospital.indicator.dto.report;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Schema(description = "填报人员的待办任务VO")
public class MyTaskVO {

    @Schema(description = "任务ID")
    private Long taskId;

    @Schema(description = "任务名称")
    private String taskName;

    @Schema(description = "时间维度")
    private String timeDimension;

    @Schema(description = "统计开始日期")
    private LocalDate startDate;

    @Schema(description = "统计结束日期")
    private LocalDate endDate;

    @Schema(description = "填报截止日期")
    private LocalDate deadline;

    @Schema(description = "任务状态")
    private String taskStatus;

    @Schema(description = "本科室填报状态：PENDING/FILLING/SUBMITTED/APPROVED/REJECTED")
    private String fillStatus;

    @Schema(description = "打回原因（REJECTED时有值）")
    private String reviewComment;

    @Schema(description = "实际填报方式")
    private String inputMode;

    @Schema(description = "审核流程")
    private String reviewMode;

    @Schema(description = "本科室分配的指标编码列表")
    private List<String> metricCodes;

    @Schema(description = "本科室分配的指标数量")
    private Integer metricCount;

    @Schema(description = "提交时间")
    private LocalDateTime submitTime;

    @Schema(description = "是否超截止日期")
    private Boolean overdue;
}
