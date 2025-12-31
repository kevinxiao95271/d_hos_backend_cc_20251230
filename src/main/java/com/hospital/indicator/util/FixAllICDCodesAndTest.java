package com.hospital.indicator.util;

import java.sql.*;

/**
 * 修复所有ICD编码精确匹配问题并测试所有指标项
 */
public class FixAllICDCodesAndTest {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("修复所有ICD编码并测试所有指标项");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            // 修复所有J开头的ICD编码
            String[] jCodes = {"J12", "J13", "J14", "J15", "J16", "J17", "J18"};

            System.out.println("【1. 修复肺炎相关ICD编码】");
            int totalUpdated = 0;

            for (String code : jCodes) {
                // C03C
                int count1 = stmt.executeUpdate(
                    "UPDATE t_indicator_item " +
                    "SET query_sql = REPLACE(query_sql, \"C03C = '" + code + "'\", \"C03C LIKE '" + code + "%'\") " +
                    "WHERE query_sql LIKE \"%C03C = '" + code + "'%\""
                );

                // C06x01C
                int count2 = stmt.executeUpdate(
                    "UPDATE t_indicator_item " +
                    "SET query_sql = REPLACE(query_sql, \"C06x01C = '" + code + "'\", \"C06x01C LIKE '" + code + "%'\") " +
                    "WHERE query_sql LIKE \"%C06x01C = '" + code + "'%\""
                );

                if (count1 > 0 || count2 > 0) {
                    System.out.println("  " + code + ": 更新了 " + (count1 + count2) + " 个字段");
                    totalUpdated += (count1 + count2);
                }
            }

            System.out.println("\n✓ 总计更新了 " + totalUpdated + " 个字段\n");

            // 测试所有48个指标项
            System.out.println("【2. 测试所有指标项 (2023年)】\n");

            ResultSet rs = stmt.executeQuery(
                "SELECT item_code, item_name FROM t_indicator_item ORDER BY sort_order"
            );

            int successCount = 0;
            int failCount = 0;
            int zeroCount = 0;

            while (rs.next()) {
                String itemCode = rs.getString("item_code");
                String itemName = rs.getString("item_name");

                // 获取SQL
                ResultSet sqlRs = stmt.executeQuery(
                    "SELECT query_sql FROM t_indicator_item WHERE item_code = '" + itemCode + "'"
                );

                if (sqlRs.next()) {
                    String querySql = sqlRs.getString("query_sql");
                    String testSql = querySql.replace("#{startDate}", "'2023-01-01'")
                                             .replace("#{endDate}", "'2023-12-31'");

                    try {
                        ResultSet testRs = stmt.executeQuery(testSql);
                        if (testRs.next()) {
                            Object result = testRs.getObject("result_value");
                            double value = result != null ? Double.parseDouble(result.toString()) : 0;

                            if (value > 0) {
                                System.out.println("✓ " + itemCode + " (" + itemName + "): " + value);
                                successCount++;
                            } else {
                                System.out.println("○ " + itemCode + " (" + itemName + "): 0 (无数据)");
                                zeroCount++;
                            }
                        }
                        testRs.close();
                    } catch (Exception e) {
                        System.out.println("✗ " + itemCode + " (" + itemName + "): 查询失败 - " + e.getMessage());
                        failCount++;
                    }
                }
                sqlRs.close();
            }
            rs.close();

            // 统计
            System.out.println("\n========================================");
            System.out.println("【测试统计】");
            System.out.println("========================================");
            System.out.println("总指标项数: " + (successCount + failCount + zeroCount));
            System.out.println("✓ 有数据: " + successCount + " 个");
            System.out.println("○ 无数据(正常): " + zeroCount + " 个");
            System.out.println("✗ 查询失败: " + failCount + " 个");

            if (failCount > 0) {
                System.out.println("\n⚠️  有 " + failCount + " 个指标项查询失败，需要检查！");
            } else {
                System.out.println("\n✓ 所有指标项查询正常！");
            }

            stmt.close();
            conn.close();
            System.out.println("\n修复和测试完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
