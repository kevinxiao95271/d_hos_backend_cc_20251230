package com.hospital.indicator.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

/**
 * SQL执行工具类
 */
public class SqlExecutor {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useSSL=false&serverTimezone=Asia/Shanghai&allowMultiQueries=true";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            // 加载驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 获取连接
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功！");

            // 执行指标项SQL
            System.out.println("\n开始执行指标项SQL...");
            executeSqlFile(conn, "e:\\Code\\Claude_Job\\test001\\add-all-indicator-items.sql");
            System.out.println("指标项SQL执行完成！");

            // 执行指标SQL
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
        BufferedReader reader = new BufferedReader(new FileReader(filePath));
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
