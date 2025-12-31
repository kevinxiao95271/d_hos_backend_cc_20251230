package com.hospital.indicator.util;

import java.sql.*;
import java.util.*;

/**
 * 检查并修复所有指标项的SQL问题
 * 1. B15日期格式问题
 * 2. ICD编码LIKE缺失%的问题
 */
public class CheckAndFixAllIndicatorItems {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("检查所有指标项SQL问题");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            // 1. 检查所有指标项
            System.out.println("【1. 检查所有指标项】");
            ResultSet rs = stmt.executeQuery(
                "SELECT item_code, item_name, query_sql FROM t_indicator_item ORDER BY sort_order"
            );

            List<String> needB15Fix = new ArrayList<>();
            List<String> needIcdFix = new ArrayList<>();
            Map<String, String> itemSqls = new HashMap<>();

            int totalCount = 0;
            while (rs.next()) {
                totalCount++;
                String itemCode = rs.getString("item_code");
                String itemName = rs.getString("item_name");
                String querySql = rs.getString("query_sql");
                itemSqls.put(itemCode, querySql);

                // 检查B15问题
                if (querySql.contains("DATE(B15)") || querySql.contains("DATE(d_mr.B15)")) {
                    needB15Fix.add(itemCode + " - " + itemName);
                }

                // 检查ICD编码精确匹配问题（应该用LIKE '%'）
                if (querySql.matches(".*C03C\\s*=\\s*'[IJ][0-9].*") ||
                    querySql.matches(".*C06x01C\\s*=\\s*'[IJ][0-9].*")) {
                    needIcdFix.add(itemCode + " - " + itemName);
                }
            }
            rs.close();

            System.out.println("总指标项数: " + totalCount);
            System.out.println("需要修复B15的: " + needB15Fix.size() + " 个");
            System.out.println("需要修复ICD编码的: " + needIcdFix.size() + " 个\n");

            // 2. 显示需要修复的指标项
            if (!needB15Fix.isEmpty()) {
                System.out.println("【2. 需要修复B15日期格式的指标项】");
                for (String item : needB15Fix) {
                    System.out.println("  - " + item);
                }
                System.out.println();
            }

            if (!needIcdFix.isEmpty()) {
                System.out.println("【3. 需要修复ICD编码匹配的指标项】");
                for (String item : needIcdFix) {
                    System.out.println("  - " + item);
                }
                System.out.println();
            }

            // 3. 执行修复
            System.out.println("【4. 开始执行修复】\n");

            int fixCount = 0;

            // 修复B15: DATE(B15) -> STR_TO_DATE(B15, '%Y/%m/%d')
            if (!needB15Fix.isEmpty()) {
                System.out.println("修复B15日期格式...");
                int count = stmt.executeUpdate(
                    "UPDATE t_indicator_item " +
                    "SET query_sql = REPLACE(query_sql, 'DATE(B15) BETWEEN', \"STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN\") " +
                    "WHERE query_sql LIKE '%DATE(B15) BETWEEN%'"
                );
                System.out.println("  更新了 " + count + " 条记录 (DATE(B15) BETWEEN)");
                fixCount += count;

                count = stmt.executeUpdate(
                    "UPDATE t_indicator_item " +
                    "SET query_sql = REPLACE(query_sql, 'DATE(d_mr.B15) BETWEEN', \"STR_TO_DATE(d_mr.B15, '%Y/%m/%d') BETWEEN\") " +
                    "WHERE query_sql LIKE '%DATE(d_mr.B15) BETWEEN%'"
                );
                System.out.println("  更新了 " + count + " 条记录 (DATE(d_mr.B15) BETWEEN)\n");
                fixCount += count;
            }

            // 修复ICD编码精确匹配问题
            if (!needIcdFix.isEmpty()) {
                System.out.println("修复ICD编码精确匹配问题...");

                // 获取所有需要修复的ICD编码模式
                Set<String> icdPatterns = new HashSet<>();
                for (Map.Entry<String, String> entry : itemSqls.entrySet()) {
                    String sql = entry.getValue();

                    // 查找所有 = 'I/J开头的编码'
                    java.util.regex.Pattern p = java.util.regex.Pattern.compile("(C03C|C06x01C)\\s*=\\s*'([IJ][0-9][0-9\\.]*[0-9]*)'");
                    java.util.regex.Matcher m = p.matcher(sql);
                    while (m.find()) {
                        String field = m.group(1);
                        String code = m.group(2);
                        icdPatterns.add(field + " = '" + code + "'");
                    }
                }

                System.out.println("  发现 " + icdPatterns.size() + " 个需要修复的ICD编码模式:");
                for (String pattern : icdPatterns) {
                    System.out.println("    " + pattern);

                    // 替换: C03C = 'I50' -> C03C LIKE 'I50%'
                    String newPattern = pattern.replace(" = '", " LIKE '").replace("'", "%'");
                    int count = stmt.executeUpdate(
                        "UPDATE t_indicator_item " +
                        "SET query_sql = REPLACE(query_sql, \"" + pattern + "\", \"" + newPattern + "\") " +
                        "WHERE query_sql LIKE '%" + pattern + "%'"
                    );
                    if (count > 0) {
                        System.out.println("      -> " + newPattern + " (更新了 " + count + " 条)");
                        fixCount += count;
                    }
                }
                System.out.println();
            }

            System.out.println("✓ 修复完成！总计更新了 " + fixCount + " 次\n");

            // 4. 验证修复结果
            System.out.println("【5. 验证修复结果】");
            rs = stmt.executeQuery(
                "SELECT " +
                "  COUNT(*) as total, " +
                "  SUM(CASE WHEN query_sql LIKE '%DATE(B15)%' THEN 1 ELSE 0 END) as has_date_b15, " +
                "  SUM(CASE WHEN query_sql LIKE '%STR_TO_DATE(B15%' OR query_sql LIKE '%STR_TO_DATE(d_mr.B15%' THEN 1 ELSE 0 END) as has_str_to_date, " +
                "  SUM(CASE WHEN query_sql REGEXP \"(C03C|C06x01C)\\\\s*=\\\\s*'[IJ][0-9]\" THEN 1 ELSE 0 END) as has_exact_match " +
                "FROM t_indicator_item"
            );

            if (rs.next()) {
                int total = rs.getInt("total");
                int hasDateB15 = rs.getInt("has_date_b15");
                int hasStrToDate = rs.getInt("has_str_to_date");
                int hasExactMatch = rs.getInt("has_exact_match");

                System.out.println("总指标项数: " + total);
                System.out.println("仍使用DATE(B15): " + hasDateB15 + (hasDateB15 > 0 ? " ⚠️" : " ✓"));
                System.out.println("已使用STR_TO_DATE: " + hasStrToDate + " ✓");
                System.out.println("仍使用ICD精确匹配: " + hasExactMatch + (hasExactMatch > 0 ? " ⚠️" : " ✓"));
            }
            rs.close();

            // 5. 测试几个关键指标项
            System.out.println("\n【6. 测试关键指标项 (2023年)】");
            String[] testItems = {"a0041", "a0032", "a0050", "total_patients"};
            String[] testNames = {"心力衰竭病种例数", "急性心肌梗死病种例数", "肺炎(成人)病种例数", "总患者数"};

            for (int i = 0; i < testItems.length; i++) {
                rs = stmt.executeQuery(
                    "SELECT query_sql FROM t_indicator_item WHERE item_code = '" + testItems[i] + "'"
                );

                if (rs.next()) {
                    String querySql = rs.getString("query_sql");
                    String testSql = querySql.replace("#{startDate}", "'2023-01-01'")
                                             .replace("#{endDate}", "'2023-12-31'");

                    try {
                        ResultSet testRs = stmt.executeQuery(testSql);
                        if (testRs.next()) {
                            Object result = testRs.getObject("result_value");
                            System.out.println("\n" + testItems[i] + " - " + testNames[i] + ":");
                            System.out.println("  ✓ 结果: " + (result != null ? result.toString() : "0"));
                        }
                        testRs.close();
                    } catch (Exception e) {
                        System.out.println("\n" + testItems[i] + " - " + testNames[i] + ":");
                        System.out.println("  ✗ 查询失败: " + e.getMessage());
                    }
                }
                rs.close();
            }

            stmt.close();
            conn.close();
            System.out.println("\n\n检查和修复完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
