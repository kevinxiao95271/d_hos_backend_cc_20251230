package com.hospital.indicator.dto.report;

import lombok.Data;

import java.util.List;

/**
 * 指标监测报告预览数据结构（供前端渲染 + Word 导出共用）
 */
@Data
public class ReportPreviewVO {

    /** 报告元信息 */
    private Meta meta;

    /** 第一章：总述 */
    private Summary summary;

    /** 第二章：各指标详情 */
    private List<IndicatorSection> indicators;

    // ─── 元信息 ──────────────────────────────────────────────────────────────

    @Data
    public static class Meta {
        /** 医院名称 */
        private String hospitalName;
        /** 医院等级 */
        private String hospitalLevel;
        /** 报告标题 */
        private String reportTitle;
        /** 开始周期（原始，如 202601） */
        private String startPeriod;
        /** 结束周期（原始，如 202606） */
        private String endPeriod;
        /** 报告类型：MONTHLY / ANNUAL */
        private String reportType;
        /** 周期描述（如 202601-202606月度 / 2026年度） */
        private String periodDesc;
        /** 数据截止日期 */
        private String dataDate;
        /** 报告生成日期（如 2026年06月） */
        private String generatedAt;
    }

    // ─── 总述 ─────────────────────────────────────────────────────────────────

    @Data
    public static class Summary {
        /** 指标总数 */
        private int totalCount;
        /** 达标数量 */
        private int compliantCount;
        /** 未达标数量 */
        private int nonCompliantCount;
        /** 其他（无目标值 / 监测比较类） */
        private int otherCount;

        /** 指标汇总列表（第一章大表） */
        private List<SummaryRow> indicatorRows;

        /** 未达标科室列表（第一章第二小节） */
        private List<NonCompliantDeptRow> nonCompliantDeptRows;
    }

    @Data
    public static class SummaryRow {
        private int seq;
        private String metricCode;
        private String metricName;
        /** 当前值（字符串，便于格式化） */
        private String currentValue;
        /** 目标值 */
        private String targetValue;
        /** 达标状态：COMPLIANT / NON_COMPLIANT / OTHER */
        private String status;
        /** 单位 */
        private String unit;
    }

    @Data
    public static class NonCompliantDeptRow {
        private int seq;
        private String metricCode;
        private String metricName;
        private String deptName;
        private String currentValue;
        private String targetValue;
    }

    // ─── 各指标详情 ───────────────────────────────────────────────────────────

    @Data
    public static class IndicatorSection {
        private String metricCode;
        private String metricName;

        /** 基本情况 */
        private BasicInfo basicInfo;

        /** 变化趋势（周期内各月值） */
        private List<PeriodValue> trendData;

        /** 环比数据 */
        private MomData momData;

        /** 同比数据 */
        private YoyData yoyData;

        /** 科室监测数据（按科室展示最新期） */
        private List<DeptRow> deptData;
    }

    @Data
    public static class BasicInfo {
        private String startDate;
        private String endDate;
        private String dataDate;
        private String currentValue;
        private String targetValue;
        private String gap;
        /** 监测方向（中文）：逐步提高 / 逐步降低 / 监测比较 */
        private String direction;
        private String unit;
    }

    @Data
    public static class PeriodValue {
        private int seq;
        private String metricName;
        private String period;
        private String value;
    }

    @Data
    public static class MomData {
        /** 本期（当前周期内各期 + 前一期）序列，用于环比图表 */
        private List<PeriodValue> series;
        /** 环比变化率（%） */
        private String momRate;
    }

    @Data
    public static class YoyData {
        /** 同比序列（去年同周期各期数据） */
        private List<PeriodValue> series;
        /** 同比变化率（%） */
        private String yoyRate;
    }

    @Data
    public static class DeptRow {
        private int seq;
        private String deptName;
        private String metricName;
        private String value;
        /** 整改措施（预留，数据库暂无此字段，前端可填写） */
        private String correction;
    }
}
