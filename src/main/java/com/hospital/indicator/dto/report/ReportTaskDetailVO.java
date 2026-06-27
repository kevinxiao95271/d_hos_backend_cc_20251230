package com.hospital.indicator.dto.report;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Schema(description = "填报任务详情VO")
public class ReportTaskDetailVO {

    @Schema(description = "任务ID")
    private Long id;

    @Schema(description = "任务名称")
    private String name;

    @Schema(description = "时间维度")
    private String timeDimension;

    @Schema(description = "统计开始日期")
    private LocalDate startDate;

    @Schema(description = "统计结束日期")
    private LocalDate endDate;

    @Schema(description = "填报截止日期")
    private LocalDate deadline;

    @Schema(description = "任务状态")
    private String status;

    @Schema(description = "填报方式（实际生效值，含继承）")
    private String inputMode;

    @Schema(description = "审核流程（实际生效值，含继承）")
    private String reviewMode;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建人")
    private String createdBy;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "科室填报范围列表")
    private List<ScopeVO> scopes;

    @Data
    @Schema(description = "科室填报范围")
    public static class ScopeVO {
        private Long deptId;
        private String deptName;
        private List<String> metricCodes;
        private String fillStatus;
        private LocalDateTime submitTime;
        private String reviewComment;
    }
}
