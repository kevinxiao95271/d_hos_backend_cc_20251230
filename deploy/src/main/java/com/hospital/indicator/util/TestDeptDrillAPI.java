package com.hospital.indicator.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.*;
import java.util.*;

/**
 * 测试所有计算类指标的科室下钻接口
 */
public class TestDeptDrillAPI {

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
            String sql = "SELECT metric_code, metric_name " +
                       "FROM t_indicator " +
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
            System.out.println("测试 " + indicators.size() + " 个指标的科室下钻接口");
            System.out.println("========================================\n");

            int successCount = 0;
            int failCount = 0;
            List<String> failedIndicators = new ArrayList<>();

            for (Map<String, String> indicator : indicators) {
                String code = indicator.get("code");
                String name = indicator.get("name");

                System.out.println("测试: " + name);

                try {
                    // 调用科室下钻API
                    String encodedCode = URLEncoder.encode(code, "UTF-8");
                    String apiUrl = API_BASE_URL + "/" + encodedCode +
                                  "?timeDimension=YEAR&timeValue=2023";

                    URL url = new URL(apiUrl);
                    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                    connection.setRequestMethod("GET");
                    connection.setConnectTimeout(10000);
                    connection.setReadTimeout(10000);

                    int responseCode = connection.getResponseCode();

                    BufferedReader in;
                    if (responseCode >= 400) {
                        in = new BufferedReader(
                            new InputStreamReader(connection.getErrorStream(), "UTF-8"));
                    } else {
                        in = new BufferedReader(
                            new InputStreamReader(connection.getInputStream(), "UTF-8"));
                    }

                    String inputLine;
                    StringBuilder response = new StringBuilder();
                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    String responseBody = response.toString();

                    if (responseCode == 200 && responseBody.contains("\"code\":200")) {
                        System.out.println("  ✓ 成功 (200)");
                        successCount++;
                    } else if (responseCode == 500 || responseBody.contains("\"code\":500")) {
                        System.out.println("  ✗ 失败 (500)");
                        System.out.println("  响应: " + responseBody.substring(0, Math.min(300, responseBody.length())));
                        failCount++;
                        failedIndicators.add(name + " (" + code + ")");
                    } else {
                        System.out.println("  ? 未知状态 (" + responseCode + ")");
                        System.out.println("  响应: " + responseBody.substring(0, Math.min(200, responseBody.length())));
                    }

                } catch (Exception e) {
                    System.out.println("  ✗ 异常: " + e.getMessage());
                    failCount++;
                    failedIndicators.add(name + " (" + code + ") - " + e.getMessage());
                }

                System.out.println();

                // 避免请求过快
                Thread.sleep(50);
            }

            rs.close();
            stmt.close();
            conn.close();

            System.out.println("\n========================================");
            System.out.println("科室下钻测试结果汇总");
            System.out.println("========================================");
            System.out.println("总数: " + indicators.size());
            System.out.println("成功: " + successCount + " ✓");
            System.out.println("失败: " + failCount + " ✗");
            System.out.println("成功率: " + String.format("%.1f%%", (successCount * 100.0 / indicators.size())));

            if (!failedIndicators.isEmpty()) {
                System.out.println("\n失败的指标列表：");
                System.out.println("========================================");
                for (String failed : failedIndicators) {
                    System.out.println("  - " + failed);
                }
            } else {
                System.out.println("\n✅ 所有指标的科室下钻接口均正常！");
            }

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
