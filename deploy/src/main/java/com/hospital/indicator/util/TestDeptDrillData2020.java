package com.hospital.indicator.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.*;
import java.util.*;

/**
 * 测试2020年数据哪些指标有科室下钻数据
 */
public class TestDeptDrillData2020 {

    private static final String DB_URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Yiguo9527_";
    private static final String API_BASE_URL = "http://localhost:8080/dgear/api/indicator-result/dept-drill";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            Statement stmt = conn.createStatement();
            stmt.execute("SET NAMES utf8mb4");

            // 查询所有包含除法的计算类指标
            String sql = "SELECT metric_code, metric_name FROM t_indicator " +
                       "WHERE expression LIKE '%/%' AND expression IS NOT NULL " +
                       "ORDER BY metric_code";

            ResultSet rs = stmt.executeQuery(sql);

            List<Map<String, String>> indicators = new ArrayList<>();
            while (rs.next()) {
                Map<String, String> indicator = new HashMap<>();
                indicator.put("code", rs.getString("metric_code"));
                indicator.put("name", rs.getString("metric_name"));
                indicators.add(indicator);
            }

            System.out.println("========================================");
            System.out.println("测试2020年科室下钻数据");
            System.out.println("共 " + indicators.size() + " 个计算类指标");
            System.out.println("========================================\n");

            List<String> hasDataIndicators = new ArrayList<>();
            List<String> noDataIndicators = new ArrayList<>();

            for (Map<String, String> indicator : indicators) {
                String code = indicator.get("code");
                String name = indicator.get("name");

                try {
                    // 调用API查询科室下钻数据
                    String encodedCode = URLEncoder.encode(code, "UTF-8");
                    String apiUrl = API_BASE_URL + "/" + encodedCode +
                                  "?timeDimension=YEAR&timeValue=2020";

                    URL url = new URL(apiUrl);
                    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                    connection.setRequestMethod("GET");
                    connection.setConnectTimeout(10000);
                    connection.setReadTimeout(10000);

                    int responseCode = connection.getResponseCode();

                    BufferedReader in = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), "UTF-8"));
                    String inputLine;
                    StringBuilder response = new StringBuilder();
                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    String responseBody = response.toString();

                    if (responseCode == 200 && responseBody.contains("\"code\":200")) {
                        // 检查是否有数据
                        if (responseBody.contains("\"data\":[]")) {
                            noDataIndicators.add(name + " (" + code + ")");
                        } else if (responseBody.contains("\"data\":[")) {
                            hasDataIndicators.add(name + " (" + code + ")");
                            System.out.println("✓ " + name);

                            // 简单统计数据量
                            int count = responseBody.split("\"deptCode\":").length - 1;
                            System.out.println("  科室数: " + count);
                        } else {
                            noDataIndicators.add(name + " (" + code + ")");
                        }
                    } else {
                        System.out.println("✗ " + name + " - API调用失败");
                    }

                } catch (Exception e) {
                    System.out.println("✗ " + name + " - 异常: " + e.getMessage());
                }

                Thread.sleep(50);
            }

            rs.close();
            stmt.close();
            conn.close();

            System.out.println("\n========================================");
            System.out.println("2020年科室下钻数据统计");
            System.out.println("========================================");
            System.out.println("有数据: " + hasDataIndicators.size() + " 个");
            System.out.println("无数据: " + noDataIndicators.size() + " 个");

            if (!hasDataIndicators.isEmpty()) {
                System.out.println("\n【有科室下钻数据的指标】:");
                System.out.println("========================================");
                for (String indicator : hasDataIndicators) {
                    System.out.println("  - " + indicator);
                }
            }

            if (!noDataIndicators.isEmpty()) {
                System.out.println("\n【无科室下钻数据的指标】:");
                System.out.println("========================================");
                for (String indicator : noDataIndicators) {
                    System.out.println("  - " + indicator);
                }
            }

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
