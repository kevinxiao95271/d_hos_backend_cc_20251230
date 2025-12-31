package com.hospital.indicator.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * 检查并修复B15日期格式问题
 */
public class FixB15DateFormat {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("B15日期格式检查与修复");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();

            // 1. 查看B15的实际格式
            System.out.println("【1. B15字段实际数据格式】");
            ResultSet rs = stmt.executeQuery("SELECT B15 FROM d_mr WHERE B15 IS NOT NULL LIMIT 10");
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("样例 " + count + ": " + rs.getString("B15"));
            }
            rs.close();

            // 2. 测试不同的日期比较方式
            String startDate = "2023-01-01";
            String endDate = "2023-12-31";

            System.out.println("\n【2. 测试不同的日期查询方式 (2023年)】");

            // 方式1: 原方式 - DATE(B15) BETWEEN
            System.out.println("\n方式1: DATE(B15) BETWEEN '2023-01-01' AND '2023-12-31'");
            rs = stmt.executeQuery(
                "SELECT COUNT(*) as cnt FROM d_mr WHERE DATE(B15) BETWEEN '" + startDate + "' AND '" + endDate + "'"
            );
            if (rs.next()) {
                System.out.println("  结果: " + rs.getInt("cnt") + " 条");
            }
            rs.close();

            // 方式2: >= AND < (推荐)
            System.out.println("\n方式2: DATE(B15) >= '2023-01-01' AND DATE(B15) < '2024-01-01'");
            rs = stmt.executeQuery(
                "SELECT COUNT(*) as cnt FROM d_mr WHERE DATE(B15) >= '2023-01-01' AND DATE(B15) < '2024-01-01'"
            );
            if (rs.next()) {
                System.out.println("  结果: " + rs.getInt("cnt") + " 条");
            }
            rs.close();

            // 方式3: >= AND <=
            System.out.println("\n方式3: DATE(B15) >= '2023-01-01' AND DATE(B15) <= '2023-12-31'");
            rs = stmt.executeQuery(
                "SELECT COUNT(*) as cnt FROM d_mr WHERE DATE(B15) >= '2023-01-01' AND DATE(B15) <= '2023-12-31'"
            );
            if (rs.next()) {
                System.out.println("  结果: " + rs.getInt("cnt") + " 条");
            }
            rs.close();

            // 方式4: STR_TO_DATE
            System.out.println("\n方式4: STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN");
            rs = stmt.executeQuery(
                "SELECT COUNT(*) as cnt FROM d_mr WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '" + startDate + "' AND '" + endDate + "'"
            );
            if (rs.next()) {
                System.out.println("  结果: " + rs.getInt("cnt") + " 条");
            }
            rs.close();

            // 方式5: YEAR函数
            System.out.println("\n方式5: YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023");
            rs = stmt.executeQuery(
                "SELECT COUNT(*) as cnt FROM d_mr WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023"
            );
            if (rs.next()) {
                System.out.println("  结果: " + rs.getInt("cnt") + " 条");
            }
            rs.close();

            // 3. 测试心力衰竭病例（使用正确的日期格式）
            System.out.println("\n【3. 测试心力衰竭病例查询】");

            System.out.println("\n使用 YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023:");
            String heartFailureSql =
                "SELECT COUNT(*) as cnt " +
                "FROM d_mr " +
                "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                "  AND (C03C LIKE 'I11.0%' OR C03C LIKE 'I13.0%' OR C03C LIKE 'I13.2%' OR C03C LIKE 'I50%' " +
                "    OR C06x01C LIKE 'I11.0%' OR C06x01C LIKE 'I13.0%' OR C06x01C LIKE 'I13.2%' OR C06x01C LIKE 'I50%')";

            rs = stmt.executeQuery(heartFailureSql);
            if (rs.next()) {
                int heartCount = rs.getInt("cnt");
                System.out.println("  心力衰竭病例数: " + heartCount);
            }
            rs.close();

            // 4. 检查实际有数据的年份
            System.out.println("\n【4. 检查数据库中实际有数据的年份】");
            rs = stmt.executeQuery(
                "SELECT YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) as year, COUNT(*) as cnt " +
                "FROM d_mr " +
                "WHERE B15 IS NOT NULL " +
                "GROUP BY YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) " +
                "ORDER BY year DESC " +
                "LIMIT 10"
            );
            System.out.println("年份分布:");
            while (rs.next()) {
                System.out.println("  " + rs.getInt("year") + "年: " + rs.getInt("cnt") + " 条记录");
            }
            rs.close();

            // 5. 给出修复建议
            System.out.println("\n【5. SQL修复建议】");
            System.out.println("原SQL:");
            System.out.println("  WHERE DATE(B15) BETWEEN #{startDate} AND #{endDate}");
            System.out.println("\n推荐方案1 (最准确):");
            System.out.println("  WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = YEAR(#{startDate})");
            System.out.println("  (适用于按年统计)");
            System.out.println("\n推荐方案2 (通用):");
            System.out.println("  WHERE STR_TO_DATE(B15, '%Y/%m/%d') >= #{startDate}");
            System.out.println("    AND STR_TO_DATE(B15, '%Y/%m/%d') < DATE_ADD(#{endDate}, INTERVAL 1 DAY)");

            stmt.close();
            conn.close();
            System.out.println("\n检查完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
