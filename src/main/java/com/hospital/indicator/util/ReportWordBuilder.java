package com.hospital.indicator.util;

import com.hospital.indicator.dto.report.ReportPreviewVO;
import com.hospital.indicator.dto.report.ReportPreviewVO.*;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * 生成 Word .docx 文件（纯 ZIP+XML，无 POI 依赖，彻底规避 classpath 冲突）。
 * DOCX = ZIP 包含：[Content_Types].xml / _rels/.rels / word/document.xml / word/styles.xml
 */
public class ReportWordBuilder {

    public static void build(ReportPreviewVO vo, OutputStream out) throws IOException {
        ZipOutputStream zip = new ZipOutputStream(out);

        writeEntry(zip, "[Content_Types].xml", contentTypes());
        writeEntry(zip, "_rels/.rels",          rels());
        writeEntry(zip, "word/styles.xml",       styles());
        writeEntry(zip, "word/_rels/document.xml.rels", docRels());
        writeEntry(zip, "word/document.xml",     document(vo));

        zip.finish();
    }

    // ─── 固定文件 ────────────────────────────────────────────────────────────

    private static String contentTypes() {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
               "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">" +
               "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>" +
               "<Default Extension=\"xml\"  ContentType=\"application/xml\"/>" +
               "<Override PartName=\"/word/document.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml\"/>" +
               "<Override PartName=\"/word/styles.xml\"   ContentType=\"application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml\"/>" +
               "</Types>";
    }

    private static String rels() {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
               "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">" +
               "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"word/document.xml\"/>" +
               "</Relationships>";
    }

    private static String docRels() {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
               "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">" +
               "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles\" Target=\"styles.xml\"/>" +
               "</Relationships>";
    }

    private static String styles() {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
               "<w:styles xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\">" +
               // 默认段落样式
               "<w:style w:type=\"paragraph\" w:default=\"1\" w:styleId=\"Normal\">" +
               "<w:name w:val=\"Normal\"/>" +
               "<w:rPr><w:rFonts w:eastAsia=\"宋体\"/><w:sz w:val=\"22\"/></w:rPr></w:style>" +
               // H1
               "<w:style w:type=\"paragraph\" w:styleId=\"Heading1\">" +
               "<w:name w:val=\"heading 1\"/>" +
               "<w:pPr><w:outlineLvl w:val=\"0\"/></w:pPr>" +
               "<w:rPr><w:b/><w:rFonts w:eastAsia=\"黑体\"/><w:sz w:val=\"32\"/><w:color w:val=\"1F3864\"/></w:rPr></w:style>" +
               // H2
               "<w:style w:type=\"paragraph\" w:styleId=\"Heading2\">" +
               "<w:name w:val=\"heading 2\"/>" +
               "<w:pPr><w:outlineLvl w:val=\"1\"/></w:pPr>" +
               "<w:rPr><w:b/><w:rFonts w:eastAsia=\"黑体\"/><w:sz w:val=\"28\"/><w:color w:val=\"2E74B5\"/></w:rPr></w:style>" +
               // H3
               "<w:style w:type=\"paragraph\" w:styleId=\"Heading3\">" +
               "<w:name w:val=\"heading 3\"/>" +
               "<w:pPr><w:outlineLvl w:val=\"2\"/></w:pPr>" +
               "<w:rPr><w:b/><w:rFonts w:eastAsia=\"黑体\"/><w:sz w:val=\"24\"/><w:color w:val=\"2E74B5\"/></w:rPr></w:style>" +
               "</w:styles>";
    }

    // ─── 正文 document.xml ──────────────────────────────────────────────────

    private static String document(ReportPreviewVO vo) {
        StringBuilder sb = new StringBuilder();
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>");
        sb.append("<w:document xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\"" +
                  " xmlns:wpc=\"http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas\">");
        sb.append("<w:body>");

        Meta meta = vo.getMeta();

        // ── 封面 ──
        appendCenteredPara(sb, "绩效指标  达标情况和监测报告", 36, true, "1F3864");
        appendCenteredPara(sb, meta.getPeriodDesc(), 24, false, "2E74B5");
        appendBlankLines(sb, 4);
        appendCenteredPara(sb, meta.getHospitalName(), 28, true, null);
        appendCenteredPara(sb, meta.getGeneratedAt(), 22, false, null);
        appendPageBreak(sb);

        // ── 前言 ──
        appendHeading(sb, "前言", 1);
        appendPara(sb, "根据《国家三级公立" + meta.getHospitalLevel() + "绩效考核操作手册》与医院绩效指标提升的要求，" +
                meta.getHospitalName() + "建立了绩效指标目标管理、责任科室整改过程管理的指标监测体系，" +
                "帮助医院对绩效考核指标改进提升，周期性的（月、季、年）提供绩效指标达标情况和监测过程及整改过程报告。", false);
        appendPara(sb, "本报告为" + meta.getPeriodDesc() + "。", false);

        // ── 第一章 总述 ──
        appendHeading(sb, "第一章、总述", 1);
        Summary summary = vo.getSummary();
        appendPara(sb, String.format("统计截至 %s，指标数量：%d，达标数量：%d，未达标数量：%d，其他：%d",
                meta.getDataDate(), summary.getTotalCount(), summary.getCompliantCount(),
                summary.getNonCompliantCount(), summary.getOtherCount()), false);

        appendHeading(sb, "一、各监测指标达成情况", 2);
        String[] h1 = {"序号", "指标", "当前值", "目标值", "单位", "达标状态"};
        beginTable(sb, h1);
        for (SummaryRow r : summary.getIndicatorRows()) {
            String statusLabel = "COMPLIANT".equals(r.getStatus()) ? "达标"
                    : "NON_COMPLIANT".equals(r.getStatus()) ? "未达标" : "其他";
            addTableRow(sb, new String[]{
                    String.valueOf(r.getSeq()), esc(r.getMetricName()), r.getCurrentValue(),
                    r.getTargetValue(), r.getUnit(), statusLabel});
        }
        endTable(sb);

        appendHeading(sb, "二、科室未达标指标", 2);
        if (summary.getNonCompliantDeptRows().isEmpty()) {
            appendPara(sb, "暂无未达标科室数据。", false);
        } else {
            String[] h2 = {"序号", "指标", "科室", "当前值", "目标值"};
            beginTable(sb, h2);
            for (NonCompliantDeptRow r : summary.getNonCompliantDeptRows()) {
                addTableRow(sb, new String[]{
                        String.valueOf(r.getSeq()), esc(r.getMetricName()),
                        esc(r.getDeptName()), r.getCurrentValue(), r.getTargetValue()});
            }
            endTable(sb);
        }
        appendPageBreak(sb);

        // ── 第二章 指标详情 ──
        appendHeading(sb, "第二章、指标综合概览", 1);
        if (vo.getIndicators() != null) {
            for (IndicatorSection sec : vo.getIndicators()) {
                appendIndicatorSection(sb, sec);
            }
        }

        // ── 附录 ──
        appendPageBreak(sb);
        appendHeading(sb, "附录：指标数据列表", 1);
        String[] ah = {"序号", "指标", "当前值", "目标值", "单位", "达标状态"};
        beginTable(sb, ah);
        for (SummaryRow r : summary.getIndicatorRows()) {
            String statusLabel = "COMPLIANT".equals(r.getStatus()) ? "达标"
                    : "NON_COMPLIANT".equals(r.getStatus()) ? "未达标" : "其他";
            addTableRow(sb, new String[]{
                    String.valueOf(r.getSeq()), esc(r.getMetricName()), r.getCurrentValue(),
                    r.getTargetValue(), r.getUnit(), statusLabel});
        }
        endTable(sb);

        // sectPr（文档属性）
        sb.append("<w:sectPr>" +
                  "<w:pgSz w:w=\"11906\" w:h=\"16838\"/>" +
                  "<w:pgMar w:top=\"1440\" w:right=\"1800\" w:bottom=\"1440\" w:left=\"1800\"/>" +
                  "</w:sectPr>");
        sb.append("</w:body></w:document>");
        return sb.toString();
    }

    private static void appendIndicatorSection(StringBuilder sb, IndicatorSection sec) {
        appendHeading(sb, esc(sec.getMetricCode()) + "、" + esc(sec.getMetricName()), 2);

        // 基本情况
        appendHeading(sb, "基本情况", 3);
        BasicInfo bi = sec.getBasicInfo();
        if (bi != null) {
            String[] bh = {"开始日期", "结束日期", "数据日期", "当前值", "目标值", "指标导向"};
            String[] bd = {bi.getStartDate(), bi.getEndDate(), bi.getDataDate(),
                    bi.getCurrentValue(), bi.getTargetValue(), bi.getDirection()};
            beginTable(sb, bh);
            addTableRow(sb, bd);
            endTable(sb);
        }

        // 变化趋势
        appendHeading(sb, "变化趋势", 3);
        appendPeriodTable(sb, sec.getTrendData(), sec.getMetricName());

        // 环比
        appendHeading(sb, "环比", 3);
        if (sec.getMomData() != null) {
            appendPeriodTable(sb, sec.getMomData().getSeries(), sec.getMetricName());
            if (sec.getMomData().getMomRate() != null) {
                appendPara(sb, "环比变化率：" + sec.getMomData().getMomRate(), false);
            }
        }

        // 同比
        appendHeading(sb, "同比", 3);
        if (sec.getYoyData() != null) {
            appendPeriodTable(sb, sec.getYoyData().getSeries(), sec.getMetricName());
            if (sec.getYoyData().getYoyRate() != null) {
                appendPara(sb, "同比变化率：" + sec.getYoyData().getYoyRate(), false);
            }
        }

        // 科室监测
        appendHeading(sb, "科室监测", 3);
        List<DeptRow> deptData = sec.getDeptData();
        if (deptData == null || deptData.isEmpty()) {
            appendPara(sb, "暂无科室监测数据。", false);
        } else {
            String[] dh = {"序号", "科室", "指标项", "值", "整改措施"};
            beginTable(sb, dh);
            for (DeptRow r : deptData) {
                addTableRow(sb, new String[]{
                        String.valueOf(r.getSeq()), esc(r.getDeptName()),
                        esc(sec.getMetricName()), r.getValue(), esc(r.getCorrection())});
            }
            endTable(sb);
        }
    }

    private static void appendPeriodTable(StringBuilder sb, List<PeriodValue> data, String metricName) {
        if (data == null || data.isEmpty()) {
            appendPara(sb, "暂无数据。", false);
            return;
        }
        String[] h = {"序号", "指标项", "周期", "值"};
        beginTable(sb, h);
        for (PeriodValue pv : data) {
            addTableRow(sb, new String[]{
                    String.valueOf(pv.getSeq()), esc(metricName), pv.getPeriod(), pv.getValue()});
        }
        endTable(sb);
    }

    // ─── XML 生成工具 ────────────────────────────────────────────────────────

    private static void appendHeading(StringBuilder sb, String text, int level) {
        String styleId = "Heading" + level;
        sb.append("<w:p><w:pPr><w:pStyle w:val=\"").append(styleId).append("\"/></w:pPr>")
          .append("<w:r><w:t>").append(esc(text)).append("</w:t></w:r></w:p>");
    }

    private static void appendPara(StringBuilder sb, String text, boolean bold) {
        sb.append("<w:p><w:r>");
        if (bold) sb.append("<w:rPr><w:b/></w:rPr>");
        sb.append("<w:t xml:space=\"preserve\">").append(esc(text)).append("</w:t>");
        sb.append("</w:r></w:p>");
    }

    private static void appendCenteredPara(StringBuilder sb, String text, int ptSize, boolean bold, String color) {
        sb.append("<w:p><w:pPr><w:jc w:val=\"center\"/></w:pPr><w:r><w:rPr>");
        if (bold) sb.append("<w:b/>");
        sb.append("<w:sz w:val=\"").append(ptSize * 2).append("\"/>");
        if (color != null) sb.append("<w:color w:val=\"").append(color).append("\"/>");
        sb.append("</w:rPr><w:t>").append(esc(text)).append("</w:t></w:r></w:p>");
    }

    private static void appendBlankLines(StringBuilder sb, int n) {
        for (int i = 0; i < n; i++) sb.append("<w:p/>");
    }

    private static void appendPageBreak(StringBuilder sb) {
        sb.append("<w:p><w:r><w:br w:type=\"page\"/></w:r></w:p>");
    }

    private static void beginTable(StringBuilder sb, String[] headers) {
        sb.append("<w:tbl><w:tblPr>" +
                  "<w:tblStyle w:val=\"TableGrid\"/>" +
                  "<w:tblW w:w=\"0\" w:type=\"auto\"/>" +
                  "<w:tblBorders>" +
                  "<w:top w:val=\"single\" w:sz=\"4\" w:color=\"auto\"/>" +
                  "<w:left w:val=\"single\" w:sz=\"4\" w:color=\"auto\"/>" +
                  "<w:bottom w:val=\"single\" w:sz=\"4\" w:color=\"auto\"/>" +
                  "<w:right w:val=\"single\" w:sz=\"4\" w:color=\"auto\"/>" +
                  "<w:insideH w:val=\"single\" w:sz=\"4\" w:color=\"auto\"/>" +
                  "<w:insideV w:val=\"single\" w:sz=\"4\" w:color=\"auto\"/>" +
                  "</w:tblBorders></w:tblPr>");
        // 表头行（蓝色底）
        sb.append("<w:tr>");
        for (String h : headers) {
            sb.append("<w:tc><w:tcPr><w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"D6E4F0\"/></w:tcPr>")
              .append("<w:p><w:pPr><w:jc w:val=\"center\"/></w:pPr>")
              .append("<w:r><w:rPr><w:b/><w:sz w:val=\"18\"/></w:rPr>")
              .append("<w:t>").append(esc(h)).append("</w:t></w:r></w:p></w:tc>");
        }
        sb.append("</w:tr>");
    }

    private static void addTableRow(StringBuilder sb, String[] cells) {
        sb.append("<w:tr>");
        for (String c : cells) {
            sb.append("<w:tc>")
              .append("<w:p><w:pPr><w:jc w:val=\"center\"/></w:pPr>")
              .append("<w:r><w:rPr><w:sz w:val=\"18\"/></w:rPr>")
              .append("<w:t xml:space=\"preserve\">").append(esc(c != null ? c : "")).append("</w:t>")
              .append("</w:r></w:p></w:tc>");
        }
        sb.append("</w:tr>");
    }

    private static void endTable(StringBuilder sb) {
        sb.append("</w:tbl><w:p/>");
    }

    /** XML 转义 */
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&apos;");
    }

    // ─── ZIP 写入 ────────────────────────────────────────────────────────────

    private static void writeEntry(ZipOutputStream zip, String name, String content) throws IOException {
        zip.putNextEntry(new ZipEntry(name));
        zip.write(content.getBytes(StandardCharsets.UTF_8));
        zip.closeEntry();
    }
}
