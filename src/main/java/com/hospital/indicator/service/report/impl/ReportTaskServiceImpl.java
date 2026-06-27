package com.hospital.indicator.service.report.impl;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.write.style.column.SimpleColumnWidthStyleStrategy;
import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.context.UserContext;
import com.hospital.indicator.dto.report.*;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.entity.IndicatorItem;
import com.hospital.indicator.entity.report.*;
import com.hospital.indicator.mapper.IndicatorItemMapper;
import com.hospital.indicator.mapper.IndicatorMapper;
import com.hospital.indicator.mapper.report.*;
import com.hospital.indicator.service.report.ReportConfigService;
import com.hospital.indicator.service.report.ReportTaskService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
public class ReportTaskServiceImpl implements ReportTaskService {

    @Autowired
    private ReportTaskMapper taskMapper;
    @Autowired
    private ReportTaskScopeMapper scopeMapper;
    @Autowired
    private ReportTemplateMapper templateMapper;
    @Autowired
    private ReportTemplateItemMapper templateItemMapper;
    @Autowired
    private ReportConfigService configService;
    @Autowired
    private IndicatorMapper indicatorMapper;
    @Autowired
    private IndicatorItemMapper indicatorItemMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ReportTask createTask(ReportTaskCreateDTO dto, String operator) {
        ReportTask task = new ReportTask();
        BeanUtils.copyProperties(dto, task);
        task.setStatus("DRAFT");
        task.setCreatedBy(operator);
        task.setCreateTime(LocalDateTime.now());
        taskMapper.insert(task);

        saveScopes(task.getId(), dto.getScopes());
        log.info("填报任务创建完成，taskId={}, 操作人={}", task.getId(), operator);
        return task;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ReportTask createFromTemplate(Long templateId, ReportTaskCreateDTO baseInfo, String operator) {
        ReportTemplate template = templateMapper.selectById(templateId);
        if (template == null) {
            throw new BusinessException("模板不存在：" + templateId);
        }
        List<ReportTemplateItem> items = templateItemMapper.listByTemplateId(templateId);

        ReportTask task = new ReportTask();
        BeanUtils.copyProperties(baseInfo, task);
        task.setStatus("DRAFT");
        task.setTemplateId(templateId);
        task.setCreatedBy(operator);
        task.setCreateTime(LocalDateTime.now());
        taskMapper.insert(task);

        List<ReportTaskCreateDTO.ScopeItemDTO> scopes = items.stream().map(item -> {
            ReportTaskCreateDTO.ScopeItemDTO s = new ReportTaskCreateDTO.ScopeItemDTO();
            s.setDeptId(item.getDeptId());
            s.setDeptName(item.getDeptName());
            s.setMetricCodes(JSON.parseArray(item.getMetricCodes(), String.class));
            return s;
        }).collect(Collectors.toList());

        saveScopes(task.getId(), scopes);
        log.info("从模板[{}]创建填报任务，taskId={}", templateId, task.getId());
        return task;
    }

    @Override
    public IPage<ReportTask> pageTask(int current, int size, String name, String status, String timeDimension) {
        return taskMapper.pageByCondition(new Page<>(current, size), name, status, timeDimension);
    }

    @Override
    public ReportTaskDetailVO getTaskDetail(Long taskId) {
        ReportTask task = taskMapper.selectById(taskId);
        if (task == null) {
            throw new BusinessException("任务不存在：" + taskId);
        }
        ReportConfig config = configService.getConfig();
        ReportTaskDetailVO vo = new ReportTaskDetailVO();
        BeanUtils.copyProperties(task, vo);
        vo.setInputMode(StringUtils.isNotBlank(task.getInputMode()) ? task.getInputMode() : config.getInputMode());
        vo.setReviewMode(StringUtils.isNotBlank(task.getReviewMode()) ? task.getReviewMode() : config.getReviewMode());

        List<ReportTaskScope> scopes = scopeMapper.listByTaskId(taskId);
        List<ReportTaskDetailVO.ScopeVO> scopeVOs = scopes.stream().map(s -> {
            ReportTaskDetailVO.ScopeVO sv = new ReportTaskDetailVO.ScopeVO();
            sv.setDeptId(s.getDeptId());
            sv.setDeptName(s.getDeptName());
            sv.setFillStatus(s.getFillStatus());
            sv.setSubmitTime(s.getSubmitTime());
            sv.setReviewComment(s.getReviewComment());
            if (StringUtils.isNotBlank(s.getMetricCodes())) {
                sv.setMetricCodes(JSON.parseArray(s.getMetricCodes(), String.class));
            }
            return sv;
        }).collect(Collectors.toList());
        vo.setScopes(scopeVOs);
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void publishTask(Long taskId, String operator) {
        ReportTask task = taskMapper.selectById(taskId);
        if (task == null) {
            throw new BusinessException("任务不存在：" + taskId);
        }
        if (!"DRAFT".equals(task.getStatus())) {
            throw new BusinessException("只有草稿状态的任务可以发布");
        }
        taskMapper.update(null, new LambdaUpdateWrapper<ReportTask>()
                .eq(ReportTask::getId, taskId)
                .set(ReportTask::getStatus, "PUBLISHED")
                .set(ReportTask::getUpdateTime, LocalDateTime.now()));
        log.info("任务[{}]已发布，操作人={}", taskId, operator);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void closeTask(Long taskId, String operator) {
        taskMapper.update(null, new LambdaUpdateWrapper<ReportTask>()
                .eq(ReportTask::getId, taskId)
                .set(ReportTask::getStatus, "CLOSED")
                .set(ReportTask::getUpdateTime, LocalDateTime.now()));
        log.info("任务[{}]已关闭，操作人={}", taskId, operator);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long saveAsTemplate(Long taskId, String templateName, String operator) {
        ReportConfig config = configService.getConfig();

        if ("VERSIONED".equals(config.getVersionStrategy())) {
            // 保留历史版本，新版本isCurrent=1，旧版本isCurrent=0
            List<ReportTemplate> existing = templateMapper.selectList(
                    new LambdaQueryWrapper<ReportTemplate>().eq(ReportTemplate::getName, templateName));
            if (!existing.isEmpty()) {
                existing.forEach(t -> {
                    t.setIsCurrent(0);
                    templateMapper.updateById(t);
                });
            }
            int nextVersion = existing.stream().mapToInt(ReportTemplate::getVersion).max().orElse(0) + 1;

            ReportTemplate tpl = new ReportTemplate();
            tpl.setName(templateName);
            tpl.setVersion(nextVersion);
            tpl.setIsCurrent(1);
            tpl.setSourceTaskId(taskId);
            tpl.setCreatedBy(operator);
            tpl.setCreateTime(LocalDateTime.now());
            templateMapper.insert(tpl);
            saveTemplateItems(tpl.getId(), taskId);
            return tpl.getId();
        } else {
            // OVERWRITE：删除同名旧模板，重建
            List<ReportTemplate> existing = templateMapper.selectList(
                    new LambdaQueryWrapper<ReportTemplate>().eq(ReportTemplate::getName, templateName));
            existing.forEach(t -> {
                templateItemMapper.delete(new LambdaQueryWrapper<ReportTemplateItem>()
                        .eq(ReportTemplateItem::getTemplateId, t.getId()));
                templateMapper.deleteById(t.getId());
            });

            ReportTemplate tpl = new ReportTemplate();
            tpl.setName(templateName);
            tpl.setVersion(1);
            tpl.setIsCurrent(1);
            tpl.setSourceTaskId(taskId);
            tpl.setCreatedBy(operator);
            tpl.setCreateTime(LocalDateTime.now());
            templateMapper.insert(tpl);
            saveTemplateItems(tpl.getId(), taskId);
            return tpl.getId();
        }
    }

    @Override
    public List<ReportTaskDetailVO.ScopeVO> listTemplateScopes(Long templateId) {
        List<ReportTemplateItem> items = templateItemMapper.listByTemplateId(templateId);
        return items.stream().map(item -> {
            ReportTaskDetailVO.ScopeVO sv = new ReportTaskDetailVO.ScopeVO();
            sv.setDeptId(item.getDeptId());
            sv.setDeptName(item.getDeptName());
            if (StringUtils.isNotBlank(item.getMetricCodes())) {
                sv.setMetricCodes(JSON.parseArray(item.getMetricCodes(), String.class));
            }
            return sv;
        }).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reviewDeptFill(ReviewActionDTO dto, String reviewer) {
        ReportTaskScope scope = scopeMapper.getByTaskAndDept(dto.getTaskId(), dto.getDeptId());
        if (scope == null) {
            throw new BusinessException("未找到对应的科室填报记录");
        }
        if (!"SUBMITTED".equals(scope.getFillStatus())) {
            throw new BusinessException("该科室填报尚未提交，无法审核");
        }
        if ("REJECTED".equals(dto.getAction()) && StringUtils.isBlank(dto.getComment())) {
            throw new BusinessException("打回必须填写原因");
        }
        String newStatus = "APPROVED".equals(dto.getAction()) ? "APPROVED" : "REJECTED";
        scope.setFillStatus(newStatus);
        scope.setReviewTime(LocalDateTime.now());
        scope.setReviewBy(reviewer);
        scope.setReviewComment(dto.getComment());
        scopeMapper.updateById(scope);
        log.info("任务[{}]科室[{}]审核结果={}", dto.getTaskId(), dto.getDeptId(), newStatus);
    }

    @Override
    public void exportFillTemplate(Long taskId, Long deptId, HttpServletResponse response) throws IOException {
        ReportTaskScope scope = scopeMapper.getByTaskAndDept(taskId, deptId);
        if (scope == null) {
            throw new BusinessException("未找到该科室的填报范围");
        }
        List<String> metricCodes = JSON.parseArray(scope.getMetricCodes(), String.class);

        // 构建表头和空白数据行
        List<List<String>> head = buildExcelHead();
        List<List<Object>> data = buildExcelData(taskId, deptId, metricCodes);

        ReportTask task = taskMapper.selectById(taskId);
        String filename = URLEncoder.encode(
                (task != null ? task.getName() : "填报模板") + "_" + scope.getDeptName() + ".xlsx", "UTF-8");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + filename);

        EasyExcel.write(response.getOutputStream())
                .head(head)
                .registerWriteHandler(new SimpleColumnWidthStyleStrategy(20))
                .sheet("填报数据")
                .doWrite(data);
    }

    // ===================== private helpers =====================

    private void saveScopes(Long taskId, List<ReportTaskCreateDTO.ScopeItemDTO> scopes) {
        if (scopes == null || scopes.isEmpty()) return;
        for (ReportTaskCreateDTO.ScopeItemDTO s : scopes) {
            ReportTaskScope scope = new ReportTaskScope();
            scope.setTaskId(taskId);
            scope.setDeptId(s.getDeptId());
            scope.setDeptName(s.getDeptName());
            scope.setMetricCodes(JSON.toJSONString(s.getMetricCodes()));
            scope.setFillStatus("PENDING");
            scope.setUpdateTime(LocalDateTime.now());
            scopeMapper.insert(scope);
        }
    }

    private void saveTemplateItems(Long templateId, Long taskId) {
        List<ReportTaskScope> scopes = scopeMapper.listByTaskId(taskId);
        for (ReportTaskScope s : scopes) {
            ReportTemplateItem item = new ReportTemplateItem();
            item.setTemplateId(templateId);
            item.setDeptId(s.getDeptId());
            item.setDeptName(s.getDeptName());
            item.setMetricCodes(s.getMetricCodes());
            templateItemMapper.insert(item);
        }
    }

    private List<List<String>> buildExcelHead() {
        return Arrays.asList(
                Collections.singletonList("指标编码"),
                Collections.singletonList("监测指标"),
                Collections.singletonList("计算方法"),
                Collections.singletonList("指标项编码"),
                Collections.singletonList("指标项名称"),
                Collections.singletonList("填报值"),
                Collections.singletonList("备注")
        );
    }

    private List<List<Object>> buildExcelData(Long taskId, Long deptId, List<String> metricCodes) {
        List<List<Object>> rows = new ArrayList<>();
        for (String code : metricCodes) {
            Indicator indicator = indicatorMapper.selectOne(
                    new LambdaQueryWrapper<Indicator>().eq(Indicator::getMetricCode, code));
            if (indicator == null) continue;

            // 获取该指标的指标项
            List<IndicatorItem> items = new ArrayList<>();
            if (StringUtils.isNotBlank(indicator.getRelatedItems())) {
                List<String> itemCodes = JSON.parseArray(indicator.getRelatedItems(), String.class);
                if (!itemCodes.isEmpty()) {
                    items = indicatorItemMapper.selectList(
                            new LambdaQueryWrapper<IndicatorItem>().in(IndicatorItem::getItemCode, itemCodes));
                }
            }

            if (items.isEmpty()) {
                // 无指标项，直接填结果行
                rows.add(Arrays.asList(
                        code, indicator.getMetricName(),
                        StringUtils.defaultString(indicator.getExpression()), "", "【填报结果】", "", ""));
            } else {
                // 有指标项，每项一行
                for (IndicatorItem item : items) {
                    rows.add(Arrays.asList(
                            code, indicator.getMetricName(),
                            StringUtils.defaultString(indicator.getExpression()),
                            item.getItemCode(), item.getItemName(), "", ""));
                }
            }
        }
        return rows;
    }
}
