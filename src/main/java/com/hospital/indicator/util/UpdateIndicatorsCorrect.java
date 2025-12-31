package com.hospital.indicator.util;

import java.io.BufferedReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

/**
 * 更新指标为正确的表达式（不带*100）
 */
public class UpdateIndicatorsCorrect {

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

            // 执行更新SQL
            System.out.println("\n开始执行指标更新SQL...");
            executeSqlFile(conn, "e:\\Code\\Claude_Job\\test001\\update-indicators-correct.sql");
            System.out.println("指标更新SQL执行完成！");

            stmt.close();
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
                    System.err.println("SQL语句: " + sqlStmt.substring(0, Math.min(200, sqlStmt.length())));
                }
            }
        }

        stmt.close();
        System.out.println();
    }
}
