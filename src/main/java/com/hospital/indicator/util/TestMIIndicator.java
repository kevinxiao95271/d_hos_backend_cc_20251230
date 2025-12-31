package com.hospital.indicator.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

/**
 * Test dept drill-down API for MI indicator
 */
public class TestMIIndicator {

    public static void main(String[] args) {
        try {
            String urlStr = "http://localhost:8080/dgear/api/indicator-result/dept-drill-down";
            URL url = new URL(urlStr);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
            conn.setDoOutput(true);

            String params = "metricCode=" + URLEncoder.encode("急性心肌梗死次均费用", "UTF-8") +
                           "&timeDimension=YEAR" +
                           "&startDate=2020-01-01" +
                           "&endDate=2020-12-31";

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = params.getBytes("UTF-8");
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            System.out.println("Response Code: " + responseCode);

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String inputLine;
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            System.out.println("Response Body:");
            System.out.println(response.toString());

        } catch (Exception e) {
            System.err.println("Failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
