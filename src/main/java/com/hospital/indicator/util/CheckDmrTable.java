package com.hospital.indicator.util;

import java.sql.*;

/**
 * 查看 d_mr 表结构
 */
public class CheckDmrTable {

    private static final String DB_URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            System.out.println("========================================");
            System.out.println("查看 d_mr 表结构");
            System.out.println("========================================\n");

            String sql = "SHOW COLUMNS FROM d_mr LIKE '%16%'";
            ResultSet rs = stmt.executeQuery(sql);

            System.out.println("包含'16'的字段:");
            System.out.println("字段名\t类型\t\t注释");
            System.out.println("----------------------------------------");
            while (rs.next()) {
                System.out.println(rs.getString("Field") + "\t" + rs.getString("Type") + "\t" + rs.getString("Comment"));
            }
            rs.close();

            // 查找所有B开头的字段
            System.out.println("\n\n包含'B'且可能是科室的字段:");
            String sql2 = "SHOW FULL COLUMNS FROM d_mr WHERE Field LIKE 'B%' AND (Comment LIKE '%科室%' OR Comment LIKE '%dept%')";
            ResultSet rs2 = stmt.executeQuery(sql2);

            System.out.println("字段名\t类型\t\t注释");
            System.out.println("----------------------------------------");
            while (rs2.next()) {
                System.out.println(rs2.getString("Field") + "\t" + rs2.getString("Type") + "\t" + rs2.getString("Comment"));
            }
            rs2.close();

            // 查找所有可能是科室的字段
            System.out.println("\n\n所有可能是科室的字段:");
            String sql3 = "SHOW FULL COLUMNS FROM d_mr WHERE Comment LIKE '%科室%' OR Comment LIKE '%dept%'";
            ResultSet rs3 = stmt.executeQuery(sql3);

            System.out.println("字段名\t类型\t\t注释");
            System.out.println("----------------------------------------");
            while (rs3.next()) {
                System.out.println(rs3.getString("Field") + "\t" + rs3.getString("Type") + "\t" + rs3.getString("Comment"));
            }
            rs3.close();

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
