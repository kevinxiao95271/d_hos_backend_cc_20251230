# 医疗指标管理系统后端工程

## 项目简介
基于 SpringBoot 2.7 的医疗指标管理系统，支持指标项配置、指标计算、表达式解析、科室下钻等功能。

## 技术栈
- SpringBoot 2.7.18
- MyBatis Plus 3.5.3.1
- MySQL 8.0
- Druid 数据库连接池
- Swagger 3 (SpringDoc OpenAPI)
- AviatorScript 表达式引擎
- Lombok
- FastJSON

## 数据库连接信息
```
主机: gz-cdb-bq7gk3k5.sql.tencentcdb.com
端口: 63606
数据库: d_hos_claude_0251230
用户名: root
密码: Yiguo9527_
```

## 项目结构
```
src/main/java/com/hospital/indicator/
├── IndicatorManagementApplication.java  # 启动类
├── common/                               # 通用类
│   ├── Result.java                       # 统一返回结果
│   ├── BusinessException.java            # 业务异常
│   └── GlobalExceptionHandler.java       # 全局异常处理
├── config/                               # 配置类
│   └── SwaggerConfig.java                # Swagger配置
├── entity/                               # 实体类
│   ├── IndicatorItem.java                # 指标项实体
│   ├── Indicator.java                    # 指标实体
│   ├── IndicatorResult.java              # 指标结果实体
│   └── IndicatorResultDept.java          # 科室下钻结果实体
├── dto/                                  # 数据传输对象
│   ├── IndicatorItemSaveDTO.java         # 指标项保存DTO
│   ├── IndicatorItemExecuteResultDTO.java # 指标项执行结果DTO
│   ├── IndicatorSaveDTO.java             # 指标保存DTO
│   └── IndicatorTreeDTO.java             # 指标树形结构DTO
├── mapper/                               # 数据访问层
│   ├── IndicatorItemMapper.java          # 指标项Mapper
│   ├── IndicatorMapper.java              # 指标Mapper
│   ├── IndicatorResultMapper.java        # 指标结果Mapper
│   └── IndicatorResultDeptMapper.java    # 科室下钻结果Mapper
├── service/                              # 服务接口
│   ├── IndicatorItemService.java         # 指标项服务
│   ├── IndicatorService.java             # 指标服务
│   ├── IndicatorCalculationService.java  # 指标计算服务
│   └── impl/                             # 服务实现
│       ├── IndicatorItemServiceImpl.java
│       ├── IndicatorServiceImpl.java
│       └── IndicatorCalculationServiceImpl.java
├── controller/                           # 控制器
│   ├── IndicatorItemController.java      # 指标项控制器
│   ├── IndicatorController.java          # 指标控制器
│   └── IndicatorResultController.java    # 指标结果控制器
└── util/                                 # 工具类
    └── ExpressionParser.java             # 表达式解析器
```

## 核心功能

### 1. 指标项管理
- 支持指标项的增删改查
- 支持SQL配置和参数化查询
- 支持SQL有效性校验
- 支持执行指标项查询并返回结果

### 2. 指标管理
- 支持指标的增删改查
- 支持树形层级结构
- 支持表达式配置（四则运算+聚合函数）
- 自动提取表达式中的指标项依赖

### 3. 表达式解析
使用 AviatorScript 引擎，支持：
- 四则运算：+、-、*、/
- 括号：()
- 聚合函数：SUM()、AVG()、MAX()、MIN()、COUNT()
- 示例表达式：
  - `a0050`（单个指标项）
  - `a0052/a0050`（除法）
  - `(a0050-a0051)/a0052*100`（复杂表达式）
  - `SUM(a0050)/SUM(a0052)`（聚合函数）

### 4. 指标计算引擎
- 支持单个指标计算
- 支持批量指标计算
- 支持按年、季、月、日等维度计算
- 支持自动拆分时间范围进行批量计算
- 支持同比、环比计算

### 5. 科室下钻功能
- 支持按科室维度进行指标下钻分析
- 支持科室维度的计算结果存储

## 启动方式

### 1. 初始化数据库
执行 `schema.sql` 文件创建所需的表结构：
```bash
mysql -h gz-cdb-bq7gk3k5.sql.tencentcdb.com -P 63606 -u root -p d_hos_claude_0251230 < schema.sql
```

### 2. 启动应用
```bash
mvn spring-boot:run
```

或者使用IDE运行 `IndicatorManagementApplication` 类

### 3. 访问接口文档
启动成功后访问：
- Swagger UI: http://localhost:8080/dgear/swagger-ui.html
- Druid 监控: http://localhost:8080/dgear/druid/

## API 接口说明

### 指标项管理 (/api/indicator-item)
- `GET /page` - 分页查询指标项
- `GET /list` - 查询所有指标项
- `GET /{id}` - 根据ID查询
- `GET /code/{itemCode}` - 根据编码查询
- `POST /save` - 保存或更新
- `DELETE /{id}` - 删除
- `DELETE /batch` - 批量删除
- `POST /{code}/execute` - **执行指标项查询**
- `POST /validate-sql` - 校验SQL

### 指标管理 (/api/indicator)
- `GET /page` - 分页查询指标
- `GET /tree` - **查询指标树形结构**
- `GET /{id}` - 根据ID查询
- `GET /code/{metricCode}` - 根据编码查询
- `GET /children/{parentCode}` - 查询子指标
- `POST /save` - 保存或更新
- `DELETE /{id}` - 删除
- `DELETE /batch` - 批量删除
- `POST /validate-expression` - 校验表达式

### 指标计算与结果查询 (/api/indicator-result)
- `POST /calculate` - **执行指标计算**
- `POST /batch-calculate` - **批量计算指标**
- `GET /latest` - 查询最新计算结果
- `GET /list` - 查询指标结果列表
- `GET /dept-drill/{metricCode}` - **查询科室下钻结果**

## 示例数据

系统已初始化肺炎相关指标的示例数据：

### 指标项示例
- `a0050`: 肺炎（住院、成人）病种例数
- `a0052`: 肺炎（住院、成人）出院患者占用总床日数

### 指标示例
- `10`: 重点病种质量控制指标（一级）
- `10.3`: 肺炎（住院、成人）（二级）
- `10.3.1`: 肺炎（住院、成人）病种例数（叶子节点，指标项）
- `10.3.2`: 肺炎（住院、成人）平均住院日（叶子节点，表达式：a0052/a0050）

## 注意事项

1. **SQL安全**：指标项的SQL必须是SELECT查询，禁止包含INSERT、UPDATE、DELETE等危险操作
2. **参数占位符**：SQL中使用 `#{paramName}` 格式的占位符，执行时自动替换
3. **表达式格式**：表达式中的指标项编码会被自动提取并保存到关联字段
4. **时间维度**：计算时需指定时间维度（YEAR/QUARTER/MONTH/DAY）
5. **科室下钻**：只有配置了 `support_dept_drill=1` 的指标才支持科室下钻

## 开发建议

1. 先配置指标项（定义SQL查询）
2. 再配置指标（定义计算表达式）
3. 使用 `/execute` 接口测试指标项查询
4. 使用 `/calculate` 接口执行指标计算
5. 使用 `/latest` 或 `/list` 接口查看计算结果

## 联系方式
开发团队：dev@hospital.com
