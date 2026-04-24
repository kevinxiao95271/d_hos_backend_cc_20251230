package com.hospital.indicator.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.hospital.indicator.common.BusinessException;
import com.hospital.indicator.entity.Indicator;
import com.hospital.indicator.entity.IndicatorItem;
import com.hospital.indicator.entity.IndicatorResult;
import com.hospital.indicator.entity.IndicatorResultDept;
import com.hospital.indicator.mapper.IndicatorItemMapper;
import com.hospital.indicator.mapper.IndicatorMapper;
import com.hospital.indicator.mapper.IndicatorResultMapper;
import com.hospital.indicator.mapper.IndicatorResultDeptMapper;
import com.hospital.indicator.service.IndicatorCalculationService;
import com.hospital.indicator.util.ExpressionParser;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 指标计算引擎实现类
 * 核心职责：
 * 1. 执行指标项的SQL查询，获取原始数据
 * 2. 根据指标的表达式计算最终结果
 * 3. 支持按不同时间维度进行计算
 * 4. 保存计算结果到数据库
 *
 * @author Claude
 * @date 2025-12-30
 */
@Slf4j
@Service
public class IndicatorCalculationServiceImpl implements IndicatorCalculationService {

    @Autowired
    private IndicatorMapper indicatorMapper;

    @Autowired
    private IndicatorItemMapper indicatorItemMapper;

    @Autowired
    private IndicatorResultMapper indicatorResultMapper;

    @Autowired
    private IndicatorResultDeptMapper indicatorResultDeptMapper;

    /**
     * SQL参数占位符正则
     */
    private static final Pattern PARAM_PATTERN = Pattern.compile("#\\{(\\w+)\\}");

    @Override
    @Transactional(rollbackFor = Exception.class)
    public IndicatorResult calculateIndicator(String metricCode, String timeDimension, LocalDate startDate, LocalDate endDate) {
        try {
            // 1. 查询指标配置
            Indicator indicator = getIndicatorByCode(metricCode);
            if (indicator.getIsLeaf() != 1) {
                throw new BusinessException("只能计算叶子节点指标");
            }

            // 2. 解析关联的指标项
            List<String> itemCodes = parseRelatedItems(indicator.getRelatedItems());
            if (itemCodes.isEmpty()) {
                throw new BusinessException("指标未配置关联的指标项");
            }

            // 3. 查询所有指标项的值
            Map<String, BigDecimal> itemValueMap = queryItemValues(itemCodes, startDate, endDate);

            // 4. 计算指标结果
            BigDecimal resultValue;
            if ("ITEM".equals(indicator.getCalculationType())) {
                // 直接使用指标项的值
                String itemCode = itemCodes.get(0);
                resultValue = itemValueMap.get(itemCode);
            } else {
                // 使用表达式计算
                resultValue = ExpressionParser.calculate(indicator.getExpression(), itemValueMap);
            }

            // 5. 构建结果JSON（包含所有指标项的值）
            Map<String, Object> resultJsonMap = new HashMap<>();
            resultJsonMap.put("metric_code", metricCode);
            resultJsonMap.put("metric_name", indicator.getMetricName());
            resultJsonMap.put("result_value", resultValue);
            resultJsonMap.put("unit", indicator.getUnit());
            resultJsonMap.put("expression", indicator.getExpression());

            // 添加所有指标项的值
            Map<String, Object> itemValues = new HashMap<>();
            for (Map.Entry<String, BigDecimal> entry : itemValueMap.entrySet()) {
                itemValues.put(entry.getKey(), entry.getValue());
            }
            resultJsonMap.put("item_values", itemValues);

            // 6. 计算时间值
            String timeValue = calculateTimeValue(timeDimension, startDate, endDate);

            // 7. 保存或更新计算结果
            IndicatorResult result = saveOrUpdateResult(
                    metricCode, timeDimension, timeValue, startDate, endDate,
                    resultValue, JSON.toJSONString(resultJsonMap)
            );

            return result;

        } catch (Exception e) {
            log.error("指标计算失败: metricCode={}, error={}", metricCode, e.getMessage(), e);

            // 保存失败记录
            String timeValue = calculateTimeValue(timeDimension, startDate, endDate);
            return saveFailedResult(metricCode, timeDimension, timeValue, startDate, endDate, e.getMessage());
        }
    }

    @Override
    public List<IndicatorResult> batchCalculateIndicators(List<String> metricCodes, String timeDimension,
                                                          LocalDate startDate, LocalDate endDate) {
        // 如果未指定指标编码，查询所有叶子指标
        if (metricCodes == null || metricCodes.isEmpty()) {
            LambdaQueryWrapper<Indicator> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Indicator::getIsLeaf, 1);
            wrapper.eq(Indicator::getStatus, 1);
            List<Indicator> indicators = indicatorMapper.selectList(wrapper);
            metricCodes = new ArrayList<>();
            for (Indicator indicator : indicators) {
                metricCodes.add(indicator.getMetricCode());
            }
        }

        // 根据时间维度拆分时间段
        List<Map<String, LocalDate>> timeRanges = splitTimeRanges(timeDimension, startDate, endDate);

        List<IndicatorResult> results = new ArrayList<>();

        // 对每个时间段和每个指标进行计算
        for (Map<String, LocalDate> timeRange : timeRanges) {
            LocalDate rangeStart = timeRange.get("start");
            LocalDate rangeEnd = timeRange.get("end");

            for (String metricCode : metricCodes) {
                try {
                    IndicatorResult result = calculateIndicator(metricCode, timeDimension, rangeStart, rangeEnd);
                    results.add(result);
                } catch (Exception e) {
                    log.error("批量计算指标失败: metricCode={}, error={}", metricCode, e.getMessage(), e);
                }
            }
        }

        return results;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public List<IndicatorResultDept> calculateDeptDrill(String metricCode, String timeDimension, LocalDate startDate, LocalDate endDate) {
        List<IndicatorResultDept> results = new ArrayList<>();

        try {
            // 1. 查询指标配置
            Indicator indicator = getIndicatorByCode(metricCode);
            if (indicator.getIsLeaf() != 1) {
                throw new BusinessException("只能计算叶子节点指标");
            }

            // 2. 解析关联的指标项
            List<String> itemCodes = parseRelatedItems(indicator.getRelatedItems());
            if (itemCodes.isEmpty()) {
                throw new BusinessException("指标未配置关联的指标项");
            }

            // 3. 查询按科室分组的指标项数据
            Map<String, Map<String, BigDecimal>> deptItemValuesMap = queryDeptItemValues(itemCodes, startDate, endDate);

            // 4. 计算时间值
            String timeValue = calculateTimeValue(timeDimension, startDate, endDate);

            // 5. 对每个科室计算指标
            for (Map.Entry<String, Map<String, BigDecimal>> entry : deptItemValuesMap.entrySet()) {
                String deptKey = entry.getKey(); // 格式: "deptCode|deptName"
                Map<String, BigDecimal> itemValueMap = entry.getValue();

                String[] deptInfo = deptKey.split("\\|");
                String deptCode = deptInfo[0];
                String deptName = deptInfo.length > 1 ? deptInfo[1] : deptCode;

                try {
                    // 计算该科室的指标结果
                    BigDecimal resultValue;
                    if ("ITEM".equals(indicator.getCalculationType())) {
                        // 直接使用指标项的值
                        String itemCode = itemCodes.get(0);
                        resultValue = itemValueMap.get(itemCode);
                    } else {
                        // 使用表达式计算，ExpressionParser会自动处理除零异常
                        resultValue = ExpressionParser.calculate(indicator.getExpression(), itemValueMap);
                    }

                    // 构建结果JSON
                    Map<String, Object> resultJsonMap = new HashMap<>();
                    resultJsonMap.put("metric_code", metricCode);
                    resultJsonMap.put("metric_name", indicator.getMetricName());
                    resultJsonMap.put("dept_code", deptCode);
                    resultJsonMap.put("dept_name", deptName);
                    resultJsonMap.put("result_value", resultValue);
                    resultJsonMap.put("unit", indicator.getUnit());
                    resultJsonMap.put("expression", indicator.getExpression());

                    // 添加所有指标项的值
                    Map<String, Object> itemValues = new HashMap<>();
                    for (Map.Entry<String, BigDecimal> itemEntry : itemValueMap.entrySet()) {
                        itemValues.put(itemEntry.getKey(), itemEntry.getValue());
                    }
                    resultJsonMap.put("item_values", itemValues);

                    // 保存或更新科室下钻结果
                    IndicatorResultDept deptResult = saveOrUpdateDeptResult(
                            metricCode, timeDimension, timeValue,
                            deptCode, deptName, resultValue,
                            JSON.toJSONString(resultJsonMap)
                    );

                    results.add(deptResult);

                } catch (Exception e) {
                    log.error("科室下钻计算失败: metricCode={}, dept={}, error={}",
                            metricCode, deptName, e.getMessage(), e);
                    // 单个科室失败不影响其他科室
                }
            }

        } catch (Exception e) {
            log.error("科室下钻计算异常: metricCode={}, error={}", metricCode, e.getMessage(), e);
            throw new BusinessException("科室下钻计算失败：" + e.getMessage());
        }

        return results;
    }

    /**
     * 根据编码查询指标
     */
    private Indicator getIndicatorByCode(String metricCode) {
        LambdaQueryWrapper<Indicator> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Indicator::getMetricCode, metricCode);
        Indicator indicator = indicatorMapper.selectOne(wrapper);

        if (indicator == null) {
            throw new BusinessException("指标不存在：" + metricCode);
        }
        if (indicator.getStatus() != 1) {
            throw new BusinessException("指标已禁用：" + metricCode);
        }

        return indicator;
    }

    /**
     * 解析关联的指标项编码
     */
    private List<String> parseRelatedItems(String relatedItemsJson) {
        if (StringUtils.isBlank(relatedItemsJson)) {
            return Collections.emptyList();
        }

        try {
            return JSON.parseObject(relatedItemsJson, new TypeReference<List<String>>() {});
        } catch (Exception e) {
            log.error("解析关联指标项失败: {}", relatedItemsJson, e);
            return Collections.emptyList();
        }
    }

    /**
     * 查询指标项的值
     * 该方法会执行每个指标项配置的SQL，获取查询结果
     */
    private Map<String, BigDecimal> queryItemValues(List<String> itemCodes, LocalDate startDate, LocalDate endDate) {
        Map<String, BigDecimal> valueMap = new HashMap<>();

        for (String itemCode : itemCodes) {
            try {
                // 1. 查询指标项配置
                LambdaQueryWrapper<IndicatorItem> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(IndicatorItem::getItemCode, itemCode);
                IndicatorItem item = indicatorItemMapper.selectOne(wrapper);

                if (item == null) {
                    throw new BusinessException("指标项不存在：" + itemCode);
                }
                if (item.getStatus() != 1) {
                    throw new BusinessException("指标项已禁用：" + itemCode);
                }
                if (StringUtils.isBlank(item.getQuerySql())) {
                    throw new BusinessException("指标项未配置SQL：" + itemCode);
                }

                // 2. 替换SQL中的参数
                String sql = replaceSqlParams(item.getQuerySql(), startDate, endDate);
                log.debug("执行指标项SQL [{}]: {}", itemCode, sql);

                // 3. 执行SQL查询
                Object result = indicatorItemMapper.executeSingleValueQuery(sql);

                // 4. 转换结果为BigDecimal
                BigDecimal value;
                if (result == null) {
                    value = BigDecimal.ZERO;
                } else if (result instanceof BigDecimal) {
                    value = (BigDecimal) result;
                } else if (result instanceof Number) {
                    value = new BigDecimal(result.toString());
                } else {
                    value = new BigDecimal(result.toString());
                }

                valueMap.put(itemCode, value);

            } catch (Exception e) {
                log.error("查询指标项失败: itemCode={}, error={}", itemCode, e.getMessage(), e);
                throw new BusinessException("查询指标项失败：" + itemCode + ", " + e.getMessage());
            }
        }

        return valueMap;
    }

    /**
     * 替换SQL中的参数占位符
     */
    private String replaceSqlParams(String sql, LocalDate startDate, LocalDate endDate) {
        Map<String, Object> paramMap = new HashMap<>();
        // 使用标准日期格式 yyyy-MM-dd,MySQL会自动转换用于与STR_TO_DATE结果比较
        paramMap.put("startDate", startDate.toString());
        paramMap.put("endDate", endDate.toString());

        StringBuffer result = new StringBuffer();
        Matcher matcher = PARAM_PATTERN.matcher(sql);

        while (matcher.find()) {
            String paramName = matcher.group(1);
            Object paramValue = paramMap.get(paramName);

            if (paramValue == null) {
                throw new BusinessException("SQL参数缺失：" + paramName);
            }

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

    /**
     * 计算时间值字符串
     */
    private String calculateTimeValue(String timeDimension, LocalDate startDate, LocalDate endDate) {
        switch (timeDimension.toUpperCase()) {
            case "YEAR":
                return String.valueOf(startDate.getYear());
            case "QUARTER":
                int quarter = (startDate.getMonthValue() - 1) / 3 + 1;
                return startDate.getYear() + "-Q" + quarter;
            case "MONTH":
                return startDate.format(DateTimeFormatter.ofPattern("yyyy-MM"));
            case "DAY":
                return startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            case "CUSTOM":
                // 自定义时间范围，格式：开始日期~结束日期
                return startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) +
                       "~" +
                       endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            default:
                throw new BusinessException("不支持的时间维度：" + timeDimension);
        }
    }

    /**
     * 拆分时间范围
     * 例如：2025-01-01 到 2025-03-31，按月拆分为3个时间段
     */
    private List<Map<String, LocalDate>> splitTimeRanges(String timeDimension, LocalDate startDate, LocalDate endDate) {
        List<Map<String, LocalDate>> ranges = new ArrayList<>();
        LocalDate current = startDate;

        while (!current.isAfter(endDate)) {
            Map<String, LocalDate> range = new HashMap<>();
            range.put("start", current);

            LocalDate rangeEnd;
            switch (timeDimension) {
                case "YEAR":
                    rangeEnd = current.with(TemporalAdjusters.lastDayOfYear());
                    break;
                case "QUARTER":
                    int month = current.getMonthValue();
                    int quarterEndMonth = ((month - 1) / 3 + 1) * 3;
                    rangeEnd = current.withMonth(quarterEndMonth).with(TemporalAdjusters.lastDayOfMonth());
                    break;
                case "MONTH":
                    rangeEnd = current.with(TemporalAdjusters.lastDayOfMonth());
                    break;
                case "DAY":
                    rangeEnd = current;
                    break;
                default:
                    throw new BusinessException("不支持的时间维度：" + timeDimension);
            }

            // 不超过结束日期
            if (rangeEnd.isAfter(endDate)) {
                rangeEnd = endDate;
            }

            range.put("end", rangeEnd);
            ranges.add(range);

            // 移动到下一个周期
            current = rangeEnd.plusDays(1);
        }

        return ranges;
    }

    /**
     * 保存或更新计算结果
     */
    private IndicatorResult saveOrUpdateResult(String metricCode, String timeDimension, String timeValue,
                                                LocalDate startDate, LocalDate endDate,
                                                BigDecimal resultValue, String resultJson) {
        // 查询是否已存在
        LambdaQueryWrapper<IndicatorResult> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(IndicatorResult::getMetricCode, metricCode);
        wrapper.eq(IndicatorResult::getTimeDimension, timeDimension);
        wrapper.eq(IndicatorResult::getTimeValue, timeValue);
        IndicatorResult existingResult = indicatorResultMapper.selectOne(wrapper);

        IndicatorResult result;
        if (existingResult != null) {
            // 更新
            result = existingResult;
            result.setResultValue(resultValue);
            result.setResultJson(resultJson);
            result.setCalculationStatus("SUCCESS");
            result.setErrorMessage(null);
            indicatorResultMapper.updateById(result);
        } else {
            // 新增
            result = new IndicatorResult();
            result.setMetricCode(metricCode);
            result.setTimeDimension(timeDimension);
            result.setTimeValue(timeValue);
            result.setStartDate(startDate);
            result.setEndDate(endDate);
            result.setResultValue(resultValue);
            result.setResultJson(resultJson);
            result.setCalculationStatus("SUCCESS");
            indicatorResultMapper.insert(result);
        }

        return result;
    }

    /**
     * 保存失败记录
     */
    private IndicatorResult saveFailedResult(String metricCode, String timeDimension, String timeValue,
                                             LocalDate startDate, LocalDate endDate, String errorMessage) {
        IndicatorResult result = new IndicatorResult();
        result.setMetricCode(metricCode);
        result.setTimeDimension(timeDimension);
        result.setTimeValue(timeValue);
        result.setStartDate(startDate);
        result.setEndDate(endDate);
        result.setCalculationStatus("FAILED");
        result.setErrorMessage(errorMessage);
        indicatorResultMapper.insert(result);
        return result;
    }

    /**
     * 查询按科室分组的指标项数据
     * 该方法会执行每个指标项配置的SQL，并按B16字段分组
     *
     * @param itemCodes 指标项编码列表
     * @param startDate 开始日期
     * @param endDate   结束日期
     * @return Map<科室Key, Map<指标项编码, 值>>，科室Key格式为"deptCode|deptName"
     */
    private Map<String, Map<String, BigDecimal>> queryDeptItemValues(List<String> itemCodes, LocalDate startDate, LocalDate endDate) {
        // 使用LinkedHashMap保持顺序
        Map<String, Map<String, BigDecimal>> deptMap = new LinkedHashMap<>();

        for (String itemCode : itemCodes) {
            try {
                // 1. 查询指标项配置
                LambdaQueryWrapper<IndicatorItem> wrapper = new LambdaQueryWrapper<>();
                wrapper.eq(IndicatorItem::getItemCode, itemCode);
                IndicatorItem item = indicatorItemMapper.selectOne(wrapper);

                if (item == null) {
                    throw new BusinessException("指标项不存在：" + itemCode);
                }
                if (item.getStatus() != 1) {
                    throw new BusinessException("指标项已禁用：" + itemCode);
                }
                if (StringUtils.isBlank(item.getQuerySql())) {
                    throw new BusinessException("指标项未配置SQL：" + itemCode);
                }

                // 2. 修改SQL，添加GROUP BY B16
                String originalSql = item.getQuerySql();
                String deptSql = modifySqlForDeptDrill(originalSql);

                // 3. 替换SQL参数
                String sql = replaceSqlParams(deptSql, startDate, endDate);
                log.debug("执行科室下钻SQL [{}]: {}", itemCode, sql);

                // 4. 执行SQL查询
                List<Map<String, Object>> rows = indicatorItemMapper.executeDynamicQuery(sql);

                // 5. 解析查询结果
                for (Map<String, Object> row : rows) {
                    // 获取科室编码和科室名称
                    String deptCode = getStringValue(row.get("dept_code"));
                    String deptName = getStringValue(row.get("dept_name"));
                    Object valueObj = row.get("result_value");

                    // 跳过空科室
                    if (StringUtils.isBlank(deptCode)) {
                        continue;
                    }

                    // 构建科室Key
                    String deptKey = deptCode + "|" + (StringUtils.isNotBlank(deptName) ? deptName : deptCode);

                    // 转换值为BigDecimal
                    BigDecimal value;
                    if (valueObj == null) {
                        value = BigDecimal.ZERO;
                    } else if (valueObj instanceof BigDecimal) {
                        value = (BigDecimal) valueObj;
                    } else if (valueObj instanceof Number) {
                        value = new BigDecimal(valueObj.toString());
                    } else {
                        value = new BigDecimal(valueObj.toString());
                    }

                    // 添加到结果Map，并确保该科室有所有指标项的Map
                    Map<String, BigDecimal> itemMap = deptMap.computeIfAbsent(deptKey, k -> new HashMap<>());
                    itemMap.put(itemCode, value);
                }

            } catch (Exception e) {
                log.error("查询科室下钻数据失败: itemCode={}, error={}", itemCode, e.getMessage(), e);
                throw new BusinessException("查询科室下钻数据失败：" + itemCode + ", " + e.getMessage());
            }
        }

        // 6. 确保所有科室都有所有指标项的值（没有的填充为0）
        for (Map<String, BigDecimal> itemMap : deptMap.values()) {
            for (String itemCode : itemCodes) {
                itemMap.putIfAbsent(itemCode, BigDecimal.ZERO);
            }
        }

        return deptMap;
    }

    /**
     * 修改SQL以支持科室下钻
     * 添加B16字段到SELECT和GROUP BY
     */
    private String modifySqlForDeptDrill(String originalSql) {
        // 移除末尾的分号
        String sql = originalSql.trim();
        if (sql.endsWith(";")) {
            sql = sql.substring(0, sql.length() - 1).trim();
        }

        // 在SELECT子句中添加B16（假设B16是出院科室字段）
        // 原SQL格式: SELECT COUNT(*) as value FROM ...
        // 修改为: SELECT B16 as dept_code, B16 as dept_name, COUNT(*) as value FROM ... GROUP BY B16

        // 查找SELECT和FROM的位置
        int selectIndex = sql.toUpperCase().indexOf("SELECT");
        int fromIndex = sql.toUpperCase().indexOf("FROM");

        if (selectIndex == -1 || fromIndex == -1) {
            throw new BusinessException("SQL格式不正确，无法添加科室分组");
        }

        // 构建新的SELECT子句
        String selectPart = "SELECT B16 as dept_code, B16 as dept_name, ";
        String valuePart = sql.substring(selectIndex + 6, fromIndex).trim();
        String fromPart = sql.substring(fromIndex);

        // 统一将聚合值别名改为 result_value，供后续 row.get("result_value") 读取
        String valueWithAlias;
        if (valuePart.toLowerCase().matches(".*\\bas\\b.*")) {
            // 将原有别名替换为 result_value
            valueWithAlias = valuePart.replaceAll("(?i)\\bas\\s+\\w+\\s*$", "as result_value");
        } else {
            valueWithAlias = valuePart + " as result_value";
        }

        // 添加GROUP BY B16
        String newSql = selectPart + valueWithAlias + " " + fromPart + " GROUP BY B16";

        return newSql;
    }

    /**
     * 获取字符串值
     */
    private String getStringValue(Object obj) {
        if (obj == null) {
            return "";
        }
        return obj.toString().trim();
    }

    /**
     * 保存或更新科室下钻结果
     */
    private IndicatorResultDept saveOrUpdateDeptResult(String metricCode, String timeDimension, String timeValue,
                                                        String deptCode, String deptName, BigDecimal resultValue, String resultJson) {
        // 查询是否已存在
        LambdaQueryWrapper<IndicatorResultDept> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(IndicatorResultDept::getMetricCode, metricCode);
        wrapper.eq(IndicatorResultDept::getTimeDimension, timeDimension);
        wrapper.eq(IndicatorResultDept::getTimeValue, timeValue);
        wrapper.eq(IndicatorResultDept::getDeptCode, deptCode);
        IndicatorResultDept existingResult = indicatorResultDeptMapper.selectOne(wrapper);

        IndicatorResultDept result;
        if (existingResult != null) {
            // 更新
            result = existingResult;
            result.setDeptName(deptName);
            result.setResultValue(resultValue);
            result.setResultJson(resultJson);
            indicatorResultDeptMapper.updateById(result);
        } else {
            // 新增
            result = new IndicatorResultDept();
            result.setMetricCode(metricCode);
            result.setTimeDimension(timeDimension);
            result.setTimeValue(timeValue);
            result.setDeptCode(deptCode);
            result.setDeptName(deptName);
            result.setResultValue(resultValue);
            result.setResultJson(resultJson);
            indicatorResultDeptMapper.insert(result);
        }

        return result;
    }

}
