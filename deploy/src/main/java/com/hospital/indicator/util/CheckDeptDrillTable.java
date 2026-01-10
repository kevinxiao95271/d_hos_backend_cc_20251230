package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查科室下钻数据表状态
 */
public class CheckDeptDrillTable {

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
            System.out.println("检查科室下钻数据表状态");
            System.out.println("========================================\n");

            // 检查表是否存在
            String checkTableSql = "SHOW TABLES LIKE 't_indicator_result_dept'";
            ResultSet tableRs = stmt.executeQuery(checkTableSql);

            if (tableRs.next()) {
                System.out.println("✓ 表 t_indicator_result_dept 存在\n");

                // 查询总记录数
                String countSql = "SELECT COUNT(*) as total FROM t_indicator_result_dept";
                ResultSet countRs = stmt.executeQuery(countSql);
                int total = 0;
                if (countRs.next()) {
                    total = countRs.getInt("total");
                    System.out.println("总记录数: " + total);
                }
                countRs.close();

                if (total > 0) {
                    // 查询按年份统计
                    String yearSql = "SELECT time_value, COUNT(*) as cnt " +
                                   "FROM t_indicator_result_dept " +
                                   "WHERE time_dimension = 'YEAR' " +
                                   "GROUP BY time_value " +
                                   "ORDER BY time_value";
                    ResultSet yearRs = stmt.executeQuery(yearSql);

                    System.out.println("\n按年份统计:");
                    System.out.println("年份\t记录数");
                    System.out.println("------------------------");
                    while (yearRs.next()) {
                        System.out.println(yearRs.getString("time_value") + "\t" + yearRs.getInt("cnt"));
                    }
                    yearRs.close();

                    // 查询指标统计
                    String metricSql = "SELECT metric_code, COUNT(*) as cnt " +
                                     "FROM t_indicator_result_dept " +
                                     "GROUP BY metric_code " +
                                     "ORDER BY cnt DESC " +
                                     "LIMIT 10";
                    ResultSet metricRs = stmt.executeQuery(metricSql);

                    System.out.println("\n记录最多的10个指标:");
                    System.out.println("指标编码\t\t记录数");
                    System.out.println("----------------------------------------");
                    while (metricRs.next()) {
                        System.out.println(metricRs.getString("metric_code") + "\t" + metricRs.getInt("cnt"));
                    }
                    metricRs.close();

                    // 查看表结构
                    String structureSql = "SHOW CREATE TABLE t_indicator_result_dept";
                    ResultSet structRs = stmt.executeQuery(structureSql);
                    if (structRs.next()) {
                        System.out.println("\n表结构:");
                        System.out.println("========================================");
                        System.out.println(structRs.getString(2));
                    }
                    structRs.close();

                } else {
                    System.out.println("\n⚠ 表为空，没有科室下钻数据");

                    // 查看表结构
                    String structureSql = "SHOW CREATE TABLE t_indicator_result_dept";
                    ResultSet structRs = stmt.executeQuery(structureSql);
                    if (structRs.next()) {
                        System.out.println("\n表结构:");
                        System.out.println("========================================");
                        System.out.println(structRs.getString(2));
                    }
                    structRs.close();
                }

            } else {
                System.out.println("✗ 表 t_indicator_result_dept 不存在");
            }

            tableRs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
