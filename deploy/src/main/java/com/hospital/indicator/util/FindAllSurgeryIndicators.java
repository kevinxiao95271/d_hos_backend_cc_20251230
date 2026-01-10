package com.hospital.indicator.util;

import java.sql.*;
import java.util.*;

/**
 * 查找所有使用手术编码但查询了诊断字段的指标项
 */
public class FindAllSurgeryIndicators {

    private static final String URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USER = "root";
    private static final String PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("========================================");
            System.out.println("查找所有手术类指标项SQL配置问题");
            System.out.println("========================================\n");

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");
            
            // 查找所有指标项
            String sql = "SELECT item_code, item_name, query_sql FROM t_indicator_item ORDER BY item_code";
            ResultSet rs = stmt.executeQuery(sql);
            
            List<Map<String, String>> problemItems = new ArrayList<>();
            
            while (rs.next()) {
                String itemCode = rs.getString("item_code");
                String itemName = rs.getString("item_name");
                String querySql = rs.getString("query_sql");
                
                // 检查是否包含手术编码（简单方法：包含两位数点数的模式）
                boolean hasSurgeryCode = (querySql.contains("81.") || querySql.contains("74.") || 
                                         querySql.contains("36.") || querySql.contains("80."));
                
                // 检查是否使用了诊断字段
                boolean useDiagnosisField = querySql.contains("C03C") || querySql.contains("C06x");
                
                // 如果既有手术编码又使用诊断字段，说明有问题
                if (hasSurgeryCode && useDiagnosisField) {
                    Map<String, String> item = new HashMap<>();
                    item.put("code", itemCode);
                    item.put("name", itemName);
                    item.put("sql", querySql);
                    problemItems.add(item);
                }
            }
            rs.close();
            
            System.out.println("【发现的问题指标项】\n");
            System.out.println("共找到 " + problemItems.size() + " 个使用诊断字段查询手术编码的指标项:\n");
            
            for (int i = 0; i < problemItems.size(); i++) {
                Map<String, String> item = problemItems.get(i);
                System.out.println((i + 1) + ". " + item.get("code") + " - " + item.get("name"));
                System.out.println();
            }
            
            // 按类别分组显示
            System.out.println("\n【按指标类别分组】\n");
            Map<String, List<String>> grouped = new LinkedHashMap<>();
            
            for (Map<String, String> item : problemItems) {
                String name = item.get("name");
                String category = extractCategory(name);
                
                if (!grouped.containsKey(category)) {
                    grouped.put(category, new ArrayList<>());
                }
                grouped.get(category).add(item.get("code"));
            }
            
            for (Map.Entry<String, List<String>> entry : grouped.entrySet()) {
                System.out.println("【" + entry.getKey() + "】 (" + entry.getValue().size() + "个)");
                System.out.println("  指标项: " + String.join(", ", entry.getValue()));
                System.out.println();
            }

            stmt.close();
            conn.close();
            
            System.out.println("========================================");
            System.out.println("需要修复的指标项总数: " + problemItems.size());
            System.out.println("========================================");

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static String extractCategory(String name) {
        if (name.contains("髋关节")) return "髋关节置换术";
        if (name.contains("膝关节")) return "膝关节置换术";
        if (name.contains("冠状动脉") || name.contains("CABG")) return "冠状动脉旁路移植术";
        if (name.contains("剖宫产")) return "剖宫产";
        return "其他";
    }
}
