package com.hospital.indicator.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.entity.IndicatorDeptScope;
import com.hospital.indicator.mapper.IndicatorDeptScopeMapper;
import com.hospital.indicator.service.IndicatorScopeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
public class IndicatorScopeServiceImpl implements IndicatorScopeService {

    @Autowired
    private IndicatorDeptScopeMapper scopeMapper;

    @Override
    public List<IndicatorDeptScope> listByDept(Long deptId) {
        LambdaQueryWrapper<IndicatorDeptScope> q = new LambdaQueryWrapper<>();
        q.eq(IndicatorDeptScope::getRootDeptId, deptId)
         .orderByAsc(IndicatorDeptScope::getMetricCode);
        return scopeMapper.selectList(q);
    }

    @Override
    public List<IndicatorDeptScope> listByMetric(String metricCode) {
        LambdaQueryWrapper<IndicatorDeptScope> q = new LambdaQueryWrapper<>();
        q.eq(IndicatorDeptScope::getMetricCode, metricCode)
         .orderByAsc(IndicatorDeptScope::getRootDeptId);
        return scopeMapper.selectList(q);
    }

    @Override
    @Transactional
    public void addBinding(Long deptId, String metricCode, Integer isPrimaryOwner) {
        LambdaQueryWrapper<IndicatorDeptScope> q = new LambdaQueryWrapper<>();
        q.eq(IndicatorDeptScope::getRootDeptId, deptId)
         .eq(IndicatorDeptScope::getMetricCode, metricCode);
        if (scopeMapper.selectCount(q) > 0) {
            return; // 已存在，忽略
        }
        IndicatorDeptScope record = new IndicatorDeptScope();
        record.setRootDeptId(deptId);
        record.setMetricCode(metricCode);
        record.setIsPrimaryOwner(isPrimaryOwner == null ? 1 : isPrimaryOwner);
        scopeMapper.insert(record);
        log.info("新增科室指标绑定: deptId={} metricCode={}", deptId, metricCode);
    }

    @Override
    @Transactional
    public void replaceByDept(Long deptId, List<String> metricCodes, Integer isPrimaryOwner) {
        if (deptId == null) throw new BusinessException("科室ID不能为空");
        scopeMapper.deleteByDeptId(deptId);
        if (metricCodes == null || metricCodes.isEmpty()) return;
        int owner = isPrimaryOwner == null ? 1 : isPrimaryOwner;
        for (String code : metricCodes) {
            IndicatorDeptScope record = new IndicatorDeptScope();
            record.setRootDeptId(deptId);
            record.setMetricCode(code.trim());
            record.setIsPrimaryOwner(owner);
            scopeMapper.insert(record);
        }
        log.info("批量替换科室指标绑定: deptId={} 共{}条", deptId, metricCodes.size());
    }

    @Override
    @Transactional
    public void replaceByMetric(String metricCode, List<Long> deptIds, Integer isPrimaryOwner) {
        if (metricCode == null || metricCode.isEmpty()) throw new BusinessException("指标编码不能为空");
        scopeMapper.deleteByMetricCode(metricCode);
        if (deptIds == null || deptIds.isEmpty()) return;
        int owner = isPrimaryOwner == null ? 1 : isPrimaryOwner;
        for (Long deptId : deptIds) {
            IndicatorDeptScope record = new IndicatorDeptScope();
            record.setRootDeptId(deptId);
            record.setMetricCode(metricCode);
            record.setIsPrimaryOwner(owner);
            scopeMapper.insert(record);
        }
        log.info("批量替换指标科室绑定: metricCode={} 共{}个科室", metricCode, deptIds.size());
    }

    @Override
    @Transactional
    public void removeBinding(Long deptId, String metricCode) {
        LambdaQueryWrapper<IndicatorDeptScope> q = new LambdaQueryWrapper<>();
        q.eq(IndicatorDeptScope::getRootDeptId, deptId)
         .eq(IndicatorDeptScope::getMetricCode, metricCode);
        int rows = scopeMapper.delete(q);
        log.info("删除科室指标绑定: deptId={} metricCode={} rows={}", deptId, metricCode, rows);
    }

    @Override
    @Transactional
    public void clearByDept(Long deptId) {
        int rows = scopeMapper.deleteByDeptId(deptId);
        log.info("清空科室全部指标绑定: deptId={} rows={}", deptId, rows);
    }

    @Override
    @Transactional
    public void clearByMetric(String metricCode) {
        int rows = scopeMapper.deleteByMetricCode(metricCode);
        log.info("清空指标全部科室绑定: metricCode={} rows={}", metricCode, rows);
    }
}
