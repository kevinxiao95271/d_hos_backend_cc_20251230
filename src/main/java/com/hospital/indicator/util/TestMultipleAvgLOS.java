package com.hospital.indicator.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

/**
 * Test multiple Average LOS indicators
 */
public class TestMultipleAvgLOS {

    public static void main(String[] args) {
        String[] indicators = {
            "肺炎（住院、成人）平均住院日",
            "心力衰竭平均住院日",
            "脑梗死平均住院日"
        };

        for (String indicator : indicators) {
            System.out.println("\n========================================");
            System.out.println("Testing: " + indicator);
            System.out.println("========================================");

            testIndicator(indicator);
        }
    }

    private static void testIndicator(String metricCode) {
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

            int responseCode = conn.getResponseCode();

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

                System.out.println("Response Code: " + responseCode);
                System.out.println("Department Count: " + deptCount);

                if (deptCount > 0) {
                    System.out.println("Status: SUCCESS - Has dept drill-down data");
                } else {
                    System.out.println("Status: FAILED - No dept drill-down data");
                }
            }

        } catch (Exception e) {
            System.err.println("Failed: " + e.getMessage());
        }
    }
}
