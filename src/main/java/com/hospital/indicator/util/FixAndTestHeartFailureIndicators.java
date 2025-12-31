package com.hospital.indicator.util;

import java.sql.*;

/**
 * 修复心力衰竭指标项的ICD编码并测试
 */
public class FixAndTestHeartFailureIndicators {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("修复并测试心力衰竭指标项");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            // 1. 修复ICD编码匹配
            System.out.println("【1. 修复ICD编码匹配】");
            System.out.println("将 C03C = 'I50' 改为 C03C LIKE 'I50%'");
            System.out.println("将 C06x01C = 'I50' 改为 C06x01C LIKE 'I50%'\n");

            int updateCount = stmt.executeUpdate(
                "UPDATE t_indicator_item " +
                "SET query_sql = REPLACE(" +
                "    REPLACE(query_sql, \"C03C = 'I50'\", \"C03C LIKE 'I50%'\"), " +
                "    \"C06x01C = 'I50'\", \"C06x01C LIKE 'I50%'\" " +
                ") " +
                "WHERE item_code IN ('a0041', 'a0043', 'a0046', 'a0049')"
            );

            System.out.println("✓ 更新了 " + updateCount + " 个指标项\n");

            // 2. 显示修复后的SQL
            System.out.println("【2. 修复后的指标项SQL】");
            String[] itemCodes = {"a0041", "a0043", "a0046", "a0049"};
            String[] expectedNames = {
                "心力衰竭病种例数",
                "心力衰竭出院患者占用总床日数",
                "心力衰竭出院患者总费用",
                "心力衰竭死亡人数"
            };

            for (int i = 0; i < itemCodes.length; i++) {
                ResultSet rs = stmt.executeQuery(
                    "SELECT item_name, query_sql FROM t_indicator_item WHERE item_code = '" + itemCodes[i] + "'"
                );
                if (rs.next()) {
                    System.out.println("\n" + (i + 1) + ". " + itemCodes[i] + ": " + rs.getString("item_name"));
                    String sql = rs.getString("query_sql");
                    // 只显示ICD相关部分
                    int idx = sql.indexOf("I50");
                    if (idx > 0) {
                        System.out.println("   ICD匹配: ..." + sql.substring(Math.max(0, idx - 20), Math.min(sql.length(), idx + 40)) + "...");
                    }
                }
                rs.close();
            }

            // 3. 测试所有心力衰竭指标项（2023年）
            System.out.println("\n\n【3. 测试所有心力衰竭指标项 (2023年)】");

            for (int i = 0; i < itemCodes.length; i++) {
                ResultSet rs = stmt.executeQuery(
                    "SELECT query_sql FROM t_indicator_item WHERE item_code = '" + itemCodes[i] + "'"
                );

                if (rs.next()) {
                    String querySql = rs.getString("query_sql");
                    String testSql = querySql.replace("#{startDate}", "'2023-01-01'")
                                             .replace("#{endDate}", "'2023-12-31'");

                    System.out.println("\n" + itemCodes[i] + " - " + expectedNames[i] + ":");

                    try {
                        ResultSet testRs = stmt.executeQuery(testSql);
                        if (testRs.next()) {
                            Object result = testRs.getObject("result_value");
                            String value = result != null ? result.toString() : "NULL";
                            System.out.println("  ✓ 结果: " + value +
                                (itemCodes[i].equals("a0041") ? " 人" :
                                 itemCodes[i].equals("a0043") ? " 床日" :
                                 itemCodes[i].equals("a0046") ? " 元" : " 人"));
                        }
                        testRs.close();
                    } catch (Exception e) {
                        System.out.println("  ✗ 查询失败: " + e.getMessage());
                    }
                }
                rs.close();
            }

            // 4. 计算心力衰竭次均费用
            System.out.println("\n\n【4. 计算心力衰竭次均费用】");
            ResultSet a0041Rs = stmt.executeQuery(
                "SELECT query_sql FROM t_indicator_item WHERE item_code = 'a0041'"
            );
            ResultSet a0046Rs = stmt.executeQuery(
                "SELECT query_sql FROM t_indicator_item WHERE item_code = 'a0046'"
            );

            if (a0041Rs.next() && a0046Rs.next()) {
                String a0041Sql = a0041Rs.getString("query_sql")
                    .replace("#{startDate}", "'2023-01-01'")
                    .replace("#{endDate}", "'2023-12-31'");

                String a0046Sql = a0046Rs.getString("query_sql")
                    .replace("#{startDate}", "'2023-01-01'")
                    .replace("#{endDate}", "'2023-12-31'");

                ResultSet a0041Result = stmt.executeQuery(a0041Sql);
                ResultSet a0046Result = stmt.executeQuery(a0046Sql);

                if (a0041Result.next() && a0046Result.next()) {
                    double count = a0041Result.getDouble("result_value");
                    double totalCost = a0046Result.getDouble("result_value");

                    System.out.println("a0041 (病种例数): " + count + " 人");
                    System.out.println("a0046 (总费用): " + totalCost + " 元");

                    if (count > 0) {
                        double avgCost = totalCost / count;
                        System.out.println("\n✓ 心力衰竭次均费用 = " + String.format("%.2f", avgCost) + " 元/人");
                    } else {
                        System.out.println("\n⚠ 无法计算: 病例数为0");
                    }
                }
                a0041Result.close();
                a0046Result.close();
            }
            a0041Rs.close();
            a0046Rs.close();

            stmt.close();
            conn.close();
            System.out.println("\n\n修复和测试完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
