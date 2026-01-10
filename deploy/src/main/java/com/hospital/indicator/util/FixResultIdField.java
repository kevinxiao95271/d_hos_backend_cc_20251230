package com.hospital.indicator.util;

import java.sql.*;

/**
 * 修复 result_id 字段允许NULL
 */
public class FixResultIdField {

    private static final String DB_URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            Statement stmt = conn.createStatement();

            System.out.println("========================================");
            System.out.println("修复 result_id 字段");
            System.out.println("========================================\n");

            String alterSql = "ALTER TABLE t_indicator_result_dept MODIFY COLUMN result_id BIGINT NULL COMMENT '关联的指标结果ID(可选)'";

            System.out.println("执行SQL: " + alterSql);

            stmt.execute(alterSql);

            System.out.println("\n✓ 修改成功!");

            // 验证修改
            String checkSql = "SHOW CREATE TABLE t_indicator_result_dept";
            ResultSet rs = stmt.executeQuery(checkSql);

            if (rs.next()) {
                System.out.println("\n表结构:");
                System.out.println("========================================");
                String createTable = rs.getString(2);
                // 只显示result_id相关的行
                for (String line : createTable.split(",")) {
                    if (line.contains("result_id")) {
                        System.out.println(line.trim());
                    }
                }
            }
            rs.close();

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
