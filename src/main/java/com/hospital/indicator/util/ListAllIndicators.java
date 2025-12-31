package com.hospital.indicator.util;

import java.sql.*;

/**
 * 列出所有指标
 */
public class ListAllIndicators {

    private static final String DB_URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            Statement stmt = conn.createStatement();

            String sql = "SELECT metric_code, metric_name, related_items FROM t_indicator WHERE status = 1 ORDER BY metric_code";

            ResultSet rs = stmt.executeQuery(sql);

            System.out.println("All active indicators:");
            System.out.println("========================================");

            while (rs.next()) {
                String code = rs.getString("metric_code");
                String name = rs.getString("metric_name");
                String items = rs.getString("related_items");

                System.out.println("Code: " + code);
                System.out.println("Name: " + name);
                System.out.println("Items: " + items);
                System.out.println("--------");
            }
            rs.close();

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("Failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
