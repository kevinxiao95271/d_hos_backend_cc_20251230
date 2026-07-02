package com.hospital.indicator.service.report.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.dto.report.ReportPreviewVO;
import com.hospital.indicator.dto.report.ReportPreviewVO.*;
import com.hospital.indicator.dto.report.ReportQueryDTO;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.entity.IndicatorResult;
import com.hospital.indicator.entity.IndicatorResultDept;
import com.hospital.indicator.mapper.IndicatorMapper;
import com.hospital.indicator.mapper.IndicatorResultDeptMapper;
import com.hospital.indicator.mapper.IndicatorResultMapper;
import com.hospital.indicator.service.SystemConfigService;
import com.hospital.indicator.service.report.IndicatorReportService;
import com.hospital.indicator.util.ReportWordBuilder;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class IndicatorReportServiceImpl implements IndicatorReportService {

    @Autowired
    private IndicatorMapper indicatorMapper;
    @Autowired
    private IndicatorResultMapper resultMapper;
    @Autowired
    private IndicatorResultDeptMapper deptResultMapper;
    @Autowired
    private SystemConfigService configService;

    // ────────────────────────────────────────────────────────────────────────

    @Override
    public ReportPreviewVO buildPreview(ReportQueryDTO query) {
        String timeDim = query.isAnnual() ? "YEAR" : "MONTH";
        String dbStart = ReportQueryDTO.toDbPeriod(query.getStartPeriod());
        String dbEnd = ReportQueryDTO.toDbPeriod(query.getEndPeriod());

        // 1. 加载启用的叶子指标
        List<Indicator> indicators = loadIndicators(query.getMetricPool());
        if (indicators.isEmpty()) {
            return emptyReport(query);
        }

        // 2. 加载周期内所有指标结果
        Map<String, List<IndicatorResult>> resultsByCode =
                loadResults(timeDim, dbStart, dbEnd, indicators);

        // 3. 加载前一期结果（用于环比）
        String prevDbPeriod = calcPrevPeriod(dbStart, query.isAnnual());
        Map<String, IndicatorResult> prevResultByCode =
                loadSinglePeriodResults(timeDim, prevDbPeriod, indicators);

        // 4. 加载去年同期结果（用于同比）
        String yoyDbStart = calcYoyPeriod(dbStart, query.isAnnual());
        String yoyDbEnd = calcYoyPeriod(dbEnd, query.isAnnual());
        Map<String, List<IndicatorResult>> yoyResultsByCode =
                loadResults(timeDim, yoyDbStart, yoyDbEnd, indicators);

        // 5. 加载科室下钻数据（最新期）
        Map<String, List<IndicatorResultDept>> deptResultsByCode =
                loadDeptResults(timeDim, dbEnd, indicators);

        // 6. 组装各指标 Section
        List<IndicatorSection> sections = new ArrayList<>();
        for (Indicator ind : indicators) {
            List<IndicatorResult> periodResults = resultsByCode.getOrDefault(ind.getMetricCode(), Collections.emptyList());
            IndicatorResult latestResult = getLatest(periodResults, dbEnd);
            List<IndicatorResult> yoyPeriodResults = yoyResultsByCode.getOrDefault(ind.getMetricCode(), Collections.emptyList());
            IndicatorResult prevResult = prevResultByCode.get(ind.getMetricCode());
            List<IndicatorResultDept> deptResults = deptResultsByCode.getOrDefault(ind.getMetricCode(), Collections.emptyList());

            sections.add(buildSection(ind, periodResults, latestResult, prevResult, prevDbPeriod, yoyPeriodResults, deptResults, dbStart, dbEnd));
        }

        // 7. 组装总述
        Summary summary = buildSummary(indicators, sections);

        // 8. 组装 Meta
        Meta meta = buildMeta(query, dbEnd);

        ReportPreviewVO vo = new ReportPreviewVO();
        vo.setMeta(meta);
        vo.setSummary(summary);
        vo.setIndicators(sections);
        return vo;
    }

    @Override
    public void exportWord(ReportQueryDTO query, HttpServletResponse response) throws IOException {
        ReportPreviewVO preview = buildPreview(query);
        String filename = URLEncoder.encode(
                preview.getMeta().getHospitalName() + "绩效指标监测报告(" + preview.getMeta().getPeriodDesc() + ").docx",
                "UTF-8");
        response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + filename);
        ReportWordBuilder.build(preview, response.getOutputStream());
    }

    // ─── 数据加载 helpers ────────────────────────────────────────────────────

    private List<Indicator> loadIndicators(String metricPool) {
        LambdaQueryWrapper<Indicator> qw = new LambdaQueryWrapper<Indicator>()
                .eq(Indicator::getStatus, 1)
                .eq(Indicator::getIsLeaf, 1)
                .orderByAsc(Indicator::getSortOrder, Indicator::getMetricCode);
        if (StringUtils.isNotBlank(metricPool)) {
            qw.eq(Indicator::getMetricPool, metricPool);
        }
        return indicatorMapper.selectList(qw);
    }

    private Map<String, List<IndicatorResult>> loadResults(String timeDim, String dbStart, String dbEnd,
                                                            List<Indicator> indicators) {
        List<String> codes = indicators.stream().map(Indicator::getMetricCode).collect(Collectors.toList());
        if (codes.isEmpty()) return Collections.emptyMap();
        List<IndicatorResult> list = resultMapper.selectList(
                new LambdaQueryWrapper<IndicatorResult>()
                        .in(IndicatorResult::getMetricCode, codes)
                        .eq(IndicatorResult::getTimeDimension, timeDim)
                        .ge(IndicatorResult::getTimeValue, dbStart)
                        .le(IndicatorResult::getTimeValue, dbEnd)
                        .eq(IndicatorResult::getCalculationStatus, "SUCCESS")
                        .orderByAsc(IndicatorResult::getTimeValue));
        return list.stream().collect(Collectors.groupingBy(IndicatorResult::getMetricCode));
    }

    private Map<String, IndicatorResult> loadSinglePeriodResults(String timeDim, String dbPeriod,
                                                                   List<Indicator> indicators) {
        if (dbPeriod == null) return Collections.emptyMap();
        List<String> codes = indicators.stream().map(Indicator::getMetricCode).collect(Collectors.toList());
        List<IndicatorResult> list = resultMapper.selectList(
                new LambdaQueryWrapper<IndicatorResult>()
                        .in(IndicatorResult::getMetricCode, codes)
                        .eq(IndicatorResult::getTimeDimension, timeDim)
                        .eq(IndicatorResult::getTimeValue, dbPeriod)
                        .eq(IndicatorResult::getCalculationStatus, "SUCCESS"));
        return list.stream().collect(Collectors.toMap(IndicatorResult::getMetricCode, r -> r, (a, b) -> a));
    }

    private Map<String, List<IndicatorResultDept>> loadDeptResults(String timeDim, String dbPeriod,
                                                                    List<Indicator> indicators) {
        if (dbPeriod == null) return Collections.emptyMap();
        List<String> codes = indicators.stream().map(Indicator::getMetricCode).collect(Collectors.toList());
        List<IndicatorResultDept> list = deptResultMapper.selectList(
                new LambdaQueryWrapper<IndicatorResultDept>()
                        .in(IndicatorResultDept::getMetricCode, codes)
                        .eq(IndicatorResultDept::getTimeDimension, timeDim)
                        .eq(IndicatorResultDept::getTimeValue, dbPeriod)
                        .orderByAsc(IndicatorResultDept::getDeptName));
        return list.stream().collect(Collectors.groupingBy(IndicatorResultDept::getMetricCode));
    }

    // ─── 组装 helpers ─────────────────────────────────────────────────────────

    private IndicatorSection buildSection(Indicator ind,
                                          List<IndicatorResult> periodResults,
                                          IndicatorResult latestResult,
                                          IndicatorResult prevResult,
                                          String prevDbPeriod,
                                          List<IndicatorResult> yoyPeriodResults,
                                          List<IndicatorResultDept> deptResults,
                                          String dbStart, String dbEnd) {
        IndicatorSection sec = new IndicatorSection();
        sec.setMetricCode(ind.getMetricCode());
        sec.setMetricName(ind.getMetricName());

        String currentVal = latestResult != null ? formatValue(latestResult.getResultValue()) : "";
        String targetVal = ind.getTargetValue() != null ? formatValue(ind.getTargetValue()) : "";
        String direction = directionLabel(ind.getMonitorDirection());

        // 基本情况
        BasicInfo basic = new BasicInfo();
        basic.setStartDate(dbToDisplayDate(dbStart));
        basic.setEndDate(dbToDisplayDate(dbEnd));
        basic.setDataDate(LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        basic.setCurrentValue(currentVal);
        basic.setTargetValue(targetVal);
        basic.setGap(calcGap(latestResult, ind.getTargetValue()));
        basic.setDirection(direction);
        basic.setUnit(ind.getUnit() != null ? ind.getUnit() : "");
        sec.setBasicInfo(basic);

        // 变化趋势
        List<PeriodValue> trend = new ArrayList<>();
        for (int i = 0; i < periodResults.size(); i++) {
            IndicatorResult r = periodResults.get(i);
            PeriodValue pv = new PeriodValue();
            pv.setSeq(i + 1);
            pv.setMetricName(ind.getMetricName());
            pv.setPeriod(dbPeriodToDisplay(r.getTimeValue()));
            pv.setValue(formatValue(r.getResultValue()));
            trend.add(pv);
        }
        sec.setTrendData(trend);

        // 环比
        MomData mom = new MomData();
        List<PeriodValue> momSeries = new ArrayList<>();
        // 前一期
        if (prevResult != null) {
            PeriodValue pv = new PeriodValue();
            pv.setSeq(0);
            pv.setMetricName(ind.getMetricName());
            pv.setPeriod(dbPeriodToDisplay(prevDbPeriod));
            pv.setValue(formatValue(prevResult.getResultValue()));
            momSeries.add(pv);
        }
        momSeries.addAll(trend);
        mom.setSeries(momSeries);
        if (latestResult != null && latestResult.getMonthOverMonth() != null) {
            mom.setMomRate(latestResult.getMonthOverMonth().setScale(2, RoundingMode.HALF_UP) + "%");
        }
        sec.setMomData(mom);

        // 同比
        YoyData yoy = new YoyData();
        List<PeriodValue> yoySeries = new ArrayList<>();
        for (int i = 0; i < yoyPeriodResults.size(); i++) {
            IndicatorResult r = yoyPeriodResults.get(i);
            PeriodValue pv = new PeriodValue();
            pv.setSeq(i + 1);
            pv.setMetricName(ind.getMetricName());
            pv.setPeriod(dbPeriodToDisplay(r.getTimeValue()));
            pv.setValue(formatValue(r.getResultValue()));
            yoySeries.add(pv);
        }
        yoy.setSeries(yoySeries);
        if (latestResult != null && latestResult.getYearOverYear() != null) {
            yoy.setYoyRate(latestResult.getYearOverYear().setScale(2, RoundingMode.HALF_UP) + "%");
        }
        sec.setYoyData(yoy);

        // 科室监测
        List<DeptRow> deptRows = new ArrayList<>();
        for (int i = 0; i < deptResults.size(); i++) {
            IndicatorResultDept d = deptResults.get(i);
            DeptRow row = new DeptRow();
            row.setSeq(i + 1);
            row.setDeptName(d.getDeptName());
            row.setMetricName(ind.getMetricName());
            row.setValue(formatValue(d.getResultValue()));
            row.setCorrection("");
            deptRows.add(row);
        }
        sec.setDeptData(deptRows);

        return sec;
    }

    private Summary buildSummary(List<Indicator> indicators, List<IndicatorSection> sections) {
        Map<String, IndicatorSection> secByCode = sections.stream()
                .collect(Collectors.toMap(IndicatorSection::getMetricCode, s -> s, (a, b) -> a));
        Map<String, Indicator> indByCode = indicators.stream()
                .collect(Collectors.toMap(Indicator::getMetricCode, i -> i, (a, b) -> a));

        List<SummaryRow> rows = new ArrayList<>();
        List<NonCompliantDeptRow> deptRows = new ArrayList<>();
        int compliant = 0, nonCompliant = 0, other = 0;

        int seq = 1;
        for (Indicator ind : indicators) {
            IndicatorSection sec = secByCode.get(ind.getMetricCode());
            String currentVal = sec != null && sec.getBasicInfo() != null
                    ? sec.getBasicInfo().getCurrentValue() : "";
            String targetVal = ind.getTargetValue() != null ? formatValue(ind.getTargetValue()) : "";
            String status = calcStatus(ind, currentVal);

            SummaryRow row = new SummaryRow();
            row.setSeq(seq++);
            row.setMetricCode(ind.getMetricCode());
            row.setMetricName(ind.getMetricName());
            row.setCurrentValue(currentVal);
            row.setTargetValue(targetVal);
            row.setStatus(status);
            row.setUnit(ind.getUnit() != null ? ind.getUnit() : "");
            rows.add(row);

            if ("COMPLIANT".equals(status)) compliant++;
            else if ("NON_COMPLIANT".equals(status)) nonCompliant++;
            else other++;

            // 未达标科室
            if ("NON_COMPLIANT".equals(status) && sec != null && !sec.getDeptData().isEmpty()) {
                int dSeq = 1;
                for (DeptRow dr : sec.getDeptData()) {
                    NonCompliantDeptRow ndr = new NonCompliantDeptRow();
                    ndr.setSeq(dSeq++);
                    ndr.setMetricCode(ind.getMetricCode());
                    ndr.setMetricName(ind.getMetricName());
                    ndr.setDeptName(dr.getDeptName());
                    ndr.setCurrentValue(dr.getValue());
                    ndr.setTargetValue(targetVal);
                    deptRows.add(ndr);
                }
            }
        }

        Summary summary = new Summary();
        summary.setTotalCount(indicators.size());
        summary.setCompliantCount(compliant);
        summary.setNonCompliantCount(nonCompliant);
        summary.setOtherCount(other);
        summary.setIndicatorRows(rows);
        summary.setNonCompliantDeptRows(deptRows);
        return summary;
    }

    private Meta buildMeta(ReportQueryDTO query, String dbEnd) {
        Meta meta = new Meta();
        meta.setHospitalName(configService.getValue("hospital_name", "医院名称"));
        meta.setHospitalLevel(configService.getValue("hospital_level", "三级中医医院"));
        meta.setReportTitle(configService.getValue("report_title", "绩效指标达标情况和监测报告"));
        meta.setStartPeriod(query.getStartPeriod());
        meta.setEndPeriod(query.getEndPeriod());
        meta.setReportType(query.getReportType());
        meta.setPeriodDesc(buildPeriodDesc(query));
        meta.setDataDate(LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        // 报告生成日期显示为结束期对应年月
        meta.setGeneratedAt(dbEnd != null ? dbEnd.substring(0, 4) + "年" + (dbEnd.length() > 4 ? dbEnd.substring(5) + "月" : "") : "");
        return meta;
    }

    // ─── 工具方法 ─────────────────────────────────────────────────────────────

    private String buildPeriodDesc(ReportQueryDTO q) {
        if (q.isAnnual()) {
            return q.getStartPeriod().equals(q.getEndPeriod())
                    ? q.getStartPeriod() + "年度"
                    : q.getStartPeriod() + "-" + q.getEndPeriod() + "年度";
        }
        return q.getStartPeriod() + "-" + q.getEndPeriod() + "月度";
    }

    /** DB 格式 2026-01 → 显示格式 202601 */
    private String dbPeriodToDisplay(String dbPeriod) {
        if (dbPeriod == null) return "";
        return dbPeriod.replace("-", "");
    }

    /** DB 格式 2026-01 → 日期字符串 2026-01-01 */
    private String dbToDisplayDate(String dbPeriod) {
        if (dbPeriod == null) return "";
        if (dbPeriod.length() == 7) { // YYYY-MM
            return dbPeriod + "-01";
        }
        return dbPeriod + "-01-01";
    }

    private String formatValue(BigDecimal v) {
        if (v == null) return "";
        return v.stripTrailingZeros().toPlainString();
    }

    private String directionLabel(String direction) {
        if (direction == null) return "";
        switch (direction) {
            case "INCREASE": return "逐步提高";
            case "DECREASE": return "逐步降低";
            case "MONITOR":  return "监测比较";
            default: return direction;
        }
    }

    private String calcGap(IndicatorResult result, BigDecimal target) {
        if (result == null || result.getResultValue() == null || target == null) return "";
        return result.getResultValue().subtract(target).setScale(4, RoundingMode.HALF_UP)
                .stripTrailingZeros().toPlainString();
    }

    private String calcStatus(Indicator ind, String currentValStr) {
        if (ind.getTargetValue() == null || StringUtils.isBlank(currentValStr) || "MONITOR".equals(ind.getMonitorDirection())) {
            return "OTHER";
        }
        try {
            BigDecimal current = new BigDecimal(currentValStr);
            BigDecimal target = ind.getTargetValue();
            if ("INCREASE".equals(ind.getMonitorDirection())) {
                return current.compareTo(target) >= 0 ? "COMPLIANT" : "NON_COMPLIANT";
            } else if ("DECREASE".equals(ind.getMonitorDirection())) {
                return current.compareTo(target) <= 0 ? "COMPLIANT" : "NON_COMPLIANT";
            }
        } catch (NumberFormatException ignored) {
        }
        return "OTHER";
    }

    /** 前一期：2026-01 → 2025-12；2026 → 2025 */
    private String calcPrevPeriod(String dbPeriod, boolean annual) {
        if (dbPeriod == null) return null;
        try {
            if (annual) {
                return String.valueOf(Integer.parseInt(dbPeriod) - 1);
            }
            int year = Integer.parseInt(dbPeriod.substring(0, 4));
            int month = Integer.parseInt(dbPeriod.substring(5, 7));
            if (month == 1) {
                return (year - 1) + "-12";
            }
            return year + "-" + String.format("%02d", month - 1);
        } catch (Exception e) {
            return null;
        }
    }

    /** 去年同期：2026-06 → 2025-06；2026 → 2025 */
    private String calcYoyPeriod(String dbPeriod, boolean annual) {
        if (dbPeriod == null) return null;
        try {
            if (annual) {
                return String.valueOf(Integer.parseInt(dbPeriod) - 1);
            }
            return (Integer.parseInt(dbPeriod.substring(0, 4)) - 1) + dbPeriod.substring(4);
        } catch (Exception e) {
            return null;
        }
    }

    /** 获取最接近 dbEnd 的那条结果（通常就是最新的） */
    private IndicatorResult getLatest(List<IndicatorResult> results, String dbEnd) {
        if (results.isEmpty()) return null;
        return results.stream()
                .filter(r -> r.getTimeValue().compareTo(dbEnd) <= 0)
                .max(Comparator.comparing(IndicatorResult::getTimeValue))
                .orElse(results.get(results.size() - 1));
    }

    private ReportPreviewVO emptyReport(ReportQueryDTO query) {
        ReportPreviewVO vo = new ReportPreviewVO();
        vo.setMeta(buildMeta(query, ReportQueryDTO.toDbPeriod(query.getEndPeriod())));
        Summary s = new Summary();
        s.setIndicatorRows(Collections.emptyList());
        s.setNonCompliantDeptRows(Collections.emptyList());
        vo.setSummary(s);
        vo.setIndicators(Collections.emptyList());
        return vo;
    }
}
