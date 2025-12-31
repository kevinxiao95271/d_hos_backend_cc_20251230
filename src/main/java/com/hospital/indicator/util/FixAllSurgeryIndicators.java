package com.hospital.indicator.util;

import java.sql.*;
import java.util.*;

/**
 * 修复所有手术类指标项的SQL - 将诊断字段改为手术字段
 */
public class FixAllSurgeryIndicators {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("修复所有手术类指标项SQL");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");
            
            // 需要修复的指标项
            String[] itemCodes = {
                "a0027",  // 手术患者并发症
                "a0077", "a0079", "a0082", "a0085",  // 髋关节
                "a0086", "a0088", "a0091", "a0094",  // 膝关节
                "a0095", "a0097", "a0100", "a0103",  // 冠状动脉
                "a0104", "a0106", "a0109", "a0112"   // 剖宫产
            };
            
            System.out.println("【修复策略】");
            System.out.println("将所有 C03C/C06x01C/C06x02C... 等诊断字段");
            System.out.println("替换为 C14x01C 手术字段\n");
            
            int totalFixed = 0;
            
            for (String itemCode : itemCodes) {
                // 获取当前SQL
                String selectSql = "SELECT item_name, query_sql FROM t_indicator_item WHERE item_code = '" + itemCode + "'";
                ResultSet rs = stmt.executeQuery(selectSql);
                
                if (rs.next()) {
                    String itemName = rs.getString("item_name");
                    String oldSql = rs.getString("query_sql");
                    
                    System.out.println("修复 " + itemCode + " - " + itemName);
                    
                    // 替换诊断字段为手术字段
                    String newSql = oldSql;
                    
                    // 替换所有 C03C 为 C14x01C
                    newSql = newSql.replace("C03C", "C14x01C");
                    
                    // 替换所有 C06x01C, C06x02C ... C06x40C 为 C14x01C
                    for (int i = 1; i <= 40; i++) {
                        String oldField = String.format("C06x%02dC", i);
                        newSql = newSql.replace(oldField, "C14x01C");
                    }
                    
                    // 更新数据库
                    String updateSql = "UPDATE t_indicator_item SET query_sql = ? WHERE item_code = ?";
                    PreparedStatement pstmt = conn.prepareStatement(updateSql);
                    pstmt.setString(1, newSql);
                    pstmt.setString(2, itemCode);
                    int updated = pstmt.executeUpdate();
                    pstmt.close();
                    
                    if (updated > 0) {
                        System.out.println("  ✓ 已修复");
                        totalFixed++;
                    } else {
                        System.out.println("  ✗ 修复失败");
                    }
                } else {
                    System.out.println("⚠ " + itemCode + " - 未找到");
                }
                rs.close();
                System.out.println();
            }
            
            System.out.println("========================================");
            System.out.println("修复完成: " + totalFixed + "/" + itemCodes.length);
            System.out.println("========================================\n");
            
            // 验证修复结果
            System.out.println("【验证修复结果】\n");
            
            for (String itemCode : itemCodes) {
                String sql = "SELECT item_name, query_sql FROM t_indicator_item WHERE item_code = '" + itemCode + "'";
                ResultSet rs = stmt.executeQuery(sql);
                
                if (rs.next()) {
                    String itemName = rs.getString("item_name");
                    String querySql = rs.getString("query_sql");
                    
                    boolean stillHasProblem = querySql.contains("C03C") || querySql.contains("C06x");
                    
                    if (stillHasProblem) {
                        System.out.println("✗ " + itemCode + " - " + itemName + " (仍有问题)");
                    } else {
                        System.out.println("✓ " + itemCode + " - " + itemName);
                    }
                }
                rs.close();
            }

            stmt.close();
            conn.close();
            
            System.out.println("\n修复完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
