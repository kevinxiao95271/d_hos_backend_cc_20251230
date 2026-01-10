package com.hospital.indicator;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 医疗指标管理系统 - 启动类
 *
 * @author Claude
 * @date 2025-12-30
 */
@SpringBootApplication
@MapperScan("com.hospital.indicator.mapper")
public class IndicatorManagementApplication {

    public static void main(String[] args) {
        SpringApplication.run(IndicatorManagementApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("医疗指标管理系统启动成功！");
        System.out.println("Swagger UI: http://localhost:8080/dgear/swagger-ui.html");
        System.out.println("Druid 监控: http://localhost:8080/dgear/druid/");
        System.out.println("========================================\n");
    }

}
