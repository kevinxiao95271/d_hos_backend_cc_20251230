package com.hospital.indicator.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * 修复所有指标项SQL中的B15日期比较问题
 */
public class FixAllB15Queries {

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
            stmt.execute("SET CHARACTER SET utf8mb4");

            // 执行修复SQL
            System.out.println("开始修复B15日期比较问题...\n");

            // 1. WHERE B15 BETWEEN
            System.out.println("1. 修复 WHERE B15 BETWEEN...");
            int count1 = stmt.executeUpdate(
                "UPDATE t_indicator_item " +
                "SET query_sql = REPLACE(query_sql, 'WHERE B15 BETWEEN', 'WHERE DATE(B15) BETWEEN') " +
                "WHERE query_sql LIKE '%WHERE B15 BETWEEN%'"
            );
            System.out.println("   更新了 " + count1 + " 条记录");

            // 2. WHERE d_mr.B15 BETWEEN
            System.out.println("2. 修复 WHERE d_mr.B15 BETWEEN...");
            int count2 = stmt.executeUpdate(
                "UPDATE t_indicator_item " +
                "SET query_sql = REPLACE(query_sql, 'WHERE d_mr.B15 BETWEEN', 'WHERE DATE(d_mr.B15) BETWEEN') " +
                "WHERE query_sql LIKE '%WHERE d_mr.B15 BETWEEN%'"
            );
            System.out.println("   更新了 " + count2 + " 条记录");

            // 3. AND B15 BETWEEN
            System.out.println("3. 修复 AND B15 BETWEEN...");
            int count3 = stmt.executeUpdate(
                "UPDATE t_indicator_item " +
                "SET query_sql = REPLACE(query_sql, 'AND B15 BETWEEN', 'AND DATE(B15) BETWEEN') " +
                "WHERE query_sql LIKE '%AND B15 BETWEEN%'"
            );
            System.out.println("   更新了 " + count3 + " 条记录");

            // 4. AND d_mr.B15 BETWEEN
            System.out.println("4. 修复 AND d_mr.B15 BETWEEN...");
            int count4 = stmt.executeUpdate(
                "UPDATE t_indicator_item " +
                "SET query_sql = REPLACE(query_sql, 'AND d_mr.B15 BETWEEN', 'AND DATE(d_mr.B15) BETWEEN') " +
                "WHERE query_sql LIKE '%AND d_mr.B15 BETWEEN%'"
            );
            System.out.println("   更新了 " + count4 + " 条记录");

            System.out.println("\n修复完成！总计更新了 " + (count1 + count2 + count3 + count4) + " 条记录\n");

            // 验证修复结果
            System.out.println("=== 验证修复结果 ===");
            ResultSet rs = stmt.executeQuery(
                "SELECT " +
                "  COUNT(*) as total, " +
                "  SUM(CASE WHEN query_sql LIKE '%B15%' THEN 1 ELSE 0 END) as has_b15, " +
                "  SUM(CASE WHEN query_sql LIKE '%DATE(B15)%' OR query_sql LIKE '%DATE(d_mr.B15)%' THEN 1 ELSE 0 END) as fixed " +
                "FROM t_indicator_item"
            );
            if (rs.next()) {
                System.out.println("总指标项数: " + rs.getInt("total"));
                System.out.println("包含B15的指标项: " + rs.getInt("has_b15"));
                System.out.println("已修复为DATE(B15): " + rs.getInt("fixed"));
            }
            rs.close();

            // 显示修复示例
            System.out.println("\n=== 修复后的SQL示例 ===");
            rs = stmt.executeQuery(
                "SELECT item_code, item_name, SUBSTRING(query_sql, 1, 200) as sql_preview " +
                "FROM t_indicator_item " +
                "WHERE query_sql LIKE '%DATE(B15)%' OR query_sql LIKE '%DATE(d_mr.B15)%' " +
                "LIMIT 3"
            );
            int i = 0;
            while (rs.next()) {
                i++;
                System.out.println("\n示例 " + i + ": " + rs.getString("item_code") + " - " + rs.getString("item_name"));
                System.out.println("  SQL: " + rs.getString("sql_preview") + "...");
            }
            rs.close();

            // 检查是否还有未修复的
            System.out.println("\n=== 检查未修复的情况 ===");
            rs = stmt.executeQuery(
                "SELECT item_code, item_name " +
                "FROM t_indicator_item " +
                "WHERE query_sql LIKE '%B15 BETWEEN%' " +
                "  AND query_sql NOT LIKE '%DATE(B15) BETWEEN%' " +
                "  AND query_sql NOT LIKE '%DATE(d_mr.B15) BETWEEN%'"
            );
            boolean hasUnfixed = false;
            while (rs.next()) {
                hasUnfixed = true;
                System.out.println("⚠ 未修复: " + rs.getString("item_code") + " - " + rs.getString("item_name"));
            }
            if (!hasUnfixed) {
                System.out.println("✓ 所有B15查询已正确修复！");
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
