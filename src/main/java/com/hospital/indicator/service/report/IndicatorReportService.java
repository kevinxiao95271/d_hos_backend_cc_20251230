package com.hospital.indicator.service.report;

import com.hospital.indicator.dto.report.ReportPreviewVO;
import com.hospital.indicator.dto.report.ReportQueryDTO;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 指标监测报告 Service
 */
public interface IndicatorReportService {

    /**
     * 构建报告预览数据（供前端渲染）
     */
    ReportPreviewVO buildPreview(ReportQueryDTO query);

    /**
     * 导出 Word 报告（.docx）到 HttpServletResponse
     */
    void exportWord(ReportQueryDTO query, HttpServletResponse response) throws IOException;
}
