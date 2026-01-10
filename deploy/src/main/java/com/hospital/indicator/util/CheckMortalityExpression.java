package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查病死率指标的表达式
 */
public class CheckMortalityExpression {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            // 查询所有病死率指标
            String sql = "SELECT metric_code, metric_name, expression, unit FROM t_indicator WHERE metric_name LIKE '%病死率'";
            ResultSet rs = stmt.executeQuery(sql);

            System.out.println("病死率指标配置：");
            System.out.println("================================================================================");

            while (rs.next()) {
                String code = rs.getString("metric_code");
                String name = rs.getString("metric_name");
                String expr = rs.getString("expression");
                String unit = rs.getString("unit");

                System.out.println("指标编码: " + code);
                System.out.println("指标名称: " + name);
                System.out.println("计算表达式: " + expr);
                System.out.println("单位: " + unit);
                System.out.println("--------------------------------------------------------------------------------");
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
