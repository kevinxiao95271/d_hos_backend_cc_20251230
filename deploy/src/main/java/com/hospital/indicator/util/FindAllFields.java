package com.hospital.indicator.util;

import java.sql.*;

/**
 * 查找d_mr表的所有字段
 */
public class FindAllFields {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("d_mr表的所有字段:\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");
            ResultSet rs = stmt.executeQuery("DESCRIBE d_mr");
            
            int count = 0;
            while (rs.next()) {
                count++;
                String field = rs.getString("Field");
                String type = rs.getString("Type");
                System.out.println(String.format("%3d. %-15s %s", count, field, type));
            }
            rs.close();
            
            System.out.println("\n共 " + count + " 个字段");
            
            // 查询一条2023年的数据，查看手术相关字段的值
            System.out.println("\n\n查看2023年数据样例（查找可能的手术字段）:");
            rs = stmt.executeQuery(
                "SELECT * FROM d_mr " +
                "WHERE YEAR(STR_TO_DATE(B15, '%Y/%m/%d')) = 2023 " +
                "LIMIT 1"
            );
            
            if (rs.next()) {
                ResultSetMetaData meta = rs.getMetaData();
                int colCount = meta.getColumnCount();
                
                System.out.println("\n所有字段及值:");
                for (int i = 1; i <= colCount; i++) {
                    String colName = meta.getColumnName(i);
                    String value = rs.getString(i);
                    if (value != null && !value.isEmpty()) {
                        System.out.println(String.format("%-15s = %s", colName, 
                            value.length() > 50 ? value.substring(0, 50) + "..." : value));
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
