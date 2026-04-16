# 快速开始指南

## 步骤1：初始化数据库

### 1.1 创建数据库表结构
```bash
# 使用MySQL客户端连接数据库
# 注意：如果你的环境中没有mysql命令，可以使用其他数据库工具（如Navicat、DBeaver等）执行SQL文件

# 方式1：命令行执行
mysql -h gz-cdb-bq7gk3k5.sql.tencentcdb.com -P 63606 -u root -pYiguo9527_ d_hos_claude_0251230 < schema.sql

# 方式2：使用数据库工具
# 打开 schema.sql 文件，在数据库工具中执行
```

### 1.2 初始化测试数据
```bash
# 执行测试数据初始化脚本
mysql -h gz-cdb-bq7gk3k5.sql.tencentcdb.com -P 63606 -u root -pYiguo9527_ d_hos_claude_0251230 < test-data.sql
```

## 步骤2：启动应用

### 2.1 使用Maven启动
```bash
# 确保已安装 JDK 1.8+ 和 Maven 3.6+
cd e:\Code\Claude_Job\test001
mvn clean install
mvn spring-boot:run
```

### 2.2 使用IDE启动
1. 用IDEA或Eclipse导入项目
2. 等待Maven依赖下载完成
3. 运行 `IndicatorManagementApplication.java` 主类

### 2.3 验证启动成功
看到以下输出表示启动成功：
```
========================================
医疗指标管理系统启动成功！
Swagger UI: http://localhost:8080/dgear/swagger-ui.html
Druid 监控: http://localhost:8080/dgear/druid/
========================================
```

## 步骤3：访问Swagger接口文档

打开浏览器访问：http://localhost:8080/dgear/swagger-ui.html

你将看到三个主要的API模块：
1. **指标项管理** - 配置基础数据采集SQL
2. **指标管理** - 配置指标计算表达式
3. **指标计算与结果查询** - 执行计算和查看结果

## 步骤4：快速测试功能

### 4.1 测试指标项查询
在Swagger界面中：

1. 找到 `指标项管理` -> `POST /api/indicator-item/{code}/execute`
2. 输入参数：
   - `code`: a0050
   - `startDate`: 2025-01-01
   - `endDate`: 2025-01-31
3. 点击 `Execute` 执行

**预期结果**：
```json
{
  "code": 200,
  "message": "执行指标项查询成功",
  "data": {
    "success": true,
    "result": {
      "result_value": 123,
      "item_code": "a0050",
      "item_name": "肺炎（住院、成人）病种例数",
      "unit": "人"
    },
    "querySql": "SELECT COUNT(*) as result_value FROM D_MR WHERE ..."
  }
}
```

### 4.2 查看指标树形结构
1. 找到 `指标管理` -> `GET /api/indicator/tree`
2. 点击 `Execute` 执行

**预期结果**：
```json
{
  "code": 200,
  "message": "操作成功",
  "data": [
    {
      "metricCode": "10",
      "metricName": "重点病种质量控制指标",
      "children": [
        {
          "metricCode": "10.3",
          "metricName": "肺炎（住院、成人）",
          "children": [
            {
              "metricCode": "10.3.1",
              "metricName": "肺炎（住院、成人）病种例数",
              "isLeaf": 1
            },
            {
              "metricCode": "10.3.2",
              "metricName": "肺炎（住院、成人）平均住院日",
              "isLeaf": 1
            }
          ]
        }
      ]
    }
  ]
}
```

### 4.3 执行指标计算
1. 找到 `指标计算与结果查询` -> `POST /api/indicator-result/calculate`
2. 输入参数：
   - `metricCode`: 10.3.2
   - `timeDimension`: MONTH
   - `startDate`: 2025-01-01
   - `endDate`: 2025-01-31
3. 点击 `Execute` 执行

**预期结果**：
```json
{
  "code": 200,
  "message": "指标计算成功",
  "data": {
    "metricCode": "10.3.2",
    "timeDimension": "MONTH",
    "timeValue": "2025-01",
    "resultValue": 8.5000,
    "resultJson": "{...}",
    "calculationStatus": "SUCCESS"
  }
}
```

### 4.4 批量计算指标
1. 找到 `指标计算与结果查询` -> `POST /api/indicator-result/batch-calculate`
2. 输入参数：
   - `metricCodes`: 留空（计算所有叶子指标）
   - `timeDimension`: MONTH
   - `startDate`: 2025-01-01
   - `endDate`: 2025-03-31
3. 点击 `Execute` 执行

系统会自动拆分为3个月，每个月计算所有叶子指标。

### 4.5 查询计算结果
1. 找到 `指标计算与结果查询` -> `GET /api/indicator-result/list`
2. 输入参数：
   - `metricCode`: 10.3.2
   - `timeDimension`: MONTH
3. 点击 `Execute` 执行

## 步骤5：添加自己的指标

### 5.1 添加指标项
使用 `POST /api/indicator-item/save` 接口：

```json
{
  "itemCode": "a0100",
  "itemName": "住院总人数",
  "itemType": "COLLECTED",
  "dataSource": "D_MR",
  "querySql": "SELECT COUNT(*) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate}",
  "aggregateFunction": "COUNT",
  "aggregateField": "*",
  "unit": "人",
  "status": 1,
  "sortOrder": 100
}
```

### 5.2 添加指标
使用 `POST /api/indicator/save` 接口：

```json
{
  "metricCode": "11.1",
  "metricName": "住院率",
  "parentCode": "11",
  "isLeaf": 1,
  "metricType": "QUANTITATIVE",
  "calculationType": "EXPRESSION",
  "expression": "a0100/a0050*100",
  "unit": "%",
  "status": 1,
  "sortOrder": 111
}
```

## 常见问题

### Q1: 启动失败，提示数据库连接错误
**A**: 检查 `application.yml` 中的数据库配置是否正确，确保可以连接到腾讯云MySQL。

### Q2: 计算结果为0或异常
**A**:
1. 检查 d_mr 表中是否有对应时间范围的数据
2. 使用 `/execute` 接口测试指标项的SQL是否正确
3. 查看日志中的实际执行SQL

### Q3: 表达式校验失败
**A**: 确保表达式格式正确，支持的格式包括：
- 单个指标项：`a0050`
- 四则运算：`a0052/a0050`
- 复杂表达式：`(a0050-a0051)/a0052*100`
- 聚合函数：`SUM(a0050)/SUM(a0052)`

### Q4: 如何调试SQL
**A**:
1. 在日志中查看实际执行的SQL
2. 将SQL复制到数据库工具中手动执行
3. 使用 `/api/indicator-item/{code}/execute` 接口测试

## 进阶功能

### 同比环比计算
系统会自动计算同比（year_over_year）和环比（month_over_month），需要有历史数据支持。

### 科室下钻
对于支持科室下钻的指标（`support_dept_drill=1`），使用：
```
GET /api/indicator-result/dept-drill/{metricCode}
```

### 数据库监控
访问 Druid 监控页面：http://localhost:8080/dgear/druid/
- 用户名：admin
- 密码：admin

## 技术支持

如有问题，请查看：
1. 应用日志：查看控制台输出
2. Druid 监控：查看SQL执行情况
3. README.md：查看详细文档
