package com.hospital.indicator.util;

import java.sql.*;

/**
 * 比较不同指标的SQL结构
 */
public class CompareIndicatorSQL {

    private static final String DB_URL = "jdbc:mysql://gz-cdb-bq7gk3k5.sql.tencentcdb.com:63606/d_hos_claude_0251230?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Yiguo9527_";

    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            Statement stmt = conn.createStatement();

            System.out.println("========================================");
            System.out.println("比较不同指标的SQL结构");
            System.out.println("========================================\n");

            // 查询几个指标的关联项
            String[] indicatorCodes = {
                "肺炎（住院、成人）次均费用",
                "急性心肌梗死次均费用",
                "急性心肌梗塞（成人）次均费用"
            };

            for (String code : indicatorCodes) {
                System.out.println("\n======== 指标: " + code + " ========");

                // 查询指标配置
                String indicatorSql = "SELECT metric_code, metric_name, related_items FROM t_indicator WHERE metric_code = ?";
                PreparedStatement pstmt = conn.prepareStatement(indicatorSql);
                pstmt.setString(1, code);
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    String relatedItems = rs.getString("related_items");
                    System.out.println("关联项: " + relatedItems);

                    // 查询关联项的SQL
                    if (relatedItems != null && !relatedItems.trim().isEmpty()) {
                        String[] itemCodes = relatedItems.split(",");
                        for (String itemCode : itemCodes) {
                            itemCode = itemCode.trim();

                            String itemSql = "SELECT item_code, item_name, query_sql FROM t_indicator_item WHERE item_code = ?";
                            PreparedStatement itemStmt = conn.prepareStatement(itemSql);
                            itemStmt.setString(1, itemCode);
                            ResultSet itemRs = itemStmt.executeQuery();

                            if (itemRs.next()) {
                                String querySql = itemRs.getString("query_sql");
                                System.out.println("\n  指标项: " + itemCode + " - " + itemRs.getString("item_name"));
                                System.out.println("  SQL: " + querySql);

                                // 测试修改后的SQL（添加GROUP BY B16）
                                String testSql = modifySqlForDeptDrill(querySql);
                                System.out.println("  修改后SQL: " + testSql);

                                // 执行修改后的SQL，看是否返回数据
                                testSql = testSql.replace("#{startDate}", "'2020-01-01'")
                                                 .replace("#{endDate}", "'2020-12-31'");

                                try {
                                    Statement testStmt = conn.createStatement();
                                    ResultSet testRs = testStmt.executeQuery(testSql);

                                    int count = 0;
                                    while (testRs.next() && count < 3) {
                                        count++;
                                        System.out.println("    B16: " + testRs.getString("dept_code") +
                                                         ", result_value: " + testRs.getBigDecimal("result_value"));
                                    }

                                    if (count == 0) {
                                        System.out.println("    ❌ 没有数据返回");
                                    } else {
                                        System.out.println("    ✅ 有数据返回 (共 " + count + "+ 条)");
                                    }

                                    testRs.close();
                                    testStmt.close();
                                } catch (Exception e) {
                                    System.out.println("    ❌ SQL执行失败: " + e.getMessage());
                                }
                            } else {
                                System.out.println("\n  ❌ 指标项不存在: " + itemCode);
                            }

                            itemRs.close();
                            itemStmt.close();
                        }
                    }
                } else {
                    System.out.println("❌ 指标不存在");
                }

                rs.close();
                pstmt.close();
            }

            stmt.close();
            conn.close();

        } catch (Exception e) {
            System.err.println("执行失败：" + e.getMessage());
            e.printStackTrace();
        }
    }

    private static String modifySqlForDeptDrill(String originalSql) {
        if (originalSql == null || originalSql.trim().isEmpty()) {
            return originalSql;
        }

        String sql = originalSql.trim();
        String upperSql = sql.toUpperCase();

        int selectIndex = upperSql.indexOf("SELECT");
        int fromIndex = upperSql.indexOf("FROM");

        if (selectIndex == -1 || fromIndex == -1) {
            return originalSql;
        }

        String selectPart = "SELECT B16 as dept_code, B16 as dept_name, ";
        String valuePart = sql.substring(selectIndex + 6, fromIndex).trim();
        String fromPart = sql.substring(fromIndex);

        String newSql = selectPart + valuePart + " " + fromPart + " GROUP BY B16";

        return newSql;
    }
}
