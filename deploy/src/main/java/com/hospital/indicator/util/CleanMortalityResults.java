package com.hospital.indicator.util;

import java.sql.*;

/**
 * 清理病死率指标的2023年结果，以便重新测试
 */
public class CleanMortalityResults {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            // 删除所有病死率指标的2023年结果
            String deleteSql = "DELETE FROM t_indicator_result WHERE metric_code LIKE '%病死率' AND time_value='2023'";
            int count = stmt.executeUpdate(deleteSql);

            System.out.println("已删除 " + count + " 条病死率指标的2023年结果记录");

            // 查看剩余的病死率结果
            String querySql = "SELECT metric_code, time_value, result_value, calculation_status " +
                            "FROM t_indicator_result WHERE metric_code LIKE '%病死率' ORDER BY metric_code, time_value";
            ResultSet rs = stmt.executeQuery(querySql);

            System.out.println("\n剩余的病死率指标结果：");
            System.out.println("指标编码\t\t\t时间\t结果值\t状态");
            System.out.println("================================================================================");

            while (rs.next()) {
                System.out.println(rs.getString("metric_code") + "\t" +
                                 rs.getString("time_value") + "\t" +
                                 rs.getBigDecimal("result_value") + "\t" +
                                 rs.getString("calculation_status"));
            }

            rs.close();
            stmt.close();
            conn.close();

            System.out.println("\n清理完成！现在可以重新测试病死率指标了。");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
