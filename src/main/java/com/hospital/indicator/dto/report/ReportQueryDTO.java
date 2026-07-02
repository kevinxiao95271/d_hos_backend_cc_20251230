package com.hospital.indicator.dto.report;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

/**
 * 报告生成请求参数
 */
@Data
@Schema(description = "指标监测报告查询参数")
public class ReportQueryDTO {

    @Schema(description = "开始周期，格式 YYYYMM（月度）或 YYYY（年度），如 202601 / 2026", example = "202601", required = true)
    @NotBlank(message = "startPeriod 不能为空")
    @Pattern(regexp = "^(\\d{4}|\\d{6})$", message = "startPeriod 格式错误，应为 YYYYMM 或 YYYY")
    private String startPeriod;

    @Schema(description = "结束周期，格式同 startPeriod，如 202606 / 2026", example = "202606", required = true)
    @NotBlank(message = "endPeriod 不能为空")
    @Pattern(regexp = "^(\\d{4}|\\d{6})$", message = "endPeriod 格式错误，应为 YYYYMM 或 YYYY")
    private String endPeriod;

    @Schema(description = "报告类型：MONTHLY（月度）/ ANNUAL（年度），默认 MONTHLY", example = "MONTHLY")
    private String reportType = "MONTHLY";

    @Schema(description = "指标池过滤：POOL_NATIONAL / POOL_GRADE，为空则不过滤")
    private String metricPool;

    /** 是否年度报告 */
    public boolean isAnnual() {
        return "ANNUAL".equalsIgnoreCase(reportType);
    }

    /**
     * 将 YYYYMM 格式的周期转换为 DB 存储的 time_value 格式（YYYY-MM 或 YYYY）
     */
    public static String toDbPeriod(String period) {
        if (period == null) return null;
        if (period.length() == 6) {
            return period.substring(0, 4) + "-" + period.substring(4, 6);
        }
        return period; // YYYY
    }
}
