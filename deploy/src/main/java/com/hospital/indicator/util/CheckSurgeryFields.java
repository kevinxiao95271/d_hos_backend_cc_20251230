package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查手术相关字段（C14开头）
 */
public class CheckSurgeryFields {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("检查C14/C15/C16开头的手术相关字段:\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");
            ResultSet rs = stmt.executeQuery("DESCRIBE d_mr");
            
            int count = 0;
            while (rs.next()) {
                String field = rs.getString("Field");
                if (field.startsWith("C14") || field.startsWith("C15") || field.startsWith("C16")) {
                    count++;
                    String type = rs.getString("Type");
                    System.out.println(String.format("%2d. %-15s %s", count, field, type));
                }
            }
            rs.close();
            
            System.out.println("\n共找到 " + count + " 个手术相关字段");
            
            // 查询2023年有手术编码数据的记录
            System.out.println("\n\n查找2023年有手术编码的病例:");
            String sql = "SELECT A48, A49, B15, C14x01C, C15x01N, C14x02C, C15x02N, C14x03C " +
                        "FROM d_mr " +
                        "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                        "  AND (C14x01C IS NOT NULL AND C14x01C != '') " +
                        "LIMIT 5";
            
            rs = stmt.executeQuery(sql);
            int caseCount = 0;
            while (rs.next()) {
                caseCount++;
                System.out.println("\n病例 " + caseCount + ":");
                System.out.println("  病案号: " + rs.getString("A48") + "-" + rs.getString("A49"));
                System.out.println("  出院日期: " + rs.getString("B15"));
                System.out.println("  手术编码1: " + rs.getString("C14x01C"));
                System.out.println("  手术名称1: " + rs.getString("C15x01N"));
                System.out.println("  手术编码2: " + rs.getString("C14x02C"));
                System.out.println("  手术名称2: " + rs.getString("C15x02N"));
            }
            rs.close();
            
            if (caseCount == 0) {
                System.out.println("  未找到有手术编码的病例");
            }
            
            // 查找是否有81.51或81.52的手术编码
            System.out.println("\n\n查找2023年髋关节置换术病例 (手术编码 81.51% 或 81.52%):");
            sql = "SELECT COUNT(*) as cnt FROM d_mr " +
                  "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                  "  AND (C14x01C LIKE '81.51%' OR C14x01C LIKE '81.52%' " +
                  "    OR C14x02C LIKE '81.51%' OR C14x02C LIKE '81.52%' " +
                  "    OR C14x03C LIKE '81.51%' OR C14x03C LIKE '81.52%' " +
                  "    OR C14x04C LIKE '81.51%' OR C14x04C LIKE '81.52%' " +
                  "    OR C14x05C LIKE '81.51%' OR C14x05C LIKE '81.52%' " +
                  "    OR C14x06C LIKE '81.51%' OR C14x06C LIKE '81.52%')";
            
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                int cnt = rs.getInt("cnt");
                System.out.println("  髋关节置换术病例数: " + cnt + " 例");
                
                if (cnt == 0) {
                    System.out.println("\n  ✓ 2023年确实没有髋关节置换术病例，指标返回0是正常的");
                }
            }
            rs.close();

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
