package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查并修复B15字段的日期比较问题
 */
public class FixB15DateComparison {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功！\n");

            Statement stmt = conn.createStatement();

            // 1. 检查B15字段的数据类型
            System.out.println("=== 1. 检查 d_mr 表的 B15 字段类型 ===");
            ResultSet rs = stmt.executeQuery("SHOW COLUMNS FROM d_mr WHERE Field = 'B15'");
            String b15Type = "";
            if (rs.next()) {
                b15Type = rs.getString("Type");
                System.out.println("字段名: " + rs.getString("Field"));
                System.out.println("数据类型: " + b15Type);
                System.out.println("是否为空: " + rs.getString("Null"));
                System.out.println("默认值: " + rs.getString("Default"));
            }
            rs.close();

            // 2. 查看B15的实际数据样例
            System.out.println("\n=== 2. B15 字段实际数据样例 ===");
            rs = stmt.executeQuery("SELECT B15 FROM d_mr WHERE B15 IS NOT NULL LIMIT 5");
            int count = 0;
            while (rs.next()) {
                count++;
                Object b15Value = rs.getObject("B15");
                System.out.println("样例 " + count + ": " + b15Value + " (Java类型: " + (b15Value != null ? b15Value.getClass().getSimpleName() : "null") + ")");
            }
            rs.close();

            // 3. 测试不同的查询方式
            System.out.println("\n=== 3. 测试不同的日期比较方式 ===");

            // 方式1: 直接 BETWEEN
            System.out.println("\n方式1: B15 BETWEEN '2023-01-01' AND '2023-12-31'");
            try {
                rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM d_mr WHERE B15 BETWEEN '2023-01-01' AND '2023-12-31'");
                if (rs.next()) {
                    System.out.println("  结果: " + rs.getInt("cnt") + " 条记录 ✓");
                }
                rs.close();
            } catch (Exception e) {
                System.out.println("  错误: " + e.getMessage() + " ✗");
            }

            // 方式2: DATE(B15) BETWEEN
            System.out.println("\n方式2: DATE(B15) BETWEEN '2023-01-01' AND '2023-12-31'");
            try {
                rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM d_mr WHERE DATE(B15) BETWEEN '2023-01-01' AND '2023-12-31'");
                if (rs.next()) {
                    System.out.println("  结果: " + rs.getInt("cnt") + " 条记录 ✓");
                }
                rs.close();
            } catch (Exception e) {
                System.out.println("  错误: " + e.getMessage() + " ✗");
            }

            // 方式3: STR_TO_DATE
            System.out.println("\n方式3: STR_TO_DATE(B15, '%Y-%m-%d') BETWEEN");
            try {
                rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM d_mr WHERE STR_TO_DATE(B15, '%Y-%m-%d') BETWEEN '2023-01-01' AND '2023-12-31'");
                if (rs.next()) {
                    System.out.println("  结果: " + rs.getInt("cnt") + " 条记录 ✓");
                }
                rs.close();
            } catch (Exception e) {
                System.out.println("  错误: " + e.getMessage() + " ✗");
            }

            // 方式4: >= AND <=
            System.out.println("\n方式4: B15 >= '2023-01-01' AND B15 <= '2023-12-31'");
            try {
                rs = stmt.executeQuery("SELECT COUNT(*) as cnt FROM d_mr WHERE B15 >= '2023-01-01' AND B15 <= '2023-12-31'");
                if (rs.next()) {
                    System.out.println("  结果: " + rs.getInt("cnt") + " 条记录 ✓");
                }
                rs.close();
            } catch (Exception e) {
                System.out.println("  错误: " + e.getMessage() + " ✗");
            }

            // 4. 检查当前指标项SQL中B15的使用情况
            System.out.println("\n=== 4. 当前指标项SQL示例 ===");
            rs = stmt.executeQuery("SELECT item_code, item_name, SUBSTRING(query_sql, 1, 200) as sql_preview FROM t_indicator_item WHERE query_sql LIKE '%B15%' LIMIT 3");
            int i = 0;
            while (rs.next()) {
                i++;
                System.out.println("\n指标 " + i + ": " + rs.getString("item_code") + " - " + rs.getString("item_name"));
                System.out.println("  SQL片段: " + rs.getString("sql_preview") + "...");
            }
            rs.close();

            // 5. 给出修复建议
            System.out.println("\n=== 5. 修复建议 ===");
            System.out.println("B15字段类型: " + b15Type);

            if (b15Type.toLowerCase().contains("char") || b15Type.toLowerCase().contains("text")) {
                System.out.println("⚠️  B15是字符串类型，建议:");
                System.out.println("   1. 如果数据格式规范，使用: DATE(B15) BETWEEN");
                System.out.println("   2. 如果数据格式不规范，使用: STR_TO_DATE(B15, '%Y-%m-%d') BETWEEN");
                System.out.println("   3. 或者修改表结构，将B15改为DATETIME/DATE类型");
            } else if (b15Type.toLowerCase().contains("date") || b15Type.toLowerCase().contains("time")) {
                System.out.println("✓ B15已经是日期/时间类型，当前SQL应该正常工作");
                System.out.println("  如果仍有问题，可以显式使用 DATE(B15) 来确保只比较日期部分");
            } else {
                System.out.println("⚠️  B15是其他类型: " + b15Type);
                System.out.println("  需要根据实际情况进行转换");
            }

            stmt.close();
            conn.close();
            System.out.println("\n检查完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
