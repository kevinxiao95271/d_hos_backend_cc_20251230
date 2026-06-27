package com.hospital.indicator.dto.report;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

@Data
@Schema(description = "科室填报数据保存DTO")
public class ReportDataSaveDTO {

    @Schema(description = "任务ID", required = true)
    @NotNull(message = "任务ID不能为空")
    private Long taskId;

    @Schema(description = "科室ID（从UserContext取，校验用）")
    private Long deptId;

    @Schema(description = "指标编码", required = true)
    @NotBlank(message = "指标编码不能为空")
    private String metricCode;

    @Schema(description = "本指标采用的填报方式（覆盖任务级配置）")
    private String inputMode;

    @Schema(description = "指标项填报列表（NUM_DEN 模式使用）")
    private List<ItemValueDTO> items;

    @Schema(description = "指标结果（RESULT_ONLY 模式直接填结果）")
    private BigDecimal resultValue;

    @Schema(description = "备注")
    private String remark;

    @Data
    @Schema(description = "指标项填报行")
    public static class ItemValueDTO {
        @Schema(description = "指标项编码")
        private String itemCode;
        @Schema(description = "指标项名称")
        private String itemName;
        @Schema(description = "填入值")
        private BigDecimal inputValue;
    }
}
