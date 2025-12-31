package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查d_mr表中的手术编码字段
 */
public class CheckOperationFields {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("检查d_mr表中包含OP的字段:\n");

            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("DESCRIBE d_mr");
            
            int count = 0;
            while (rs.next()) {
                String field = rs.getString("Field");
                if (field.contains("OP") || field.contains("op")) {
                    count++;
                    String type = rs.getString("Type");
                    System.out.println(count + ". " + field + " (" + type + ")");
                }
            }
            rs.close();
            
            if (count == 0) {
                System.out.println("未找到包含OP的字段，列出所有字段:");
                rs = stmt.executeQuery("DESCRIBE d_mr");
                count = 0;
                while (rs.next()) {
                    count++;
                    String field = rs.getString("Field");
                    String type = rs.getString("Type");
                    System.out.println(count + ". " + field + " (" + type + ")");
                    if (count >= 50) {
                        System.out.println("... (仅显示前50个字段)");
                        break;
                    }
                }
                rs.close();
            }
            
            // 查看髋关节指标项的实际SQL
            System.out.println("\n\n髋关节置换术指标项a0077的SQL:");
            rs = stmt.executeQuery("SELECT query_sql FROM t_indicator_item WHERE item_code = 'a0077'");
            if (rs.next()) {
                System.out.println(rs.getString("query_sql"));
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
