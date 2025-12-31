package com.hospital.indicator.util;

import java.sql.*;

/**
 * 测试所有手术类指标项修复后的2023年数据
 */
public class TestAllSurgeryIndicators2023 {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("测试所有手术类指标项 (2023年)");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");
            
            String[][] indicators = {
                {"a0027", "手术患者并发症发生例数", "人"},
                {"a0077", "髋关节置换术病种例数", "人"},
                {"a0079", "髋关节置换术出院患者占用总床日数", "床日"},
                {"a0082", "髋关节置换术总出院费用", "元"},
                {"a0085", "髋关节置换术死亡人数", "人"},
                {"a0086", "膝关节置换术病种例数", "人"},
                {"a0088", "膝关节置换术出院患者占用总床日数", "床日"},
                {"a0091", "膝关节置换术总出院费用", "元"},
                {"a0094", "膝关节置换术死亡人数", "人"},
                {"a0095", "冠状动脉旁路移植术病种例数", "人"},
                {"a0097", "冠状动脉旁路移植术出院患者占用总床日数", "床日"},
                {"a0100", "冠状动脉旁路移植术总出院费用", "元"},
                {"a0103", "冠状动脉旁路移植术死亡人数", "人"},
                {"a0104", "剖宫产病种例数", "人"},
                {"a0106", "剖宫产出院患者占用总床日数", "床日"},
                {"a0109", "剖宫产总出院费用", "元"},
                {"a0112", "剖宫产死亡人数", "人"}
            };
            
            int successCount = 0;
            int failCount = 0;
            
            System.out.println("【测试结果】\n");
            
            for (String[] indicator : indicators) {
                String itemCode = indicator[0];
                String itemName = indicator[1];
                String unit = indicator[2];
                
                String sql = "SELECT query_sql FROM t_indicator_item WHERE item_code = '" + itemCode + "'";
                ResultSet rs = stmt.executeQuery(sql);
                
                if (rs.next()) {
                    String querySql = rs.getString("query_sql");
                    String testSql = querySql.replace("#{startDate}", "'2023-01-01'")
                                            .replace("#{endDate}", "'2023-12-31'");
                    
                    try {
                        Statement testStmt = conn.createStatement();
                        ResultSet testRs = testStmt.executeQuery(testSql);
                        if (testRs.next()) {
                            Object result = testRs.getObject("result_value");
                            String value = result != null ? result.toString() : "NULL";
                            System.out.println("✓ " + itemCode + " - " + itemName + ": " + value + " " + unit);
                            successCount++;
                        }
                        testRs.close();
                        testStmt.close();
                    } catch (Exception e) {
                        System.out.println("✗ " + itemCode + " - " + itemName + ": 查询失败 - " + e.getMessage());
                        failCount++;
                    }
                } else {
                    System.out.println("✗ " + itemCode + " - 未找到配置");
                    failCount++;
                }
                rs.close();
            }
            
            System.out.println("\n========================================");
            System.out.println("测试统计");
            System.out.println("========================================");
            System.out.println("总指标项: " + indicators.length);
            System.out.println("✓ 查询成功: " + successCount);
            System.out.println("✗ 查询失败: " + failCount);
            System.out.println("成功率: " + String.format("%.1f%%", successCount * 100.0 / indicators.length));
            
            // 检查修复后的SQL是否正确
            System.out.println("\n【检查修复后的SQL字段】\n");
            
            boolean allUseSurgeryField = true;
            for (String[] indicator : indicators) {
                String itemCode = indicator[0];
                String sql = "SELECT query_sql FROM t_indicator_item WHERE item_code = '" + itemCode + "'";
                ResultSet rs = stmt.executeQuery(sql);
                
                if (rs.next()) {
                    String querySql = rs.getString("query_sql");
                    boolean usesC14x01C = querySql.contains("C14x01C");
                    boolean stillUsesC03C = querySql.contains("C03C");
                    boolean stillUsesC06x = querySql.contains("C06x");
                    
                    if (!usesC14x01C || stillUsesC03C || stillUsesC06x) {
                        System.out.println("⚠ " + itemCode + " - SQL字段可能有问题");
                        allUseSurgeryField = false;
                    }
                }
                rs.close();
            }
            
            if (allUseSurgeryField) {
                System.out.println("✓ 所有指标项都已使用正确的手术字段 C14x01C");
            }

            stmt.close();
            conn.close();
            
            System.out.println("\n测试完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
