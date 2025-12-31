package com.hospital.indicator.util;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

/**
 * 数据库初始化器
 * 应用启动时自动执行SQL脚本
 *
 * @author Claude
 * @date 2025-12-30
 */
@Slf4j
@Component
public class DatabaseInitializer implements CommandLineRunner {

    @Autowired(required = false)
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        if (jdbcTemplate == null) {
            log.warn("JdbcTemplate未注入，跳过数据库初始化");
            return;
        }

        try {
            // 检查表是否存在
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'd_hos_claude_0251230' AND table_name = 't_indicator_item'",
                    Integer.class
            );

            if (count != null && count > 0) {
                log.info("数据库表已存在，跳过初始化");
                return;
            }

            log.info("开始初始化数据库表结构...");
            executeSqlFile("init-schema-simple.sql");
            log.info("数据库表结构初始化完成！");

        } catch (Exception e) {
            log.error("数据库初始化失败", e);
        }
    }

    private void executeSqlFile(String fileName) throws Exception {
        ClassPathResource resource = new ClassPathResource(fileName);
        if (!resource.exists()) {
            log.warn("SQL文件不存在: {}", fileName);
            return;
        }

        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8))) {

            StringBuilder sqlBuilder = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                // 跳过注释和空行
                line = line.trim();
                if (line.isEmpty() || line.startsWith("--") || line.startsWith("//")) {
                    continue;
                }

                sqlBuilder.append(line).append(" ");

                // 遇到分号执行SQL
                if (line.endsWith(";")) {
                    String sql = sqlBuilder.toString().trim();
                    if (!sql.isEmpty() && !sql.startsWith("USE")) {
                        try {
                            jdbcTemplate.execute(sql);
                            log.debug("执行SQL: {}", sql.substring(0, Math.min(100, sql.length())));
                        } catch (Exception e) {
                            log.warn("SQL执行失败: {}, 错误: {}", sql.substring(0, Math.min(100, sql.length())), e.getMessage());
                        }
                    }
                    sqlBuilder.setLength(0);
                }
            }
        }
    }

}
