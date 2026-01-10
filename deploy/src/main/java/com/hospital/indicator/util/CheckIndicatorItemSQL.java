package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查所有指标项的SQL
 */
public class CheckIndicatorItemSQL {

    private static final String DB_URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            Statement stmt = conn.createStatement();

            System.out.println("========================================");
            System.out.println("检查所有指标项SQL中的日期处理");
            System.out.println("========================================\n");

            String sql = "SELECT item_code, item_name, query_sql FROM t_indicator_item WHERE status = 1";

            ResultSet rs = stmt.executeQuery(sql);

            int totalCount = 0;
            int strToDateCount = 0;

            while (rs.next()) {
                totalCount++;
                String itemCode = rs.getString("item_code");
                String itemName = rs.getString("item_name");
                String querySql = rs.getString("query_sql");

                if (querySql != null && querySql.toUpperCase().contains("STR_TO_DATE")) {
                    strToDateCount++;
                    System.out.println("指标项: " + itemCode + " - " + itemName);
                    System.out.println("SQL: " + querySql);
                    System.out.println();
                }
            }
            rs.close();

            System.out.println("========================================");
            System.out.println("统计结果:");
            System.out.println("  总指标项数: " + totalCount);
            System.out.println("  使用STR_TO_DATE的: " + strToDateCount);
            System.out.println("========================================");

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
