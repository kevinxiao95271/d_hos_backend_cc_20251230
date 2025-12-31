package com.hospital.indicator.util;

import java.sql.*;

/**
 * Compare specific indicator item SQLs
 */
public class CheckItemSQL {

    private static final String DB_URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            Statement stmt = conn.createStatement();

            System.out.println("========================================");
            System.out.println("Compare indicator item SQLs");
            System.out.println("========================================\n");

            String sql = "SELECT item_code, item_name, query_sql FROM t_indicator_item WHERE item_code IN ('a0055', 'a0050', 'a0037', 'a0032') ORDER BY item_code";

            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                String code = rs.getString("item_code");
                String name = rs.getString("item_name");
                String querySql = rs.getString("query_sql");

                System.out.println("Item: " + code + " - " + name);
                System.out.println("SQL: " + querySql);
                System.out.println();

                // Test with GROUP BY B16
                String testSql = querySql.replace("#{startDate}", "'2020-01-01'")
                                         .replace("#{endDate}", "'2020-12-31'");

                // Add GROUP BY B16
                if (testSql.toUpperCase().contains("SELECT") && testSql.toUpperCase().contains("FROM")) {
                    int selectIdx = testSql.toUpperCase().indexOf("SELECT");
                    int fromIdx = testSql.toUpperCase().indexOf("FROM");

                    String selectPart = "SELECT B16 as dept_code, B16 as dept_name, ";
                    String valuePart = testSql.substring(selectIdx + 6, fromIdx).trim();
                    String fromPart = testSql.substring(fromIdx);

                    testSql = selectPart + valuePart + " " + fromPart + " GROUP BY B16";

                    System.out.println("Modified SQL: " + testSql);
                    System.out.println();

                    try {
                        Statement testStmt = conn.createStatement();
                        ResultSet testRs = testStmt.executeQuery(testSql);

                        int count = 0;
                        while (testRs.next() && count < 5) {
                            count++;
                            System.out.println("  Dept: " + testRs.getString("dept_code") +
                                             ", Value: " + testRs.getBigDecimal("result_value"));
                        }

                        if (count == 0) {
                            System.out.println("  No data returned");
                        } else {
                            System.out.println("  Total rows: " + count + "+");
                        }

                        testRs.close();
                        testStmt.close();
                    } catch (Exception e) {
                        System.out.println("  SQL Error: " + e.getMessage());
                    }
                }

                System.out.println("========================================\n");
            }
            rs.close();

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("Failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
