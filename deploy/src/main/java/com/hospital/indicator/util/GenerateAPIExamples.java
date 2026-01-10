package com.hospital.indicator.util;

import java.sql.*;
import java.util.*;

/**
 * 生成手术类指标接口访问范例
 */
public class GenerateAPIExamples {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            System.out.println("# 手术类计算指标接口访问范例\n");

            // 查找这9个指标
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

            Map<String, Map<String, String>> indicators = new LinkedHashMap<>();

            for (String name : indicatorNames) {
                String sql = "SELECT metric_code, metric_name, expression, unit FROM t_indicator WHERE metric_name = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    String code = rs.getString("metric_code");
                    String expr = rs.getString("expression");
                    String unit = rs.getString("unit");

                    Map<String, String> info = new HashMap<>();
                    info.put("name", name);
                    info.put("expression", expr);
                    info.put("unit", unit);
                    indicators.put(code, info);
                }
                rs.close();
                pstmt.close();
            }

            // 生成接口范例
            generateExamples(conn, indicators, "髋关节置换术");
            generateExamples(conn, indicators, "膝关节置换术");
            generateExamples(conn, indicators, "冠状动脉旁路移植术");

            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void generateExamples(Connection conn, Map<String, Map<String, String>> indicators, String category) throws Exception {
        System.out.println("\n## " + category + "相关指标\n");

        for (Map.Entry<String, Map<String, String>> entry : indicators.entrySet()) {
            String code = entry.getKey();
            String name = entry.getValue().get("name");
            String expr = entry.getValue().get("expression");
            String unit = entry.getValue().get("unit");

            if (!name.contains(category)) continue;

            System.out.println("### " + name + "\n");
            System.out.println("**指标编码**: " + code);
            System.out.println("**计算公式**: " + expr);
            System.out.println("**单位**: " + unit + "\n");

            // 提取指标项
            List<String> itemCodes = extractItemCodes(expr);

            // 2020年数据
            System.out.println("#### 2020年数据（有数据）\n");

            Map<String, Double> itemValues2020 = queryItemValues(conn, itemCodes, "2020-01-01", "2020-12-31");
            Double result2020 = calculateExpression(expr, itemValues2020);

            System.out.println("来源指标项:");
            for (String itemCode : itemCodes) {
                Double val = itemValues2020.get(itemCode);
                System.out.println("- " + itemCode + ": " + (val != null ? val : 0.0));
            }

            if (result2020 != null) {
                System.out.println("\n计算结果: " + String.format("%.4f", result2020) + " " + unit);
            } else {
                System.out.println("\n计算结果: 无法计算（分母为0）");
            }

            // 2023年数据
            System.out.println("\n#### 2023年数据（无数据）\n");

            Map<String, Double> itemValues2023 = queryItemValues(conn, itemCodes, "2023-01-01", "2023-12-31");
            Double result2023 = calculateExpression(expr, itemValues2023);

            System.out.println("来源指标项:");
            for (String itemCode : itemCodes) {
                Double val = itemValues2023.get(itemCode);
                System.out.println("- " + itemCode + ": " + (val != null ? val : 0.0));
            }

            if (result2023 != null) {
                System.out.println("\n计算结果: " + String.format("%.4f", result2023) + " " + unit);
            } else {
                System.out.println("\n计算结果: 无法计算（分母为0）");
                System.out.println("说明: 该时间段内无相关病例");
            }

            System.out.println("\n---\n");
        }
    }

    private static Map<String, Double> queryItemValues(Connection conn, List<String> itemCodes, String startDate, String endDate) throws Exception {
        Map<String, Double> values = new HashMap<>();

        for (String itemCode : itemCodes) {
            String itemSql = "SELECT query_sql FROM t_indicator_item WHERE item_code = ?";
            PreparedStatement itemPstmt = conn.prepareStatement(itemSql);
            itemPstmt.setString(1, itemCode);
            ResultSet itemRs = itemPstmt.executeQuery();

            if (itemRs.next()) {
                String querySql = itemRs.getString("query_sql");
                String testSql = querySql.replace("#{startDate}", "'" + startDate + "'")
                                        .replace("#{endDate}", "'" + endDate + "'");

                Statement testStmt = conn.createStatement();
                ResultSet testRs = testStmt.executeQuery(testSql);
                if (testRs.next()) {
                    double value = testRs.getDouble("result_value");
                    values.put(itemCode, value);
                }
                testRs.close();
                testStmt.close();
            }
            itemRs.close();
            itemPstmt.close();
        }

        return values;
    }

    private static List<String> extractItemCodes(String expression) {
        List<String> codes = new ArrayList<>();
        if (expression == null) return codes;

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
            String[] parts = expr.split("/");
            if (parts.length == 2) {
                String numerator = parts[0].trim();
                String denominator = parts[1].trim();

                Double num = values.get(numerator);
                Double den = values.get(denominator);

                if (num != null && den != null) {
                    if (den == 0) {
                        return null;
                    }
                    return num / den;
                }
            }
        } catch (Exception e) {
            // ignore
        }

        return null;
    }
}
