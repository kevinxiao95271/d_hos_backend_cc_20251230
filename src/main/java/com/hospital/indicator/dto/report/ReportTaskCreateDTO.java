package com.hospital.indicator.dto.report;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.List;

@Data
@Schema(description = "创建填报任务DTO")
public class ReportTaskCreateDTO {

    @Schema(description = "任务名称", required = true)
    @NotBlank(message = "任务名称不能为空")
    private String name;

    @Schema(description = "时间维度：YEAR/QUARTER/MONTH", required = true)
    @NotBlank(message = "时间维度不能为空")
    private String timeDimension;

    @Schema(description = "统计开始日期", required = true)
    @NotNull(message = "统计开始日期不能为空")
    private LocalDate startDate;

    @Schema(description = "统计结束日期", required = true)
    @NotNull(message = "统计结束日期不能为空")
    private LocalDate endDate;

    @Schema(description = "填报截止日期")
    private LocalDate deadline;

    @Schema(description = "填报方式（不填则继承全局配置）")
    private String inputMode;

    @Schema(description = "审核流程（不填则继承全局配置）")
    private String reviewMode;

    @Schema(description = "来源模板ID（使用模板一键下发时填入）")
    private Long templateId;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "科室范围列表（新建时直接指定）")
    @NotEmpty(message = "科室范围不能为空")
    @Valid
    private List<ScopeItemDTO> scopes;

    @Data
    @Schema(description = "科室填报范围项")
    public static class ScopeItemDTO {
        @Schema(description = "科室ID", required = true)
        @NotNull(message = "科室ID不能为空")
        private Long deptId;

        @Schema(description = "科室名称")
        private String deptName;

        @Schema(description = "分配的指标编码列表", required = true)
        @NotEmpty(message = "指标列表不能为空")
        private List<String> metricCodes;
    }
}
