package com.hospital.indicator.dto.report;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
@Schema(description = "填报页面指标表格数据VO")
public class FillSheetVO {

    @Schema(description = "任务ID")
    private Long taskId;

    @Schema(description = "科室ID")
    private Long deptId;

    @Schema(description = "科室名称")
    private String deptName;

    @Schema(description = "当前填报状态")
    private String fillStatus;

    @Schema(description = "任务实际生效的填报方式")
    private String inputMode;

    @Schema(description = "指标行列表")
    private List<MetricRowVO> rows;

    @Data
    @Schema(description = "指标填报行")
    public static class MetricRowVO {

        @Schema(description = "指标编码")
        private String metricCode;

        @Schema(description = "指标名称")
        private String metricName;

        @Schema(description = "计算方法描述（表达式）")
        private String formula;

        @Schema(description = "指标类型：AUTO/MANUAL")
        private String inputType;

        @Schema(description = "本指标实际生效的填报方式")
        private String effectiveInputMode;

        @Schema(description = "指标项明细行（NUM_DEN 模式）")
        private List<ItemRowVO> items;

        @Schema(description = "分子值（汇总，NUM_DEN 模式）")
        private BigDecimal numerator;

        @Schema(description = "分母值（汇总，NUM_DEN 模式）")
        private BigDecimal denominator;

        @Schema(description = "结果值（精度保留4位，去尾零）")
        private String result;
    }

    @Data
    @Schema(description = "指标项填报行")
    public static class ItemRowVO {
        @Schema(description = "指标项编码")
        private String itemCode;
        @Schema(description = "指标项名称")
        private String itemName;
        @Schema(description = "角色：NUMERATOR/DENOMINATOR/OTHER")
        private String role;
        @Schema(description = "已填入值（原始值，不加小数位）")
        private BigDecimal inputValue;
    }
}
