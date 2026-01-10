package com.hospital.indicator.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * 修复所有指标项SQL - 使用STR_TO_DATE处理B15日期格式
 */
public class FixAllB15ToStrToDate {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&allowMultiQueries=true";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功！\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            System.out.println("开始修复B15日期格式问题...");
            System.out.println("B15实际格式: 2020/1/18 10:00 (斜杠分隔)\n");

            // 1. DATE(B15) BETWEEN -> STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN
            System.out.println("1. 修复 DATE(B15) BETWEEN...");
            int count1 = stmt.executeUpdate(
                "UPDATE t_indicator_item " +
                "SET query_sql = REPLACE(query_sql, 'DATE(B15) BETWEEN', \"STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN\") " +
                "WHERE query_sql LIKE '%DATE(B15) BETWEEN%'"
            );
            System.out.println("   更新了 " + count1 + " 条记录");

            // 2. DATE(d_mr.B15) BETWEEN -> STR_TO_DATE(d_mr.B15, '%Y/%m/%d') BETWEEN
            System.out.println("2. 修复 DATE(d_mr.B15) BETWEEN...");
            int count2 = stmt.executeUpdate(
                "UPDATE t_indicator_item " +
                "SET query_sql = REPLACE(query_sql, 'DATE(d_mr.B15) BETWEEN', \"STR_TO_DATE(d_mr.B15, '%Y/%m/%d') BETWEEN\") " +
                "WHERE query_sql LIKE '%DATE(d_mr.B15) BETWEEN%'"
            );
            System.out.println("   更新了 " + count2 + " 条记录");

            System.out.println("\n修复完成！总计更新了 " + (count1 + count2) + " 条记录\n");

            // 验证修复结果
            System.out.println("=== 验证修复结果 ===");
            ResultSet rs = stmt.executeQuery(
                "SELECT " +
                "  COUNT(*) as total, " +
                "  SUM(CASE WHEN query_sql LIKE '%B15%' THEN 1 ELSE 0 END) as has_b15, " +
                "  SUM(CASE WHEN query_sql LIKE \"%STR_TO_DATE(B15, '%Y/%m/%d')%\" OR query_sql LIKE \"%STR_TO_DATE(d_mr.B15, '%Y/%m/%d')%\" THEN 1 ELSE 0 END) as fixed " +
                "FROM t_indicator_item"
            );
            if (rs.next()) {
                System.out.println("总指标项数: " + rs.getInt("total"));
                System.out.println("包含B15的指标项: " + rs.getInt("has_b15"));
                System.out.println("已修复为STR_TO_DATE: " + rs.getInt("fixed"));
            }
            rs.close();

            // 显示修复示例
            System.out.println("\n=== 修复后的SQL示例 ===");
            rs = stmt.executeQuery(
                "SELECT item_code, item_name, SUBSTRING(query_sql, 1, 200) as sql_preview " +
                "FROM t_indicator_item " +
                "WHERE query_sql LIKE \"%STR_TO_DATE%\" " +
                "LIMIT 3"
            );
            int i = 0;
            while (rs.next()) {
                i++;
                System.out.println("\n示例 " + i + ": " + rs.getString("item_code") + " - " + rs.getString("item_name"));
                System.out.println("  SQL: " + rs.getString("sql_preview") + "...");
            }
            rs.close();

            // 测试心力衰竭指标项
            System.out.println("\n=== 测试心力衰竭指标项（a0041）===");
            rs = stmt.executeQuery(
                "SELECT query_sql FROM t_indicator_item WHERE item_code = 'a0041'"
            );
            if (rs.next()) {
                String a0041Sql = rs.getString("query_sql");
                System.out.println("a0041 SQL:");
                System.out.println(a0041Sql.substring(0, Math.min(300, a0041Sql.length())));

                // 执行查询测试
                String testSql = a0041Sql.replace("#{startDate}", "'2023-01-01'")
                                         .replace("#{endDate}", "'2023-12-31'");
                System.out.println("\n执行测试查询...");
                ResultSet testRs = stmt.executeQuery(testSql);
                if (testRs.next()) {
                    System.out.println("✓ a0041 (心力衰竭病种例数) 结果: " + testRs.getInt("result_value") + " 人");
                }
                testRs.close();
            }
            rs.close();

            stmt.close();
            conn.close();
            System.out.println("\n修复完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
