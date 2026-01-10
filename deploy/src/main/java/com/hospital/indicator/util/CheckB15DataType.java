package com.hospital.indicator.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * 检查B15字段数据类型
 */
public class CheckB15DataType {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            // 加载驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 获取连接
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功！\n");

            Statement stmt = conn.createStatement();

            // 检查d_mr表的B15字段
            System.out.println("【检查 d_mr 表的 B15 字段】");
            ResultSet rs = stmt.executeQuery("DESCRIBE d_mr");
            while (rs.next()) {
                String field = rs.getString("Field");
                if ("B15".equals(field)) {
                    System.out.println("字段名: " + field);
                    System.out.println("数据类型: " + rs.getString("Type"));
                    System.out.println("是否为空: " + rs.getString("Null"));
                    System.out.println("键: " + rs.getString("Key"));
                    System.out.println("默认值: " + rs.getString("Default"));
                    System.out.println("额外信息: " + rs.getString("Extra"));
                }
            }
            rs.close();

            System.out.println("\n【检查 B15 字段的实际数据示例】");
            rs = stmt.executeQuery("SELECT B15, TYPEOF(B15) as data_type FROM d_mr LIMIT 5");
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("示例 " + count + ": " + rs.getString("B15"));
            }
            rs.close();

            System.out.println("\n【测试 BETWEEN 查询】");
            String testSql = "SELECT COUNT(*) as cnt FROM d_mr WHERE B15 BETWEEN '2023-01-01' AND '2023-12-31'";
            System.out.println("SQL: " + testSql);
            rs = stmt.executeQuery(testSql);
            if (rs.next()) {
                System.out.println("结果: " + rs.getInt("cnt") + " 条记录");
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
