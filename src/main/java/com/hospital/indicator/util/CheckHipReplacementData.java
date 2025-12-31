package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查髋关节置换术数据和指标项SQL
 */
public class CheckHipReplacementData {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("髋关节置换术数据检查");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");
            
            // 1. 查看髋关节指标项的SQL配置
            System.out.println("【1. 髋关节置换术指标项SQL配置】\n");
            String sql = "SELECT item_code, item_name, query_sql " +
                        "FROM t_indicator_item " +
                        "WHERE item_name LIKE '%髋关节%' " +
                        "ORDER BY item_code";
            
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                String itemCode = rs.getString("item_code");
                String itemName = rs.getString("item_name");
                String querySql = rs.getString("query_sql");
                
                System.out.println(itemCode + " - " + itemName);
                System.out.println("SQL: " + querySql.substring(0, Math.min(200, querySql.length())) + "...");
                System.out.println();
            }
            rs.close();
            
            // 2. 检查2023年有手术编码的病例
            System.out.println("\n【2. 2023年手术病例总数】");
            sql = "SELECT COUNT(*) as cnt FROM d_mr " +
                  "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                  "  AND C14x01C IS NOT NULL AND C14x01C != ''";
            
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                System.out.println("  有手术编码的病例: " + rs.getInt("cnt") + " 例");
            }
            rs.close();
            
            // 3. 查看2023年手术编码分布
            System.out.println("\n【3. 2023年手术编码分布 (前20)】");
            sql = "SELECT C14x01C, COUNT(*) as cnt " +
                  "FROM d_mr " +
                  "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                  "  AND C14x01C IS NOT NULL AND C14x01C != '' " +
                  "GROUP BY C14x01C " +
                  "ORDER BY cnt DESC " +
                  "LIMIT 20";
            
            rs = stmt.executeQuery(sql);
            int idx = 0;
            while (rs.next()) {
                idx++;
                System.out.println("  " + idx + ". " + rs.getString("C14x01C") + ": " + rs.getInt("cnt") + " 例");
            }
            rs.close();
            
            // 4. 查找髋关节置换术（使用手术字段 C14x01C）
            System.out.println("\n【4. 查找2023年髋关节置换术 (C14x01C LIKE '81.51%' OR '81.52%')】");
            sql = "SELECT COUNT(*) as cnt FROM d_mr " +
                  "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                  "  AND (C14x01C LIKE '81.51%' OR C14x01C LIKE '81.52%')";
            
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                int cnt = rs.getInt("cnt");
                System.out.println("  病例数: " + cnt + " 例");
                
                if (cnt == 0) {
                    System.out.println("\n  结论: 2023年无髋关节置换术病例");
                }
            }
            rs.close();
            
            // 5. 使用指标项当前的SQL查询（诊断字段）
            System.out.println("\n【5. 使用当前指标项SQL查询 (C03C/C06x01C诊断字段)】");
            sql = "SELECT COUNT(*) as cnt FROM d_mr " +
                  "WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2023-01-01' AND '2023-12-31' " +
                  "  AND (C03C LIKE '81.51%' OR C03C LIKE '81.52%' OR C06x01C LIKE '81.51%' OR C06x01C LIKE '81.52%')";
            
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                int cnt = rs.getInt("cnt");
                System.out.println("  病例数: " + cnt + " 例");
                System.out.println("\n  问题: 当前指标项SQL使用诊断字段(C03C/C06x01C)查询手术编码(81.51/81.52)");
                System.out.println("  说明: 81.51/81.52是手术编码，应该在C14x01C字段查询，而不是诊断字段");
            }
            rs.close();

            stmt.close();
            conn.close();
            
            System.out.println("\n========================================");
            System.out.println("检查完成");
            System.out.println("========================================");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
