package com.hospital.indicator.util;

import java.sql.*;

/**
 * 检查指标使用的表和字段
 */
public class CheckIndicatorTable {

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
            System.out.println("检查 肺炎(住院、成人)次均费用 指标");
            System.out.println("========================================\n");

            // 1. 查询指标配置
            String sql1 = "SELECT metric_code, metric_name, related_items, expression FROM t_indicator WHERE metric_name = '肺炎(住院、成人)次均费用'";
            ResultSet rs1 = stmt.executeQuery(sql1);

            String relatedItems = null;
            if (rs1.next()) {
                System.out.println("指标配置:");
                System.out.println("  metric_code: " + rs1.getString("metric_code"));
                System.out.println("  metric_name: " + rs1.getString("metric_name"));
                relatedItems = rs1.getString("related_items");
                System.out.println("  related_items: " + relatedItems);
                System.out.println("  expression: " + rs1.getString("expression"));
            }
            rs1.close();

            if (relatedItems != null) {
                // 提取item codes
                relatedItems = relatedItems.replace("[", "").replace("]", "").replace("\"", "");
                String[] itemCodes = relatedItems.split(",");

                System.out.println("\n指标项详情:");
                for (String itemCode : itemCodes) {
                    String sql2 = "SELECT item_code, item_name, query_sql FROM t_indicator_item WHERE item_code = '" + itemCode.trim() + "'";
                    ResultSet rs2 = stmt.executeQuery(sql2);

                    if (rs2.next()) {
                        String querySql = rs2.getString("query_sql");
                        System.out.println("\n  ----------------------------------------");
                        System.out.println("  item_code: " + rs2.getString("item_code"));
                        System.out.println("  item_name: " + rs2.getString("item_name"));
                        System.out.println("  query_sql: " + querySql);

                        // 分析SQL中使用的表
                        if (querySql != null) {
                            if (querySql.toUpperCase().contains("FROM")) {
                                String fromPart = querySql.substring(querySql.toUpperCase().indexOf("FROM"));
                                System.out.println("\n  使用的表: " + extractTableName(fromPart));
                            }
                        }
                    }
                    rs2.close();
                }

                // 检查第一个item使用的表是否有B16字段
                System.out.println("\n\n========================================");
                System.out.println("检查表字段");
                System.out.println("========================================\n");

                String sql3 = "SELECT item_code, query_sql FROM t_indicator_item WHERE item_code = '" + itemCodes[0].trim() + "'";
                ResultSet rs3 = stmt.executeQuery(sql3);

                if (rs3.next()) {
                    String querySql = rs3.getString("query_sql");
                    String tableName = extractTableName(querySql);

                    System.out.println("检查表 " + tableName + " 是否有 B16 字段:\n");

                    try {
                        String sql4 = "SHOW COLUMNS FROM " + tableName + " LIKE 'B16'";
                        ResultSet rs4 = stmt.executeQuery(sql4);

                        if (rs4.next()) {
                            System.out.println("✓ 表 " + tableName + " 有 B16 字段");
                            System.out.println("  字段类型: " + rs4.getString("Type"));
                        } else {
                            System.out.println("✗ 表 " + tableName + " 没有 B16 字段");

                            // 查找所有包含"科室"或"dept"的字段
                            System.out.println("\n查找可能的科室字段:");
                            String sql5 = "SHOW FULL COLUMNS FROM " + tableName + " WHERE Field LIKE '%16%' OR Field LIKE '%dept%' OR Field LIKE '%DEPT%'";
                            ResultSet rs5 = stmt.executeQuery(sql5);

                            System.out.println("字段名\t类型\t\t注释");
                            System.out.println("----------------------------------------");
                            while (rs5.next()) {
                                System.out.println(rs5.getString("Field") + "\t" + rs5.getString("Type") + "\t" + (rs5.getString("Comment") != null ? rs5.getString("Comment") : ""));
                            }
                            rs5.close();
                        }
                        rs4.close();
                    } catch (Exception e) {
                        System.out.println("查询失败: " + e.getMessage());
                    }
                }
                rs3.close();
            }

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }

    private static String extractTableName(String sql) {
        // 简单提取FROM后面的表名
        String upper = sql.toUpperCase();
        int fromIndex = upper.indexOf("FROM");
        if (fromIndex == -1) return "未知";

        String afterFrom = sql.substring(fromIndex + 4).trim();
        int spaceIndex = afterFrom.indexOf(" ");
        int whereIndex = afterFrom.toUpperCase().indexOf("WHERE");

        int endIndex = -1;
        if (spaceIndex != -1 && whereIndex != -1) {
            endIndex = Math.min(spaceIndex, whereIndex);
        } else if (spaceIndex != -1) {
            endIndex = spaceIndex;
        } else if (whereIndex != -1) {
            endIndex = whereIndex;
        }

        if (endIndex != -1) {
            return afterFrom.substring(0, endIndex).trim();
        }

        return afterFrom.trim();
    }
}
