package com.hospital.indicator.util;

import java.sql.*;
import java.util.*;

/**
 * 测试所有48个指标项的查询结果 (2023年)
 */
public class TestAllIndicatorItems2023 {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("测试所有指标项 (2023年)");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            // 获取所有指标项
            List<Map<String, String>> items = new ArrayList<>();
            ResultSet rs = stmt.executeQuery(
                "SELECT item_code, item_name, query_sql, unit FROM t_indicator_item ORDER BY sort_order"
            );

            while (rs.next()) {
                Map<String, String> item = new HashMap<>();
                item.put("code", rs.getString("item_code"));
                item.put("name", rs.getString("item_name"));
                item.put("sql", rs.getString("query_sql"));
                item.put("unit", rs.getString("unit"));
                items.add(item);
            }
            rs.close();

            System.out.println("总指标项数: " + items.size() + "\n");

            int successCount = 0;
            int zeroCount = 0;
            int failCount = 0;

            // 测试每个指标项
            for (Map<String, String> item : items) {
                String code = item.get("code");
                String name = item.get("name");
                String sql = item.get("sql");
                String unit = item.get("unit");

                // 替换参数
                String testSql = sql.replace("#{startDate}", "'2023-01-01'")
                                   .replace("#{endDate}", "'2023-12-31'");

                try {
                    Statement testStmt = conn.createStatement();
                    ResultSet testRs = testStmt.executeQuery(testSql);

                    if (testRs.next()) {
                        Object result = testRs.getObject("result_value");
                        double value = result != null ? Double.parseDouble(result.toString()) : 0;

                        if (value > 0) {
                            System.out.println(String.format("✓ %-15s %-40s %12.2f %s",
                                code, name, value, unit != null ? unit : ""));
                            successCount++;
                        } else {
                            System.out.println(String.format("○ %-15s %-40s %12s",
                                code, name, "0 (无数据)"));
                            zeroCount++;
                        }
                    }

                    testRs.close();
                    testStmt.close();

                } catch (Exception e) {
                    System.out.println(String.format("✗ %-15s %-40s 失败: %s",
                        code, name, e.getMessage()));
                    failCount++;
                }
            }

            // 统计
            System.out.println("\n========================================");
            System.out.println("测试统计");
            System.out.println("========================================");
            System.out.println("总指标项数:   " + items.size());
            System.out.println("✓ 有数据:     " + successCount + " 个");
            System.out.println("○ 无数据:     " + zeroCount + " 个 (正常)");
            System.out.println("✗ 查询失败:   " + failCount + " 个");

            double successRate = (double)(successCount + zeroCount) / items.size() * 100;
            System.out.println(String.format("\n查询成功率:   %.1f%%", successRate));

            if (failCount > 0) {
                System.out.println("\n⚠️  有 " + failCount + " 个指标项查询失败，需要检查SQL！");
            } else {
                System.out.println("\n✓ 所有指标项SQL正确，查询全部成功！");
            }

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
