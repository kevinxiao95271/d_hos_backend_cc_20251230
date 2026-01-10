package com.hospital.indicator.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.dto.IndicatorItemExecuteResultDTO;
import com.hospital.indicator.dto.IndicatorItemSaveDTO;
import com.hospital.indicator.entity.IndicatorItem;
import com.hospital.indicator.mapper.IndicatorItemMapper;
import com.hospital.indicator.service.IndicatorItemService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 指标项服务实现类
 *
 * @author Claude
 * @date 2025-12-30
 */
@Slf4j
@Service
public class IndicatorItemServiceImpl extends ServiceImpl<IndicatorItemMapper, IndicatorItem> implements IndicatorItemService {

    /**
     * 参数占位符正则表达式（匹配 #{paramName} 格式）
     */
    private static final Pattern PARAM_PATTERN = Pattern.compile("#\\{(\\w+)\\}");

    @Override
    @Transactional(rollbackFor = Exception.class)
    public IndicatorItem saveOrUpdateIndicatorItem(IndicatorItemSaveDTO dto) {
        // 校验指标项编码唯一性
        LambdaQueryWrapper<IndicatorItem> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(IndicatorItem::getItemCode, dto.getItemCode());
        if (dto.getId() != null) {
            queryWrapper.ne(IndicatorItem::getId, dto.getId());
        }
        if (this.count(queryWrapper) > 0) {
            throw new BusinessException("指标项编码已存在：" + dto.getItemCode());
        }

        // 校验SQL有效性（如果有SQL）
        if (StringUtils.isNotBlank(dto.getQuerySql()) && !validateSql(dto.getQuerySql())) {
            throw new BusinessException("SQL语句格式不正确");
        }

        // 转换DTO为实体
        IndicatorItem entity = new IndicatorItem();
        BeanUtils.copyProperties(dto, entity);

        // 保存或更新
        this.saveOrUpdate(entity);
        return entity;
    }

    @Override
    public IndicatorItemExecuteResultDTO executeQuery(String itemCode, String startDate, String endDate, Map<String, Object> params) {
        IndicatorItemExecuteResultDTO result = new IndicatorItemExecuteResultDTO();

        try {
            // 1. 根据编码查找指标项
            LambdaQueryWrapper<IndicatorItem> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.eq(IndicatorItem::getItemCode, itemCode);
            IndicatorItem item = this.getOne(queryWrapper);

            if (item == null) {
                throw new BusinessException("指标项不存在：" + itemCode);
            }

            if (item.getStatus() != 1) {
                throw new BusinessException("指标项已禁用：" + itemCode);
            }

            if (StringUtils.isBlank(item.getQuerySql())) {
                throw new BusinessException("指标项未配置SQL查询：" + itemCode);
            }

            // 2. 准备参数Map
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("startDate", startDate);
            paramMap.put("endDate", endDate);
            if (params != null) {
                paramMap.putAll(params);
            }

            // 3. 替换SQL中的参数占位符
            String querySql = replaceSqlParams(item.getQuerySql(), paramMap);
            log.info("执行指标项查询 [{}]: {}", itemCode, querySql);

            // 4. 执行SQL查询
            Object queryResult = baseMapper.executeSingleValueQuery(querySql);

            // 5. 封装返回结果
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("result_value", queryResult);
            resultMap.put("item_code", itemCode);
            resultMap.put("item_name", item.getItemName());
            resultMap.put("unit", item.getUnit());

            result.setSuccess(true);
            result.setResult(resultMap);
            result.setQuerySql(querySql);

        } catch (Exception e) {
            log.error("执行指标项查询失败 [{}]: {}", itemCode, e.getMessage(), e);
            result.setSuccess(false);
            result.setErrorMessage(e.getMessage());
        }

        return result;
    }

    @Override
    public boolean validateSql(String sql) {
        if (StringUtils.isBlank(sql)) {
            return false;
        }

        try {
            // 基本的SQL关键字检查
            String upperSql = sql.trim().toUpperCase();

            // 必须是SELECT语句
            if (!upperSql.startsWith("SELECT")) {
                return false;
            }

            // 禁止包含危险操作（INSERT、UPDATE、DELETE、DROP、TRUNCATE等）
            if (upperSql.contains("INSERT") || upperSql.contains("UPDATE") ||
                    upperSql.contains("DELETE") || upperSql.contains("DROP") ||
                    upperSql.contains("TRUNCATE") || upperSql.contains("ALTER")) {
                return false;
            }

            // 检查SQL基本结构（必须包含FROM关键字）
            if (!upperSql.contains("FROM")) {
                return false;
            }

            return true;
        } catch (Exception e) {
            log.error("SQL校验异常: {}", e.getMessage(), e);
            return false;
        }
    }

    /**
     * 替换SQL中的参数占位符
     * 将 #{paramName} 替换为实际参数值
     *
     * @param sql      原始SQL
     * @param paramMap 参数Map
     * @return 替换后的SQL
     */
    private String replaceSqlParams(String sql, Map<String, Object> paramMap) {
        if (StringUtils.isBlank(sql) || paramMap == null || paramMap.isEmpty()) {
            return sql;
        }

        StringBuffer result = new StringBuffer();
        Matcher matcher = PARAM_PATTERN.matcher(sql);

        while (matcher.find()) {
            String paramName = matcher.group(1);  // 获取参数名（不包括 #{} ）
            Object paramValue = paramMap.get(paramName);

            // 如果参数不存在，抛出异常
            if (paramValue == null) {
                throw new BusinessException("SQL参数缺失：" + paramName);
            }

            // 替换参数（字符串类型需要加单引号）
            String replacement;
            if (paramValue instanceof String) {
                replacement = "'" + paramValue + "'";
            } else {
                replacement = paramValue.toString();
            }

            matcher.appendReplacement(result, replacement);
        }
        matcher.appendTail(result);

        return result.toString();
    }

}
