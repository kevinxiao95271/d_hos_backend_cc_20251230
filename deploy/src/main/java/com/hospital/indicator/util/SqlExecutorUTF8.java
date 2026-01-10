package com.hospital.indicator.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

/**
 * SQL执行工具类 - UTF-8版本
 */
public class SqlExecutorUTF8 {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&allowMultiQueries=true";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            // 加载驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 获取连接
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功！");

            // 设置连接字符集
            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");
            stmt.execute("SET CHARACTER SET utf8mb4");
            stmt.execute("SET character_set_connection=utf8mb4");

            // 先删除旧数据
            System.out.println("\n清理旧数据...");
            stmt.execute("DELETE FROM t_indicator_item WHERE item_code IN ('total_patients', 'avg_hospital_days', 'male_patients', 'female_patients', 'a0027', 'a0329', 'a0029', 'a0030', 'a0032', 'a0034', 'a0037', 'a0040', 'a0041', 'a0043', 'a0046', 'a0049', 'a0050', 'a0052', 'a0055', 'a0058', 'a0059', 'a0061', 'a0064', 'a0067', 'a0068', 'a0070', 'a0073', 'a0076', 'a0077', 'a0079', 'a0082', 'a0085', 'a0086', 'a0088', 'a0091', 'a0094', 'a0095', 'a0097', 'a0100', 'a0103', 'a0104', 'a0106', 'a0109', 'a0112', 'a0113', 'a0115', 'a0118', 'a0121')");
            stmt.execute("DELETE FROM t_indicator WHERE metric_code LIKE '1%' OR metric_code LIKE '8%' OR metric_code LIKE '9%' OR metric_code LIKE '10%'");
            System.out.println("旧数据清理完成！");

            stmt.close();

            // 重新执行指标项SQL
            System.out.println("\n开始执行指标项SQL...");
            executeSqlFile(conn, "e:\\Code\\Claude_Job\\test001\\add-all-indicator-items.sql");
            System.out.println("指标项SQL执行完成！");

            // 重新执行指标SQL
            System.out.println("\n开始执行指标SQL...");
            executeSqlFile(conn, "e:\\Code\\Claude_Job\\test001\\add-all-indicators.sql");
            System.out.println("指标SQL执行完成！");

            // 关闭连接
            conn.close();
            System.out.println("\n所有SQL执行完成，数据库连接已关闭！");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }

    private static void executeSqlFile(Connection conn, String filePath) throws Exception {
        BufferedReader reader = new BufferedReader(
            new java.io.InputStreamReader(
                new java.io.FileInputStream(filePath),
                java.nio.charset.StandardCharsets.UTF_8
            )
        );
        StringBuilder sql = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            // 跳过注释和空行
            if (line.trim().startsWith("--") || line.trim().isEmpty() || line.trim().startsWith("USE")) {
                continue;
            }
            sql.append(line).append("\n");
        }
        reader.close();

        // 执行SQL
        Statement stmt = conn.createStatement();

        // 按分号分割SQL语句
        String[] sqlStatements = sql.toString().split(";");
        for (String sqlStmt : sqlStatements) {
            if (!sqlStmt.trim().isEmpty()) {
                try {
                    stmt.execute(sqlStmt);
                    System.out.print(".");
                } catch (Exception e) {
                    System.err.println("\n执行SQL失败: " + e.getMessage());
                }
            }
        }

        stmt.close();
        System.out.println();
    }
}
