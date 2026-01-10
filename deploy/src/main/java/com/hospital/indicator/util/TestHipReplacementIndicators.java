package com.hospital.indicator.util;

import java.sql.*;

/**
 * 测试髋关节置换术相关指标项
 */
public class TestHipReplacementIndicators {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("髋关节置换术指标项测试 (2023年)");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            // 1. 查找髋关节置换术相关的指标项
            System.out.println("【1. 髋关节置换术相关指标项】\n");
            
            String querySql = "SELECT item_code, item_name, unit, query_sql " +
                            "FROM t_indicator_item " +
                            "WHERE item_name LIKE '%髋关节%' " +
                            "ORDER BY item_code";
            
            ResultSet rs = stmt.executeQuery(querySql);
            
            int count = 0;
            while (rs.next()) {
                count++;
                String itemCode = rs.getString("item_code");
                String itemName = rs.getString("item_name");
                String unit = rs.getString("unit");
                String sql = rs.getString("query_sql");
                
                System.out.println(count + ". " + itemCode + ": " + itemName + " (" + unit + ")");
                
                // 显示SQL片段（手术编码部分）
                if (sql.contains("OP")) {
                    int idx = sql.indexOf("OP");
                    String snippet = sql.substring(Math.max(0, idx - 30), Math.min(sql.length(), idx + 100));
                    System.out.println("   手术编码条件: ..." + snippet + "...");
                }
                System.out.println();
            }
            rs.close();
            
            System.out.println("共找到 " + count + " 个髋关节置换术相关指标项\n");
            
            // 2. 检查2023年是否有髋关节置换术的病例
            System.out.println("【2. 检查2023年髋关节置换术病例】\n");
            
            String checkSql = "SELECT COUNT(*) as cnt " +
                            "FROM d_mr " +
                            "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                            "  AND (OP01C LIKE '81.51%' OR OP02C LIKE '81.51%' OR OP03C LIKE '81.51%' " +
                            "    OR OP04C LIKE '81.51%' OR OP05C LIKE '81.51%' OR OP06C LIKE '81.51%')";
            
            rs = stmt.executeQuery(checkSql);
            if (rs.next()) {
                int caseCount = rs.getInt("cnt");
                System.out.println("髋关节置换术病例数: " + caseCount + " 例");
                
                if (caseCount > 0) {
                    System.out.println("\n具体病例信息:");
                    String detailSql = "SELECT A48, A49, B15, OP01C, OP02C, OP03C, D01, E01 " +
                                     "FROM d_mr " +
                                     "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                                     "  AND (OP01C LIKE '81.51%' OR OP02C LIKE '81.51%' OR OP03C LIKE '81.51%' " +
                                     "    OR OP04C LIKE '81.51%' OR OP05C LIKE '81.51%' OR OP06C LIKE '81.51%') " +
                                     "LIMIT 5";
                    ResultSet detailRs = stmt.executeQuery(detailSql);
                    while (detailRs.next()) {
                        System.out.println("  病案号: " + detailRs.getString("A48") + "-" + detailRs.getString("A49"));
                        System.out.println("  出院日期: " + detailRs.getString("B15"));
                        System.out.println("  手术编码: " + detailRs.getString("OP01C"));
                        System.out.println("  总费用: " + detailRs.getDouble("D01") + " 元");
                        System.out.println("  住院天数: " + detailRs.getInt("E01") + " 天");
                        System.out.println();
                    }
                    detailRs.close();
                } else {
                    System.out.println("✓ 2023年无髋关节置换术病例，指标返回0是正常现象");
                }
            }
            rs.close();
            
            // 3. 测试所有髋关节置换术指标项
            System.out.println("\n【3. 测试所有髋关节置换术指标项 (2023年)】\n");
            
            querySql = "SELECT item_code, item_name, unit, query_sql " +
                      "FROM t_indicator_item " +
                      "WHERE item_name LIKE '%髋关节%' " +
                      "ORDER BY item_code";
            
            rs = stmt.executeQuery(querySql);
            
            int successCount = 0;
            int failCount = 0;
            
            while (rs.next()) {
                String itemCode = rs.getString("item_code");
                String itemName = rs.getString("item_name");
                String unit = rs.getString("unit");
                String sql = rs.getString("query_sql");
                
                String testSql = sql.replace("#{startDate}", "'2023-01-01'")
                                   .replace("#{endDate}", "'2023-12-31'");
                
                System.out.println(itemCode + " - " + itemName + ":");
                
                try {
                    Statement testStmt = conn.createStatement();
                    ResultSet testRs = testStmt.executeQuery(testSql);
                    if (testRs.next()) {
                        Object result = testRs.getObject("result_value");
                        String value = result != null ? result.toString() : "NULL";
                        System.out.println("  ✓ 结果: " + value + " " + unit);
                        successCount++;
                    }
                    testRs.close();
                    testStmt.close();
                } catch (Exception e) {
                    System.out.println("  ✗ 查询失败: " + e.getMessage());
                    failCount++;
                }
                System.out.println();
            }
            rs.close();
            
            // 4. 统计结果
            System.out.println("========================================");
            System.out.println("测试结果统计");
            System.out.println("========================================");
            System.out.println("✓ 查询成功: " + successCount + " 个");
            System.out.println("✗ 查询失败: " + failCount + " 个");
            System.out.println("成功率: " + String.format("%.1f", successCount * 100.0 / (successCount + failCount)) + "%");
            
            stmt.close();
            conn.close();
            System.out.println("\n测试完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
