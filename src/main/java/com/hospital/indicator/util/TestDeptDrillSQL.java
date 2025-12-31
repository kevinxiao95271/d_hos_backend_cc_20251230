package com.hospital.indicator.util;

import java.sql.*;

/**
 * 测试科室下钻SQL
 */
public class TestDeptDrillSQL {

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
            System.out.println("测试科室下钻SQL");
            System.out.println("========================================\n");

            // 1. 查询"肺炎（住院、儿童）病死率"指标配置
            String sql1 = "SELECT metric_code, metric_name, related_items, expression FROM t_indicator WHERE metric_name LIKE '%肺炎%儿童%病死率%'";
            ResultSet rs1 = stmt.executeQuery(sql1);

            if (rs1.next()) {
                System.out.println("指标配置:");
                System.out.println("  metric_code: " + rs1.getString("metric_code"));
                System.out.println("  metric_name: " + rs1.getString("metric_name"));
                System.out.println("  related_items: " + rs1.getString("related_items"));
                System.out.println("  expression: " + rs1.getString("expression"));
            }
            rs1.close();

            // 2. 查询指标项配置
            System.out.println("\n指标项配置:");
            String sql2 = "SELECT item_code, item_name, query_sql FROM t_indicator_item WHERE item_code IN ('a0059', 'a0067')";
            ResultSet rs2 = stmt.executeQuery(sql2);

            while (rs2.next()) {
                System.out.println("\n  item_code: " + rs2.getString("item_code"));
                System.out.println("  item_name: " + rs2.getString("item_name"));
                System.out.println("  query_sql: " + rs2.getString("query_sql"));
            }
            rs2.close();

            // 3. 测试修改后的SQL（修正数据库名）
            System.out.println("\n\n========================================");
            System.out.println("测试修改后的SQL执行结果");
            System.out.println("========================================\n");

            String testSql = "SELECT B16 as dept_code, B16 as dept_name,  COUNT(*) as value  FROM t_cl_dbzhxx  WHERE B01 LIKE '肺炎%' AND B38 = '001' AND INSTR(B44, '儿') > 0 AND C05 BETWEEN '2020-01-01' AND '2020-12-31' GROUP BY B16 LIMIT 10";

            System.out.println("执行SQL: " + testSql);
            ResultSet rs3 = stmt.executeQuery(testSql);

            System.out.println("\n结果:");
            System.out.println("dept_code\tdept_name\tvalue");
            System.out.println("----------------------------------------");
            int count = 0;
            while (rs3.next()) {
                count++;
                System.out.println(rs3.getString("dept_code") + "\t" + rs3.getString("dept_name") + "\t" + rs3.getInt("value"));
            }
            System.out.println("\n共 " + count + " 个科室有数据");
            rs3.close();

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
