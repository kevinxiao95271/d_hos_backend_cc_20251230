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
                        .title("医院绩效指标管理系统 API")
                        .version("2.0.0")
                        .description("医院绩效指标管理系统后端接口文档。\n\n" +
                                "**功能模块**：\n" +
                                "- 身份认证（JWT）\n" +
                                "- 系统全局配置（院名、报告标题等）\n" +
                                "- 指标管理 & 指标项管理\n" +
                                "- 指标自动计算 & 结果查询（含科室下钻）\n" +
                                "- 绩效指标监测报告（JSON 预览 + Word 导出）\n" +
                                "- 手工填报：配置 → 任务 → 数据录入 → 审核\n" +
                                "- 科室管理、用户管理、指标可见范围配置\n\n" +
                                "**认证方式**：请求 Header 携带 `Authorization: Bearer {token}`\n\n" +
                                "**统一响应**：`{ code, message, data, timestamp }`，code=200 表示成功")
                        .contact(new Contact()
                                .name("开发团队")
                                .email("dev@hospital.com"))
                        .license(new License()
                                .name("Apache 2.0")
                                .url("https://www.apache.org/licenses/LICENSE-2.0.html")));
    }

}
