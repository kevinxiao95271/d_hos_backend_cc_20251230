package com.hospital.indicator.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * 测试批量计算接口
 */
public class TestBatchCalculate {

    private static final String API_URL = "http://localhost:8080/dgear/api/indicator-result/batch-calculate?timeDimension=YEAR&startDate=2023-01-01&endDate=2023-12-31";

    public static void main(String[] args) {
        try {
            System.out.println("========================================");
            System.out.println("测试批量计算接口");
            System.out.println("========================================\n");

            // 测试1：病死率指标（会触发整数除零）
            String[] testCases = {
                "[\"髋关节置换术病死率\"]",
                "[\"膝关节置换术病死率\"]",
                "[\"冠状动脉旁路移植术病死率\"]",
                "[\"髋关节置换术病死率\",\"膝关节置换术病死率\",\"冠状动脉旁路移植术病死率\"]",
                "[\"髋关节置换术平均住院日\",\"髋关节置换术次均费用\",\"髋关节置换术病死率\"]"
            };

            int successCount = 0;
            int failCount = 0;

            for (int i = 0; i < testCases.length; i++) {
                String jsonBody = testCases[i];
                System.out.println("测试案例 " + (i + 1) + ":");
                System.out.println("  请求体: " + jsonBody);

                try {
                    URL url = new URL(API_URL);
                    HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                    connection.setRequestMethod("POST");
                    connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
                    connection.setDoOutput(true);
                    connection.setConnectTimeout(30000);
                    connection.setReadTimeout(30000);

                    // 发送请求体
                    try (OutputStream os = connection.getOutputStream()) {
                        byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                        os.write(input, 0, input.length);
                    }

                    int responseCode = connection.getResponseCode();

                    BufferedReader in;
                    if (responseCode >= 400) {
                        in = new BufferedReader(
                            new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8));
                    } else {
                        in = new BufferedReader(
                            new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8));
                    }

                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = in.readLine()) != null) {
                        response.append(line);
                    }
                    in.close();

                    String responseBody = response.toString();

                    if (responseCode == 200 && responseBody.contains("\"code\":200")) {
                        System.out.println("  ✓ 成功 (200)");
                        successCount++;

                        // 检查返回的数据中是否包含计算结果
                        if (responseBody.contains("\"resultValue\"")) {
                            System.out.println("  包含计算结果");
                        }
                    } else {
                        System.out.println("  ✗ 失败 (" + responseCode + ")");
                        System.out.println("  响应: " + responseBody.substring(0, Math.min(500, responseBody.length())));
                        failCount++;
                    }

                } catch (Exception e) {
                    System.out.println("  ✗ 异常: " + e.getMessage());
                    e.printStackTrace();
                    failCount++;
                }

                System.out.println();
                Thread.sleep(500);
            }

            System.out.println("========================================");
            System.out.println("批量计算测试结果");
            System.out.println("========================================");
            System.out.println("总数: " + testCases.length);
            System.out.println("成功: " + successCount + " ✓");
            System.out.println("失败: " + failCount + " ✗");

            if (failCount == 0) {
                System.out.println("\n✅ 批量计算接口全部正常！");
            }

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}
