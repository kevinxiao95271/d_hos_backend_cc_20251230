package com.hospital.indicator.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.*;

/**
 * Test all Average LOS indicators from database
 */
public class TestAllAvgLOS {

    private static final String DB_URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            Statement stmt = conn.createStatement();

            String sql = "SELECT metric_code, metric_name FROM t_indicator WHERE status = 1 AND metric_name LIKE '%平均住院日%' ORDER BY metric_code";

            ResultSet rs = stmt.executeQuery(sql);

            System.out.println("========================================");
            System.out.println("Testing All Average LOS Indicators");
            System.out.println("========================================\n");

            int totalCount = 0;
            int successCount = 0;
            int failCount = 0;

            while (rs.next()) {
                totalCount++;
                String code = rs.getString("metric_code");
                String name = rs.getString("metric_name");

                System.out.println("\n[" + totalCount + "] " + name + " (" + code + ")");

                int deptCount = testIndicator(code);

                if (deptCount > 0) {
                    successCount++;
                    System.out.println("    Result: SUCCESS - " + deptCount + " departments");
                } else {
                    failCount++;
                    System.out.println("    Result: FAILED - No data");
                }
            }
            rs.close();

            System.out.println("\n========================================");
            System.out.println("Summary:");
            System.out.println("  Total: " + totalCount);
            System.out.println("  Success: " + successCount);
            System.out.println("  Failed: " + failCount);
            System.out.println("========================================");

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("Failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static int testIndicator(String metricCode) {
        try {
            String urlStr = "http://localhost:8080/dgear/api/indicator-result/dept-drill-down";
            URL url = new URL(urlStr);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
            conn.setDoOutput(true);

            String params = "metricCode=" + URLEncoder.encode(metricCode, "UTF-8") +
                           "&timeDimension=YEAR" +
                           "&startDate=2020-01-01" +
                           "&endDate=2020-12-31";

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = params.getBytes("UTF-8");
                os.write(input, 0, input.length);
            }

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String inputLine;
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // Parse JSON to extract dept count
            String responseStr = response.toString();
            if (responseStr.contains("\"data\":[")) {
                int dataStart = responseStr.indexOf("\"data\":[") + 8;
                int dataEnd = responseStr.indexOf("]", dataStart);
                String dataSection = responseStr.substring(dataStart, dataEnd);

                int deptCount = 0;
                int idx = 0;
                while ((idx = dataSection.indexOf("\"deptCode\":", idx)) != -1) {
                    deptCount++;
                    idx += 11;
                }

                return deptCount;
            }

            return 0;

        } catch (Exception e) {
            System.err.println("    Error: " + e.getMessage());
            return 0;
        }
    }
}
