# Swagger中文乱码问题修复说明

## 问题描述

Swagger UI页面显示中文时出现乱码，原因是数据库存储的数据编码不正确。

## 解决方案

### 1. 添加HTTP编码配置

在 `application.yml` 中添加：

```yaml
spring:
  http:
    encoding:
      charset: UTF-8
      enabled: true
      force: true
```

### 2. 添加WebMvcConfig配置类

创建 [WebMvcConfig.java](src/main/java/com/hospital/indicator/config/WebMvcConfig.java):

```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        StringHttpMessageConverter stringConverter = new StringHttpMessageConverter(StandardCharsets.UTF_8);
        converters.add(0, stringConverter);
    }
}
```

### 3. 重新导入数据（使用UTF-8编码）

使用 [SqlExecutorUTF8.java](src/main/java/com/hospital/indicator/util/SqlExecutorUTF8.java) 重新导入数据：

```bash
mvn compile exec:java -Dexec.mainClass="com.hospital.indicator.util.SqlExecutorUTF8"
```

关键改进：
- 数据库连接URL添加：`characterEncoding=UTF-8`
- 执行SQL前设置：`SET NAMES utf8mb4`
- 使用UTF-8读取SQL文件

## 修复结果

✅ API返回的JSON中，中文字段正常显示：

```json
{
  "itemCode": "total_patients",
  "itemName": "总患者数",
  "unit": "人"
}
```

✅ Swagger UI页面中文正常显示

## 验证方法

1. 访问API接口：
```bash
curl http://localhost:8080/dgear/api/indicator-item/list
```

2. 访问Swagger UI：
```
http://localhost:8080/dgear/swagger-ui.html
```

3. 检查指标项名称是否显示为中文而非乱码

## 注意事项

- 确保数据库表使用 `utf8mb4` 字符集
- 确保JDBC连接URL包含 `characterEncoding=UTF-8`
- 重启应用后生效

---

**修复时间**: 2025-12-31
**状态**: ✅ 已修复
