package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查B15字段的实际格式
 */
public class CheckB15Format {

    private static final String DB_URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            Statement stmt = conn.createStatement();

            System.out.println("========================================");
            System.out.println("检查B15字段格式");
            System.out.println("========================================\n");

            // 查看B15字段的实际值
            String sql = "SELECT B15, DATE_FORMAT(STR_TO_DATE(B15, '%Y/%m/%d'), '%Y-%m-%d') as formatted FROM d_mr LIMIT 10";

            System.out.println("执行SQL: " + sql);
            ResultSet rs = stmt.executeQuery(sql);

            System.out.println("\nB15原始值示例:");
            System.out.println("----------------------------------------");
            while (rs.next()) {
                String b15 = rs.getString("B15");
                String formatted = rs.getString("formatted");
                System.out.println("原始: " + b15 + " -> 转换后: " + formatted);
            }
            rs.close();

            // 测试两种日期格式的查询
            System.out.println("\n\n========================================");
            System.out.println("测试不同日期格式的WHERE条件");
            System.out.println("========================================\n");

            // 测试1: 使用斜杠格式
            String sql1 = "SELECT COUNT(*) as cnt FROM d_mr WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2020/01/01' AND '2020/12/31'";
            ResultSet rs1 = stmt.executeQuery(sql1);
            if (rs1.next()) {
                System.out.println("格式1 (斜杠BETWEEN斜杠): " + rs1.getInt("cnt") + " 条记录");
            }
            rs1.close();

            // 测试2: 使用横杠格式
            String sql2 = "SELECT COUNT(*) as cnt FROM d_mr WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN '2020-01-01' AND '2020-12-31'";
            ResultSet rs2 = stmt.executeQuery(sql2);
            if (rs2.next()) {
                System.out.println("格式2 (斜杠BETWEEN横杠): " + rs2.getInt("cnt") + " 条记录");
            }
            rs2.close();

            // 测试3: 直接比较(不用STR_TO_DATE)
            String sql3 = "SELECT COUNT(*) as cnt FROM d_mr WHERE B15 BETWEEN '2020/01/01' AND '2020/12/31'";
            ResultSet rs3 = stmt.executeQuery(sql3);
            if (rs3.next()) {
                System.out.println("格式3 (直接字符串比较斜杠): " + rs3.getInt("cnt") + " 条记录");
            }
            rs3.close();

            // 测试4: 直接比较横杠
            String sql4 = "SELECT COUNT(*) as cnt FROM d_mr WHERE B15 BETWEEN '2020-01-01' AND '2020-12-31'";
            ResultSet rs4 = stmt.executeQuery(sql4);
            if (rs4.next()) {
                System.out.println("格式4 (直接字符串比较横杠): " + rs4.getInt("cnt") + " 条记录");
            }
            rs4.close();

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
