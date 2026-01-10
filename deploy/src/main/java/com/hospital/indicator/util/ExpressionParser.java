package com.hospital.indicator.util;

import com.googlecode.aviator.AviatorEvaluator;
import com.googlecode.aviator.Expression;
import com.hospital.indicator.common.BusinessException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 表达式解析器
 * 支持四则运算、括号、聚合函数（SUM、AVG等）
 * 使用 AviatorEvaluator 进行表达式计算
 *
 * @author Claude
 * @date 2025-12-30
 */
@Slf4j
public class ExpressionParser {

    /**
     * 匹配聚合函数的正则表达式
     * 例如：SUM(a0050)、AVG(a0052)等
     */
    private static final Pattern AGGREGATE_FUNCTION_PATTERN = Pattern.compile("(SUM|AVG|MAX|MIN|COUNT)\\(([a-zA-Z0-9_]+)\\)");

    /**
     * 匹配指标项编码的正则表达式（不包含函数）
     * 例如：a0050、a0052等
     */
    private static final Pattern ITEM_CODE_PATTERN = Pattern.compile("\\b([a-zA-Z][a-zA-Z0-9_]*)\\b");

    /**
     * 解析表达式，提取所有涉及的指标项编码
     *
     * @param expression 表达式（如 "a0052/a0050" 或 "SUM(a0050)/SUM(a0052)"）
     * @return 指标项编码列表
     */
    public static List<String> extractItemCodes(String expression) {
        if (StringUtils.isBlank(expression)) {
            return Collections.emptyList();
        }

        Set<String> itemCodes = new HashSet<>();

        // 1. 先匹配聚合函数中的指标项
        Matcher aggregateMatcher = AGGREGATE_FUNCTION_PATTERN.matcher(expression);
        while (aggregateMatcher.find()) {
            String itemCode = aggregateMatcher.group(2);
            itemCodes.add(itemCode);
        }

        // 2. 移除聚合函数后，匹配剩余的指标项编码
        String withoutAggregate = AGGREGATE_FUNCTION_PATTERN.matcher(expression).replaceAll("");
        Matcher itemMatcher = ITEM_CODE_PATTERN.matcher(withoutAggregate);
        while (itemMatcher.find()) {
            String itemCode = itemMatcher.group(1);
            // 排除常见的运算符和关键字
            if (!isReservedKeyword(itemCode)) {
                itemCodes.add(itemCode);
            }
        }

        return new ArrayList<>(itemCodes);
    }

    /**
     * 计算表达式的值
     *
     * @param expression   表达式
     * @param itemValueMap 指标项编码与值的映射（key=指标项编码，value=数值）
     * @return 计算结果
     */
    public static BigDecimal calculate(String expression, Map<String, BigDecimal> itemValueMap) {
        if (StringUtils.isBlank(expression)) {
            throw new BusinessException("表达式为空");
        }

        if (itemValueMap == null || itemValueMap.isEmpty()) {
            throw new BusinessException("指标项值为空");
        }

        try {
            // 1. 处理聚合函数（目前聚合函数在指标项层面已经处理，这里只是替换为对应的值）
            String processedExpression = expression;
            Matcher aggregateMatcher = AGGREGATE_FUNCTION_PATTERN.matcher(expression);
            while (aggregateMatcher.find()) {
                String fullMatch = aggregateMatcher.group(0);  // 如 SUM(a0050)
                String itemCode = aggregateMatcher.group(2);   // 如 a0050

                BigDecimal value = itemValueMap.get(itemCode);
                if (value == null) {
                    throw new BusinessException("指标项值缺失：" + itemCode);
                }

                // 直接替换为数值
                processedExpression = processedExpression.replace(fullMatch, value.toString());
            }

            // 2. 替换普通指标项编码为数值
            for (Map.Entry<String, BigDecimal> entry : itemValueMap.entrySet()) {
                String itemCode = entry.getKey();
                BigDecimal value = entry.getValue();

                // 使用单词边界进行替换，避免误替换
                processedExpression = processedExpression.replaceAll("\\b" + itemCode + "\\b", value.toString());
            }

            // 3. 使用 AviatorEvaluator 计算表达式
            Expression compiledExpression;
            Object result;

            try {
                compiledExpression = AviatorEvaluator.compile(processedExpression);
                result = compiledExpression.execute();
            } catch (ArithmeticException e) {
                // 捕获整数除零异常（如 0/0）
                String errorMsg = e.getMessage() != null ? e.getMessage().toLowerCase() : "";
                if (errorMsg.contains("by zero") || errorMsg.contains("divide")) {
                    log.warn("整数除零情况: expression={}, error={}, 返回0", processedExpression, e.getMessage());
                    return BigDecimal.ZERO.setScale(4, RoundingMode.HALF_UP);
                }
                // 其他算术异常继续抛出
                throw e;
            } catch (Exception e) {
                // 捕获其他异常
                String errorMsg = e.getMessage() != null ? e.getMessage().toLowerCase() : "";
                if (errorMsg.contains("divide") || errorMsg.contains("zero")) {
                    log.warn("除零情况: expression={}, error={}, 返回0", processedExpression, e.getMessage());
                    return BigDecimal.ZERO.setScale(4, RoundingMode.HALF_UP);
                }
                // 其他异常继续抛出
                throw e;
            }

            // 4. 转换为 BigDecimal
            BigDecimal finalResult;
            if (result instanceof BigDecimal) {
                finalResult = (BigDecimal) result;
            } else if (result instanceof Number) {
                // 检查是否为无穷大或NaN
                double doubleValue = ((Number) result).doubleValue();
                if (Double.isInfinite(doubleValue) || Double.isNaN(doubleValue)) {
                    log.warn("表达式计算结果为无穷大或NaN: expression={}, result={}, 返回0", processedExpression, result);
                    return BigDecimal.ZERO.setScale(4, RoundingMode.HALF_UP);
                }
                finalResult = new BigDecimal(result.toString());
            } else {
                throw new BusinessException("表达式计算结果类型错误：" + result.getClass().getName());
            }

            // 5. 保留4位小数
            return finalResult.setScale(4, RoundingMode.HALF_UP);

        } catch (Exception e) {
            log.error("表达式计算失败: expression={}, itemValueMap={}, error={}", expression, itemValueMap, e.getMessage(), e);
            throw new BusinessException("表达式计算失败：" + e.getMessage());
        }
    }

    /**
     * 校验表达式的有效性
     *
     * @param expression 表达式
     * @return 是否有效
     */
    public static boolean validate(String expression) {
        if (StringUtils.isBlank(expression)) {
            return false;
        }

        try {
            // 1. 提取所有指标项编码
            List<String> itemCodes = extractItemCodes(expression);
            if (itemCodes.isEmpty()) {
                return false;
            }

            // 2. 构造测试数据（所有值设为1）
            Map<String, BigDecimal> testData = new HashMap<>();
            for (String itemCode : itemCodes) {
                testData.put(itemCode, BigDecimal.ONE);
            }

            // 3. 尝试计算表达式
            calculate(expression, testData);
            return true;

        } catch (Exception e) {
            log.error("表达式校验失败: {}", e.getMessage());
            return false;
        }
    }

    /**
     * 判断是否为保留关键字
     */
    private static boolean isReservedKeyword(String word) {
        if (word == null) {
            return false;
        }

        String upperWord = word.toUpperCase();
        return "SUM".equals(upperWord) ||
                "AVG".equals(upperWord) ||
                "MAX".equals(upperWord) ||
                "MIN".equals(upperWord) ||
                "COUNT".equals(upperWord) ||
                "AND".equals(upperWord) ||
                "OR".equals(upperWord) ||
                "NOT".equals(upperWord);
    }

}
