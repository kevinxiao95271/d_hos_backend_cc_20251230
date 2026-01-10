package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查心力衰竭的ICD编码并验证指标项a0041
 */
public class CheckHeartFailureICD {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("心力衰竭ICD编码检查");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();

            // 1. 检查2023年数据中的ICD编码分布
            System.out.println("【1. 2023年数据中包含I的ICD编码】");
            String sql = "SELECT C03C, COUNT(*) as cnt " +
                        "FROM d_mr " +
                        "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                        "  AND (C03C LIKE 'I%' OR C06x01C LIKE 'I%') " +
                        "GROUP BY C03C " +
                        "ORDER BY cnt DESC " +
                        "LIMIT 20";

            ResultSet rs = stmt.executeQuery(sql);
            System.out.println("主要诊断编码 (C03C):");
            while (rs.next()) {
                String icd = rs.getString("C03C");
                int cnt = rs.getInt("cnt");
                System.out.println("  " + (icd != null ? icd : "NULL") + ": " + cnt + " 例");
            }
            rs.close();

            // 2. 检查C06x01C字段
            System.out.println("\n【2. 检查其他诊断编码 (C06x01C)】");
            sql = "SELECT C06x01C, COUNT(*) as cnt " +
                  "FROM d_mr " +
                  "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                  "  AND C06x01C LIKE 'I%' " +
                  "GROUP BY C06x01C " +
                  "ORDER BY cnt DESC " +
                  "LIMIT 10";

            rs = stmt.executeQuery(sql);
            System.out.println("其他诊断编码 (C06x01C):");
            while (rs.next()) {
                String icd = rs.getString("C06x01C");
                int cnt = rs.getInt("cnt");
                System.out.println("  " + (icd != null ? icd : "NULL") + ": " + cnt + " 例");
            }
            rs.close();

            // 3. 测试不同的心力衰竭查询条件
            System.out.println("\n【3. 测试不同的心力衰竭查询条件】");

            // 测试1: 原条件
            System.out.println("\n测试1: I11.0%, I13.0%, I13.2%, I50 (精确匹配)");
            sql = "SELECT COUNT(*) as cnt FROM d_mr " +
                  "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                  "  AND (C03C LIKE 'I11.0%' OR C03C LIKE 'I13.0%' OR C03C LIKE 'I13.2%' OR C03C = 'I50' " +
                  "    OR C06x01C LIKE 'I11.0%' OR C06x01C LIKE 'I13.0%' OR C06x01C LIKE 'I13.2%' OR C06x01C = 'I50')";
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                System.out.println("  结果: " + rs.getInt("cnt") + " 例");
            }
            rs.close();

            // 测试2: I50%模糊匹配
            System.out.println("\n测试2: I50% (模糊匹配)");
            sql = "SELECT COUNT(*) as cnt FROM d_mr " +
                  "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                  "  AND (C03C LIKE 'I50%' OR C06x01C LIKE 'I50%')";
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                System.out.println("  结果: " + rs.getInt("cnt") + " 例");
            }
            rs.close();

            // 测试3: 所有I11,I13,I50开头的
            System.out.println("\n测试3: I11%, I13%, I50% (全部模糊匹配)");
            sql = "SELECT COUNT(*) as cnt FROM d_mr " +
                  "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                  "  AND (C03C LIKE 'I11%' OR C03C LIKE 'I13%' OR C03C LIKE 'I50%' " +
                  "    OR C06x01C LIKE 'I11%' OR C06x01C LIKE 'I13%' OR C06x01C LIKE 'I50%')";
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                int cnt = rs.getInt("cnt");
                System.out.println("  结果: " + cnt + " 例");

                if (cnt > 0) {
                    // 显示具体病例
                    System.out.println("\n  具体病例:");
                    sql = "SELECT A48, A49, B15, C03C, C06x01C FROM d_mr " +
                          "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                          "  AND (C03C LIKE 'I11%' OR C03C LIKE 'I13%' OR C03C LIKE 'I50%' " +
                          "    OR C06x01C LIKE 'I11%' OR C06x01C LIKE 'I13%' OR C06x01C LIKE 'I50%') " +
                          "LIMIT 5";
                    ResultSet detailRs = stmt.executeQuery(sql);
                    while (detailRs.next()) {
                        System.out.println("    病案号: " + detailRs.getString("A48") + "-" + detailRs.getString("A49"));
                        System.out.println("    出院日期: " + detailRs.getString("B15"));
                        System.out.println("    主要诊断: " + detailRs.getString("C03C"));
                        System.out.println("    其他诊断: " + detailRs.getString("C06x01C"));
                        System.out.println();
                    }
                    detailRs.close();
                }
            }
            rs.close();

            // 4. 检查a0041配置
            System.out.println("\n【4. 检查指标项a0041配置】");
            sql = "SELECT item_code, item_name, query_sql FROM t_indicator_item WHERE item_code = 'a0041'";
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                System.out.println("指标项: " + rs.getString("item_code") + " - " + rs.getString("item_name"));
                String querySql = rs.getString("query_sql");
                System.out.println("\nSQL:");
                System.out.println(querySql);
            }
            rs.close();

            stmt.close();
            conn.close();
            System.out.println("\n检查完成！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
