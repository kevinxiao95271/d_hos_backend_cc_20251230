package com.hospital.indicator.service.report.impl;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.alibaba.excel.write.style.column.SimpleColumnWidthStyleStrategy;
import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.googlecode.aviator.AviatorEvaluator;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.dto.report.FillSheetVO;
import com.hospital.indicator.dto.report.ReportDataSaveDTO;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.entity.IndicatorItem;
import com.hospital.indicator.entity.report.ReportConfig;
import com.hospital.indicator.entity.report.ReportData;
import com.hospital.indicator.entity.report.ReportTask;
import com.hospital.indicator.entity.report.ReportTaskScope;
import com.hospital.indicator.mapper.IndicatorItemMapper;
import com.hospital.indicator.mapper.IndicatorMapper;
import com.hospital.indicator.mapper.report.ReportDataMapper;
import com.hospital.indicator.mapper.report.ReportTaskMapper;
import com.hospital.indicator.mapper.report.ReportTaskScopeMapper;
import com.hospital.indicator.service.report.ReportConfigService;
import com.hospital.indicator.service.report.ReportDataService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class ReportDataServiceImpl implements ReportDataService {

    @Autowired
    private ReportDataMapper dataMapper;
    @Autowired
    private ReportTaskMapper taskMapper;
    @Autowired
    private ReportTaskScopeMapper scopeMapper;
    @Autowired
    private IndicatorMapper indicatorMapper;
    @Autowired
    private IndicatorItemMapper indicatorItemMapper;
    @Autowired
    private ReportConfigService configService;

    @Override
    public FillSheetVO getFillSheet(Long taskId, Long deptId) {
        ReportTask task = taskMapper.selectById(taskId);
        if (task == null) throw new BusinessException("任务不存在");

        ReportTaskScope scope = scopeMapper.getByTaskAndDept(taskId, deptId);
        if (scope == null) throw new BusinessException("当前科室不在该任务填报范围内");

        ReportConfig config = configService.getConfig();
        String effectiveInputMode = StringUtils.isNotBlank(task.getInputMode())
                ? task.getInputMode() : config.getInputMode();

        List<String> metricCodes = JSON.parseArray(scope.getMetricCodes(), String.class);

        // 加载已填数据
        List<ReportData> existingData = dataMapper.listByTaskAndDept(taskId, deptId);
        Map<String, List<ReportData>> dataByMetric = existingData.stream()
                .collect(Collectors.groupingBy(ReportData::getMetricCode));

        FillSheetVO vo = new FillSheetVO();
        vo.setTaskId(taskId);
        vo.setDeptId(deptId);
        vo.setDeptName(scope.getDeptName());
        vo.setFillStatus(scope.getFillStatus());
        vo.setInputMode(effectiveInputMode);

        List<FillSheetVO.MetricRowVO> rows = new ArrayList<>();
        for (String code : metricCodes) {
            Indicator indicator = indicatorMapper.selectOne(
                    new LambdaQueryWrapper<Indicator>().eq(Indicator::getMetricCode, code));
            if (indicator == null) continue;

            FillSheetVO.MetricRowVO row = new FillSheetVO.MetricRowVO();
            row.setMetricCode(code);
            row.setMetricName(indicator.getMetricName());
            row.setFormula(indicator.getExpression());
            row.setInputType(indicator.getInputType());
            row.setEffectiveInputMode(effectiveInputMode);

            List<ReportData> metricData = dataByMetric.getOrDefault(code, Collections.emptyList());

            // 填充已有的指标项值
            List<IndicatorItem> items = loadItems(indicator);
            List<FillSheetVO.ItemRowVO> itemRows = new ArrayList<>();
            for (IndicatorItem item : items) {
                FillSheetVO.ItemRowVO ir = new FillSheetVO.ItemRowVO();
                ir.setItemCode(item.getItemCode());
                ir.setItemName(item.getItemName());
                metricData.stream()
                        .filter(d -> d.getItemCode() != null && d.getItemCode().equals(item.getItemCode()))
                        .findFirst()
                        .ifPresent(d -> ir.setInputValue(d.getInputValue()));
                itemRows.add(ir);
            }
            row.setItems(itemRows);

            // 填充结果行
            metricData.stream()
                    .filter(d -> d.getIsResultRow() != null && d.getIsResultRow() == 1)
                    .findFirst()
                    .ifPresent(d -> row.setResult(formatResult(d.getResultValue())));

            rows.add(row);
        }
        vo.setRows(rows);
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveOrUpdateItemData(ReportDataSaveDTO dto) {
        ReportTaskScope scope = scopeMapper.getByTaskAndDept(dto.getTaskId(), dto.getDeptId());
        if (scope == null) throw new BusinessException("当前科室不在该任务填报范围内");
        if ("APPROVED".equals(scope.getFillStatus())) {
            throw new BusinessException("已审核通过，不可再次修改");
        }

        ReportTask task = taskMapper.selectById(dto.getTaskId());
        ReportConfig config = configService.getConfig();
        String effectiveInputMode = StringUtils.isNotBlank(dto.getInputMode())
                ? dto.getInputMode()
                : (StringUtils.isNotBlank(task.getInputMode()) ? task.getInputMode() : config.getInputMode());

        // 删旧数据（该任务+科室+指标维度，原子替换）
        dataMapper.deleteByTaskAndDeptAndMetric(dto.getTaskId(), dto.getDeptId(), dto.getMetricCode());

        List<ReportData> toInsert = new ArrayList<>();

        if ("RESULT_ONLY".equals(effectiveInputMode)) {
            // 直接填结果
            if (dto.getResultValue() != null) {
                ReportData rd = buildResultRow(dto, effectiveInputMode, dto.getResultValue());
                toInsert.add(rd);
            }
        } else {
            // NUM_DEN 或 NUM_DEN_OR_RESULT：先处理指标项行
            if (dto.getItems() != null && !dto.getItems().isEmpty()) {
                for (ReportDataSaveDTO.ItemValueDTO item : dto.getItems()) {
                    ReportData rd = new ReportData();
                    rd.setTaskId(dto.getTaskId());
                    rd.setDeptId(dto.getDeptId());
                    rd.setMetricCode(dto.getMetricCode());
                    rd.setItemCode(item.getItemCode());
                    rd.setItemName(item.getItemName());
                    rd.setIsResultRow(0);
                    rd.setInputMode(effectiveInputMode);
                    rd.setInputValue(item.getInputValue());
                    rd.setRemark(dto.getRemark());
                    rd.setSaveTime(LocalDateTime.now());
                    toInsert.add(rd);
                }
                // 指标项都有值时，自动计算结果
                BigDecimal computed = tryCompute(dto.getMetricCode(), dto.getItems());
                if (computed != null) {
                    toInsert.add(buildResultRow(dto, effectiveInputMode, computed));
                }
            } else if ("NUM_DEN_OR_RESULT".equals(effectiveInputMode) && dto.getResultValue() != null) {
                // 灵活模式：用户直接填了结果
                toInsert.add(buildResultRow(dto, effectiveInputMode, dto.getResultValue()));
            }
        }

        toInsert.forEach(dataMapper::insert);

        // 更新scope状态为填报中
        if ("PENDING".equals(scope.getFillStatus())) {
            scope.setFillStatus("FILLING");
            scopeMapper.updateById(scope);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitFill(Long taskId, Long deptId) {
        ReportTaskScope scope = scopeMapper.getByTaskAndDept(taskId, deptId);
        if (scope == null) throw new BusinessException("当前科室不在该任务填报范围内");
        if ("APPROVED".equals(scope.getFillStatus())) {
            throw new BusinessException("已审核通过");
        }
        scope.setFillStatus("SUBMITTED");
        scope.setSubmitTime(LocalDateTime.now());
        scopeMapper.updateById(scope);
        log.info("科室[{}]提交任务[{}]填报", deptId, taskId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void importFromExcel(Long taskId, Long deptId, HttpServletRequest request) throws IOException {
        ReportTaskScope scope = scopeMapper.getByTaskAndDept(taskId, deptId);
        if (scope == null) throw new BusinessException("当前科室不在该任务填报范围内");
        if ("APPROVED".equals(scope.getFillStatus())) {
            throw new BusinessException("已审核通过，无法重新导入");
        }

        ReportTask task = taskMapper.selectById(taskId);
        ReportConfig config = configService.getConfig();
        String effectiveInputMode = StringUtils.isNotBlank(task.getInputMode())
                ? task.getInputMode() : config.getInputMode();

        List<ReportData> importedRows = new ArrayList<>();

        EasyExcel.read(request.getInputStream(), new AnalysisEventListener<Map<Integer, Object>>() {
            boolean firstRow = true;

            @Override
            public void invoke(Map<Integer, Object> row, AnalysisContext context) {
                if (firstRow) { firstRow = false; return; } // 跳过表头
                String metricCode = getString(row, 0);
                String itemCode = getString(row, 3);
                String fillValueStr = getString(row, 5);
                if (StringUtils.isBlank(metricCode) || StringUtils.isBlank(fillValueStr)) return;

                BigDecimal value;
                try {
                    value = new BigDecimal(fillValueStr.trim());
                } catch (NumberFormatException e) {
                    return;
                }

                ReportData rd = new ReportData();
                rd.setTaskId(taskId);
                rd.setDeptId(deptId);
                rd.setMetricCode(metricCode.trim());
                rd.setInputMode(effectiveInputMode);
                rd.setSaveTime(LocalDateTime.now());

                if (StringUtils.isBlank(itemCode) || "【填报结果】".equals(getString(row, 4))) {
                    rd.setIsResultRow(1);
                    rd.setResultValue(value);
                } else {
                    rd.setIsResultRow(0);
                    rd.setItemCode(itemCode.trim());
                    rd.setItemName(getString(row, 4));
                    rd.setInputValue(value);
                }
                importedRows.add(rd);
            }

            @Override
            public void doAfterAllAnalysed(AnalysisContext context) {}

            private String getString(Map<Integer, Object> row, int col) {
                Object v = row.get(col);
                return v == null ? "" : v.toString();
            }
        }).sheet().doRead();

        // 按指标维度原子替换
        Set<String> metricCodesInFile = importedRows.stream()
                .map(ReportData::getMetricCode).collect(Collectors.toSet());
        metricCodesInFile.forEach(code ->
                dataMapper.deleteByTaskAndDeptAndMetric(taskId, deptId, code));
        importedRows.forEach(dataMapper::insert);

        if ("PENDING".equals(scope.getFillStatus())) {
            scope.setFillStatus("FILLING");
            scopeMapper.updateById(scope);
        }
        log.info("科室[{}]通过Excel导入任务[{}]数据，共{}行", deptId, taskId, importedRows.size());
    }

    @Override
    public void exportApprovedData(Long taskId, HttpServletResponse response) throws IOException {
        ReportTask task = taskMapper.selectById(taskId);
        List<List<String>> head = Arrays.asList(
                Collections.singletonList("科室"),
                Collections.singletonList("指标编码"),
                Collections.singletonList("监测指标"),
                Collections.singletonList("指标项编码"),
                Collections.singletonList("指标项名称"),
                Collections.singletonList("填报值/结果值"),
                Collections.singletonList("备注")
        );

        List<ReportTaskScope> approvedScopes = scopeMapper.listByTaskId(taskId).stream()
                .filter(s -> "APPROVED".equals(s.getFillStatus()))
                .collect(Collectors.toList());

        List<List<Object>> rows = new ArrayList<>();
        for (ReportTaskScope scope : approvedScopes) {
            List<ReportData> data = dataMapper.listByTaskAndDept(taskId, scope.getDeptId());
            Map<String, String> metricNames = new HashMap<>();
            for (ReportData d : data) {
                if (!metricNames.containsKey(d.getMetricCode())) {
                    Indicator indicator = indicatorMapper.selectOne(
                            new LambdaQueryWrapper<Indicator>().eq(Indicator::getMetricCode, d.getMetricCode()));
                    metricNames.put(d.getMetricCode(), indicator != null ? indicator.getMetricName() : "");
                }
                BigDecimal val = d.getIsResultRow() == 1 ? d.getResultValue() : d.getInputValue();
                rows.add(Arrays.asList(
                        scope.getDeptName(), d.getMetricCode(),
                        metricNames.get(d.getMetricCode()),
                        StringUtils.defaultString(d.getItemCode()),
                        StringUtils.defaultString(d.getItemName()),
                        val != null ? formatResult(val) : "",
                        StringUtils.defaultString(d.getRemark())
                ));
            }
        }

        String filename = URLEncoder.encode(
                (task != null ? task.getName() : "填报结果") + "_已审核.xlsx", "UTF-8");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + filename);

        EasyExcel.write(response.getOutputStream())
                .head(head)
                .registerWriteHandler(new SimpleColumnWidthStyleStrategy(22))
                .sheet("审核通过数据")
                .doWrite(rows);
    }

    // ===================== private helpers =====================

    private ReportData buildResultRow(ReportDataSaveDTO dto, String inputMode, BigDecimal value) {
        ReportData rd = new ReportData();
        rd.setTaskId(dto.getTaskId());
        rd.setDeptId(dto.getDeptId());
        rd.setMetricCode(dto.getMetricCode());
        rd.setIsResultRow(1);
        rd.setInputMode(inputMode);
        rd.setResultValue(value);
        rd.setRemark(dto.getRemark());
        rd.setSaveTime(LocalDateTime.now());
        return rd;
    }

    private List<IndicatorItem> loadItems(Indicator indicator) {
        if (StringUtils.isBlank(indicator.getRelatedItems())) return Collections.emptyList();
        List<String> codes = JSON.parseArray(indicator.getRelatedItems(), String.class);
        if (codes.isEmpty()) return Collections.emptyList();
        return indicatorItemMapper.selectList(
                new LambdaQueryWrapper<IndicatorItem>().in(IndicatorItem::getItemCode, codes));
    }

    /**
     * 尝试用 Aviator 根据指标表达式 + 指标项值计算结果。
     * 表达式里的变量名即 itemCode。
     */
    private BigDecimal tryCompute(String metricCode, List<ReportDataSaveDTO.ItemValueDTO> items) {
        try {
            Indicator indicator = indicatorMapper.selectOne(
                    new LambdaQueryWrapper<Indicator>().eq(Indicator::getMetricCode, metricCode));
            if (indicator == null || StringUtils.isBlank(indicator.getExpression())) return null;

            Map<String, Object> env = new HashMap<>();
            for (ReportDataSaveDTO.ItemValueDTO item : items) {
                if (item.getItemCode() != null && item.getInputValue() != null) {
                    env.put(item.getItemCode(), item.getInputValue().doubleValue());
                }
            }
            Object result = AviatorEvaluator.execute(indicator.getExpression(), env);
            if (result instanceof Number) {
                return BigDecimal.valueOf(((Number) result).doubleValue())
                        .setScale(4, RoundingMode.HALF_UP);
            }
        } catch (Exception e) {
            log.warn("填报数据自动计算失败，metricCode={}，原因：{}", metricCode, e.getMessage());
        }
        return null;
    }

    /**
     * 结果格式化：保留4位小数，去除尾部无效零。
     * 100.1000 → "100.1"，78.5400 → "78.54"
     */
    private String formatResult(BigDecimal value) {
        if (value == null) return "";
        return value.setScale(4, RoundingMode.HALF_UP).stripTrailingZeros().toPlainString();
    }
}
