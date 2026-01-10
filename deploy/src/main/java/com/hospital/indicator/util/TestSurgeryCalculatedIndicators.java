package com.hospital.indicator.util;

import java.sql.*;
import java.util.*;

/**
 * 测试手术类计算指标（平均住院日、次均费用、病死率）
 */
public class TestSurgeryCalculatedIndicators {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("测试手术类计算指标");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            // 查找这几个指标
            String[] indicatorNames = {
                "髋关节置换术平均住院日",
                "髋关节置换术次均费用",
                "髋关节置换术病死率",
                "膝关节置换术平均住院日",
                "膝关节置换术次均费用",
                "膝关节置换术病死率",
                "冠状动脉旁路移植术平均住院日",
                "冠状动脉旁路移植术次均费用",
                "冠状动脉旁路移植术病死率"
            };

            // 查找这些指标的配置
            System.out.println("【查找指标配置】\n");

            Map<String, Map<String, String>> indicators = new LinkedHashMap<>();

            for (String name : indicatorNames) {
                String sql = "SELECT metric_code, metric_name, expression " +
                           "FROM t_indicator " +
                           "WHERE metric_name = ?";

                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    String code = rs.getString("metric_code");
                    String expr = rs.getString("expression");

                    Map<String, String> info = new HashMap<>();
                    info.put("name", name);
                    info.put("expression", expr);
                    indicators.put(code, info);

                    System.out.println(code + " - " + name);
                    System.out.println("  计算表达式: " + expr);
                    System.out.println();
                } else {
                    System.out.println("⚠ 未找到: " + name);
                }
                rs.close();
                pstmt.close();
            }

            System.out.println("共找到 " + indicators.size() + " 个指标\n");

            // 测试2023年和2020年的数据
            String[] years = {"2023", "2020"};

            for (String year : years) {
                System.out.println("\n========================================");
                System.out.println("测试 " + year + " 年数据");
                System.out.println("========================================\n");

                String startDate = year + "-01-01";
                String endDate = year + "-12-31";

                for (Map.Entry<String, Map<String, String>> entry : indicators.entrySet()) {
                    String code = entry.getKey();
                    String name = entry.getValue().get("name");
                    String expr = entry.getValue().get("expression");

                    System.out.println(code + " - " + name);

                    try {
                        // 解析计算表达式，提取涉及的指标项
                        List<String> itemCodes = extractItemCodes(expr);

                        if (itemCodes.isEmpty()) {
                            System.out.println("  ⚠ 无法解析计算表达式");
                            System.out.println();
                            continue;
                        }

                        // 查询每个指标项的值
                        Map<String, Double> itemValues = new HashMap<>();
                        boolean allSuccess = true;

                        for (String itemCode : itemCodes) {
                            String itemSql = "SELECT query_sql FROM t_indicator_item WHERE item_code = ?";
                            PreparedStatement itemPstmt = conn.prepareStatement(itemSql);
                            itemPstmt.setString(1, itemCode);
                            ResultSet itemRs = itemPstmt.executeQuery();

                            if (itemRs.next()) {
                                String querySql = itemRs.getString("query_sql");
                                String testSql = querySql.replace("#{startDate}", "'" + startDate + "'")
                                                        .replace("#{endDate}", "'" + endDate + "'");

                                try {
                                    Statement testStmt = conn.createStatement();
                                    ResultSet testRs = testStmt.executeQuery(testSql);
                                    if (testRs.next()) {
                                        double value = testRs.getDouble("result_value");
                                        itemValues.put(itemCode, value);
                                        System.out.println("  " + itemCode + " = " + value);
                                    }
                                    testRs.close();
                                    testStmt.close();
                                } catch (Exception e) {
                                    System.out.println("  ✗ " + itemCode + " 查询失败: " + e.getMessage());
                                    allSuccess = false;
                                }
                            }
                            itemRs.close();
                            itemPstmt.close();
                        }

                        // 计算结果
                        if (allSuccess) {
                            Double result = calculateExpression(expr, itemValues);
                            if (result != null) {
                                System.out.println("  ✓ 计算结果: " + String.format("%.4f", result));
                            } else {
                                System.out.println("  ⚠ 计算失败（可能除零）");
                            }
                        }

                    } catch (Exception e) {
                        System.out.println("  ✗ 测试失败: " + e.getMessage());
                    }

                    System.out.println();
                }
            }

            stmt.close();
            conn.close();

            System.out.println("\n测试完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }

    private static List<String> extractItemCodes(String expression) {
        List<String> codes = new ArrayList<>();
        if (expression == null) return codes;

        // 提取 a0xxx 格式的指标项编码
        String[] parts = expression.split("[^a-zA-Z0-9]");
        for (String part : parts) {
            if (part.matches("a\\d{4}")) {
                if (!codes.contains(part)) {
                    codes.add(part);
                }
            }
        }
        return codes;
    }

    private static Double calculateExpression(String expr, Map<String, Double> values) {
        if (expr == null || expr.isEmpty()) return null;

        try {
            // 简单的表达式计算（除法）
            // 格式如: a0079/a0077 或 a0082/a0077
            String[] parts = expr.split("/");
            if (parts.length == 2) {
                String numerator = parts[0].trim();
                String denominator = parts[1].trim();

                Double num = values.get(numerator);
                Double den = values.get(denominator);

                if (num != null && den != null) {
                    if (den == 0) {
                        return null; // 除零
                    }
                    return num / den;
                }
            }
        } catch (Exception e) {
            // 计算失败
        }

        return null;
    }
}
