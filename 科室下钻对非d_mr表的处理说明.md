# 科室下钻对非d_mr表的处理说明

## 问题

**如果指标项SQL查询的表不是d_mr，会怎样？会不会报错？**

## 答案

**会报错！** 返回500错误。

---

## 详细分析

### 1. 科室下钻的工作原理

科室下钻功能通过修改指标项的SQL，自动添加B16字段（科室字段）来实现：

#### 原始SQL
```sql
SELECT COUNT(*) AS result_value
FROM d_mr
WHERE ...
```

#### 修改后的SQL（科室下钻）
```sql
SELECT B16 as dept_code, B16 as dept_name, COUNT(*) AS result_value
FROM d_mr
WHERE ...
GROUP BY B16
```

### 2. 如果表没有B16字段会发生什么？

#### 场景示例
假设有一个指标项查询 `t_indicator` 表（没有B16字段）：

```sql
-- 原始SQL
SELECT COUNT(*) AS result_value
FROM t_indicator
WHERE create_time BETWEEN '2023-01-01' AND '2023-01-31'
```

#### 科室下钻时修改后的SQL
```sql
-- 后端自动修改后
SELECT B16 as dept_code, B16 as dept_name, COUNT(*) AS result_value
FROM t_indicator
WHERE create_time BETWEEN '2023-01-01' AND '2023-01-31'
GROUP BY B16
```

#### 执行结果
```
❌ ERROR 1054 (42S22): Unknown column 'B16' in 'field list'
```

---

## 错误处理流程

### 1. 数据库层面
```
MySQL执行SQL → 发现B16列不存在 → 返回错误1054
```

### 2. 后端代码层面

**位置**: `IndicatorCalculationServiceImpl.java` 第574-576行

```java
} catch (Exception e) {
    log.error("查询科室下钻数据失败: itemCode={}, error={}", itemCode, e.getMessage(), e);
    throw new BusinessException("查询科室下钻数据失败：" + itemCode + ", " + e.getMessage());
}
```

### 3. API响应
```json
{
  "code": 500,
  "message": "查询科室下钻数据失败：TEST_ITEM, Unknown column 'B16' in 'field list'",
  "data": null
}
```

---

## 测试验证

### 测试场景
创建一个查询 `t_indicator` 表的指标项（该表没有B16字段）

### 测试结果

#### 普通计算
```
✓ 正常工作
✓ 可以正确返回结果
```

#### 科室下钻
```
✗ 报错: 500
✗ 错误信息: "查询科室下钻数据失败：Unknown column 'B16'"
```

---

## 数据库表情况

### 包含B16字段的表
通过检查数据库 `INFORMATION_SCHEMA.COLUMNS`：

```sql
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'd_hos_claude_0251230'
  AND COLUMN_NAME = 'B16';
```

**结果**: 仅 `d_mr` 表有B16字段

### 当前使用的表
检查现有指标项：

```sql
SELECT DISTINCT
    SUBSTRING_INDEX(SUBSTRING_INDEX(query_sql, 'FROM ', -1), ' ', 1) as table_name
FROM t_indicator_item
WHERE query_sql IS NOT NULL;
```

**结果**: 几乎全部使用 `d_mr` 表

---

## 影响范围分析

### 可以进行科室下钻的表
- ✅ `d_mr` - 病案主表（包含B16字段）

### 不能进行科室下钻的表
- ❌ `t_indicator` - 指标配置表
- ❌ `t_indicator_item` - 指标项配置表
- ❌ `t_indicator_result` - 指标结果表
- ❌ `t_indicator_result_dept` - 科室下钻结果表
- ❌ 其他不包含B16字段的表

---

## 建议和最佳实践

### 1. 指标项设计规范
- ✅ **推荐**: 只对 `d_mr` 表进行科室下钻
- ⚠️ **注意**: 如果需要对其他表进行科室下钻，必须确保该表包含B16字段

### 2. 新增指标项检查清单
创建新指标项时，需要考虑：

- [ ] 数据来源表是什么？
- [ ] 该表是否包含B16（科室）字段？
- [ ] 是否需要支持科室下钻？
- [ ] 如果需要科室下钻但表没有B16字段 → 需要调整设计

### 3. 前端UI建议
可以在前端添加提示：

```javascript
// 检查指标是否支持科室下钻
function canDeptDrill(indicator) {
    // 检查数据源表是否为d_mr
    if (indicator.dataSource === 'd_mr') {
        return true;
    }
    return false;
}

// UI显示
if (!canDeptDrill(indicator)) {
    showWarning("该指标不支持科室下钻（数据表不包含科室字段）");
}
```

### 4. 后端增强建议（可选）

#### 方案1: 在执行前检查
```java
private boolean tableHasB16Column(String tableName) {
    // 查询INFORMATION_SCHEMA检查表是否有B16列
    String sql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS " +
                 "WHERE TABLE_SCHEMA = DATABASE() " +
                 "AND TABLE_NAME = ? AND COLUMN_NAME = 'B16'";
    // 执行查询...
    return count > 0;
}

// 在科室下钻前检查
if (!tableHasB16Column(tableName)) {
    throw new BusinessException("该指标数据表不支持科室下钻（缺少科室字段B16）");
}
```

#### 方案2: 配置标识
在指标项表添加字段：

```sql
ALTER TABLE t_indicator_item
ADD COLUMN support_dept_drill TINYINT(1) DEFAULT 1 COMMENT '是否支持科室下钻: 1-支持, 0-不支持';
```

---

## 常见问题

### Q1: 我能否添加B16字段到其他表？
**A**: 可以，但需要确保：
1. B16字段的数据类型与d_mr中一致（VARCHAR）
2. B16字段存储的是科室编码/名称
3. 数据完整性（非空）

```sql
ALTER TABLE your_table
ADD COLUMN B16 VARCHAR(50) COMMENT '科室';
```

### Q2: 如果我确实需要对没有B16的表进行分组怎么办？
**A**: 有几种方案：
1. **修改表结构**: 添加B16字段（推荐）
2. **JOIN查询**: 通过关联键JOIN到d_mr表获取B16
3. **使用其他维度**: 如果不需要科室维度，使用其他分组字段

### Q3: 报错后数据会不会被保存？
**A**: 不会。
- 普通计算：不影响，只有科室下钻失败
- 科室下钻：完全失败，不保存任何数据
- 事务回滚：确保数据一致性

---

## 错误信息示例

### 前端看到的错误
```
科室下钻计算失败
错误详情: 查询科室下钻数据失败：C0003, Unknown column 'B16' in 'field list'
```

### 后端日志
```
ERROR - 查询科室下钻数据失败: itemCode=C0003, error=Unknown column 'B16' in 'field list'
com.mysql.cj.jdbc.exceptions.SQLSyntaxErrorException: Unknown column 'B16' in 'field list'
    at IndicatorCalculationServiceImpl.queryDeptItemValues(...)
```

---

## 总结

### 关键点
1. ✅ **普通计算**: 不受影响，可查询任何表
2. ❌ **科室下钻**: 必须是包含B16字段的表（目前只有d_mr）
3. ⚠️ **错误处理**: 会返回500错误，包含明确的错误信息
4. 🔒 **数据安全**: 失败时不会保存部分数据

### 推荐做法
- 统一使用 `d_mr` 表进行指标计算
- 如果需要其他表，确保添加了B16字段
- 前端在用户操作前检查是否支持科室下钻
- 给用户明确的错误提示

---

**文档版本**: 1.0
**更新时间**: 2026-01-10
**适用系统**: 医院指标管理系统
