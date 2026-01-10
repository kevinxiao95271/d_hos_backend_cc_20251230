package com.hospital.indicator.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Swagger3 配置类
 *
 * @author Claude
 * @date 2025-12-30
 */
@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("医疗指标管理系统 API")
                        .version("1.0.0")
                        .description("医疗指标管理系统后端接口文档，包括指标项管理、指标管理、指标计算、结果查询等功能")
                        .contact(new Contact()
                                .name("开发团队")
                                .email("dev@hospital.com"))
                        .license(new License()
                                .name("Apache 2.0")
                                .url("https://www.apache.org/licenses/LICENSE-2.0.html")));
    }

}
