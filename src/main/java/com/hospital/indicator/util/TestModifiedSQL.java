package com.hospital.indicator.util;

import java.sql.*;

/**
 * 直接测试修改后的SQL
 */
public class TestModifiedSQL {

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
            System.out.println("测试修改后的SQL");
            System.out.println("========================================\n");

            // 原始SQL (a0050)
            String originalSql = "SELECT COUNT(*) AS result_value FROM d_mr WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2020-01-01' AND '2020-12-31' AND (C03C LIKE 'J13%' OR C03C LIKE 'J14%' OR C03C LIKE 'J15%' OR C03C LIKE 'J18%' OR C06x01C LIKE 'J13%' OR C06x01C LIKE 'J14%' OR C06x01C LIKE 'J15%' OR C06x01C LIKE 'J18%') AND A14 >= 18";

            System.out.println("1. 原始SQL:");
            System.out.println(originalSql);

            ResultSet rs1 = stmt.executeQuery(originalSql);
            if (rs1.next()) {
                System.out.println("结果: " + rs1.getInt("result_value") + " 条记录\n");
            }
            rs1.close();

            // 修改后的SQL (添加B16 GROUP BY)
            String modifiedSql = "SELECT B16 as dept_code, B16 as dept_name,  COUNT(*) AS result_value  FROM d_mr WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2020-01-01' AND '2020-12-31' AND (C03C LIKE 'J13%' OR C03C LIKE 'J14%' OR C03C LIKE 'J15%' OR C03C LIKE 'J18%' OR C06x01C LIKE 'J13%' OR C06x01C LIKE 'J14%' OR C06x01C LIKE 'J15%' OR C06x01C LIKE 'J18%') AND A14 >= 18 GROUP BY B16";

            System.out.println("\n2. 修改后的SQL:");
            System.out.println(modifiedSql);

            ResultSet rs2 = stmt.executeQuery(modifiedSql);

            System.out.println("\n结果:");
            System.out.println("dept_code\tdept_name\tresult_value");
            System.out.println("----------------------------------------");

            int count = 0;
            while (rs2.next() && count < 20) {
                count++;
                String deptCode = rs2.getString("dept_code");
                String deptName = rs2.getString("dept_name");
                int value = rs2.getInt("result_value");
                System.out.println(deptCode + "\t" + deptName + "\t" + value);
            }

            System.out.println("\n共 " + count + " 个科室有数据");
            rs2.close();

            // 测试a0055的SQL
            System.out.println("\n\n========================================");
            System.out.println("测试a0055 (总费用) 的修改后SQL");
            System.out.println("========================================\n");

            String modifiedSql2 = "SELECT B16 as dept_code, B16 as dept_name,  IFNULL(SUM(D01), 0) AS result_value  FROM d_mr WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2020-01-01' AND '2020-12-31' AND (C03C LIKE 'J13%' OR C03C LIKE 'J14%' OR C03C LIKE 'J15%' OR C03C LIKE 'J18%' OR C06x01C LIKE 'J13%' OR C06x01C LIKE 'J14%' OR C06x01C LIKE 'J15%' OR C06x01C LIKE 'J18%') AND A14 >= 18 GROUP BY B16";

            System.out.println("SQL:");
            System.out.println(modifiedSql2);

            ResultSet rs3 = stmt.executeQuery(modifiedSql2);

            System.out.println("\n结果:");
            System.out.println("dept_code\tdept_name\tresult_value");
            System.out.println("----------------------------------------");

            count = 0;
            while (rs3.next() && count < 20) {
                count++;
                String deptCode = rs3.getString("dept_code");
                String deptName = rs3.getString("dept_name");
                double value = rs3.getDouble("result_value");
                System.out.println(deptCode + "\t" + deptName + "\t" + value);
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
