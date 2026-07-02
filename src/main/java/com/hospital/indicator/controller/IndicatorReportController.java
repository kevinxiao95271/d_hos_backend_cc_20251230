package com.hospital.indicator.controller;

import com.hospital.indicator.common.Result;
import com.hospital.indicator.dto.report.ReportPreviewVO;
import com.hospital.indicator.dto.report.ReportQueryDTO;
import com.hospital.indicator.service.report.IndicatorReportService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.IOException;

/**
 * 指标监测报告接口
 * <p>
 * GET /api/indicator/report/preview  预览报告数据（JSON）
 * GET /api/indicator/report/export   导出 Word 文档
 */
@Tag(name = "指标监测报告", description = "生成/导出绩效指标达标情况和监测报告")
@RestController
@RequestMapping("/api/indicator/report")
public class IndicatorReportController {

    @Autowired
    private IndicatorReportService reportService;

    @Operation(summary = "预览报告数据",
               description = "返回完整报告 JSON，供前端渲染预览页面。" +
                             "reportType: MONTHLY（月度）/ ANNUAL（年度）")
    @GetMapping("/preview")
    public Result<ReportPreviewVO> preview(
            @Parameter(description = "开始周期，如 202601 或 2026") @RequestParam String startPeriod,
            @Parameter(description = "结束周期，如 202606 或 2026") @RequestParam String endPeriod,
            @Parameter(description = "报告类型：MONTHLY / ANNUAL，默认 MONTHLY") @RequestParam(required = false, defaultValue = "MONTHLY") String reportType,
            @Parameter(description = "指标池过滤：POOL_NATIONAL / POOL_GRADE，为空不过滤") @RequestParam(required = false) String metricPool) {

        ReportQueryDTO query = new ReportQueryDTO();
        query.setStartPeriod(startPeriod);
        query.setEndPeriod(endPeriod);
        query.setReportType(reportType);
        query.setMetricPool(metricPool);
        return Result.success(reportService.buildPreview(query));
    }

    @Operation(summary = "导出 Word 报告（.docx）",
               description = "下载 Word 格式报告文件，文件名含医院名和时间范围。")
    @GetMapping("/export")
    public void export(
            @Parameter(description = "开始周期，如 202601") @RequestParam String startPeriod,
            @Parameter(description = "结束周期，如 202606") @RequestParam String endPeriod,
            @Parameter(description = "报告类型：MONTHLY / ANNUAL") @RequestParam(required = false, defaultValue = "MONTHLY") String reportType,
            @Parameter(description = "指标池过滤") @RequestParam(required = false) String metricPool,
            HttpServletResponse response) throws IOException {

        ReportQueryDTO query = new ReportQueryDTO();
        query.setStartPeriod(startPeriod);
        query.setEndPeriod(endPeriod);
        query.setReportType(reportType);
        query.setMetricPool(metricPool);
        reportService.exportWord(query, response);
    }
}
