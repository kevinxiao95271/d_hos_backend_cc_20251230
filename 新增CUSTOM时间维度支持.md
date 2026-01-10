# 新增CUSTOM时间维度支持

## 📋 问题说明

用户在使用自定义时间范围（如 2020-01-01 到 2020-01-11）进行指标计算时，遇到错误：

```
不支持的时间维度：CUSTOM
```

所有指标计算都失败了。

## ✅ 解决方案

### 1. 修改内容

在 `IndicatorCalculationServiceImpl.java` 中的 `calculateTimeValue()` 方法添加对 `CUSTOM` 时间维度的支持。

#### 修改前
```java
private String calculateTimeValue(String timeDimension, LocalDate startDate, LocalDate endDate) {
    switch (timeDimension) {
        case "YEAR":
            return String.valueOf(startDate.getYear());
        case "QUARTER":
            int quarter = (startDate.getMonthValue() - 1) / 3 + 1;
            return startDate.getYear() + "-Q" + quarter;
        case "MONTH":
            return startDate.format(DateTimeFormatter.ofPattern("yyyy-MM"));
        case "DAY":
            return startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        default:
            throw new BusinessException("不支持的时间维度：" + timeDimension);
    }
}
```

#### 修改后
```java
private String calculateTimeValue(String timeDimension, LocalDate startDate, LocalDate endDate) {
    switch (timeDimension.toUpperCase()) {  // 支持大小写
        case "YEAR":
            return String.valueOf(startDate.getYear());
        case "QUARTER":
            int quarter = (startDate.getMonthValue() - 1) / 3 + 1;
            return startDate.getYear() + "-Q" + quarter;
        case "MONTH":
            return startDate.format(DateTimeFormatter.ofPattern("yyyy-MM"));
        case "DAY":
            return startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        case "CUSTOM":  // 🆕 新增
            // 自定义时间范围，格式：开始日期~结束日期
            return startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) +
                   "~" +
                   endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        default:
            throw new BusinessException("不支持的时间维度：" + timeDimension);
    }
}
```

### 2. 更新 Swagger 文档

更新所有 API 接口的 `@Parameter` 注解，添加 CUSTOM 选项：

```java
@Parameter(description = "时间维度：YEAR/QUARTER/MONTH/DAY/CUSTOM", required = true)
```

涉及接口：
- `POST /api/indicator-result/calculate` - 单个指标计算
- `POST /api/indicator-result/batch-calculate` - 批量计算
- `POST /api/indicator-result/dept-drill-down` - 科室下钻计算

---

## 🚀 使用方法

### 1. 单个指标计算（自定义时间范围）

```bash
curl -X POST "http://81.71.44.180:8080/dgear/api/indicator-result/calculate?metricCode=总病案数&timeDimension=CUSTOM&startDate=2020-01-01&endDate=2020-01-11"
```

**Python 示例**:
```python
import requests

response = requests.post(
    "http://81.71.44.180:8080/dgear/api/indicator-result/calculate",
    params={
        "metricCode": "总病案数",
        "timeDimension": "CUSTOM",  # 使用 CUSTOM
        "startDate": "2020-01-01",
        "endDate": "2020-01-11"
    }
)

result = response.json()
print(result)
```

### 2. 批量计算（自定义时间范围）

```bash
curl -X POST "http://81.71.44.180:8080/dgear/api/indicator-result/batch-calculate?timeDimension=CUSTOM&startDate=2020-01-01&endDate=2020-01-11" \
  -H "Content-Type: application/json" \
  -d '["总病案数", "手术患者并发症发生率", "I类切口手术部位感染率"]'
```

**Python 示例**:
```python
import requests

response = requests.post(
    "http://81.71.44.180:8080/dgear/api/indicator-result/batch-calculate",
    params={
        "timeDimension": "CUSTOM",
        "startDate": "2020-01-01",
        "endDate": "2020-01-11"
    },
    json=[
        "总病案数",
        "指标测试末级001-1",
        "手术患者并发症发生率",
        "I类切口手术部位感染率"
    ]
)

results = response.json()
print(f"成功计算 {len(results['data'])} 个指标")
```

### 3. 科室下钻（自定义时间范围）

```bash
curl -X POST "http://81.71.44.180:8080/dgear/api/indicator-result/dept-drill-down?metricCode=总病案数&timeDimension=CUSTOM&startDate=2020-01-01&endDate=2020-01-11"
```

**Python 示例**:
```python
import requests

response = requests.post(
    "http://81.71.44.180:8080/dgear/api/indicator-result/dept-drill-down",
    params={
        "metricCode": "总病案数",
        "timeDimension": "CUSTOM",
        "startDate": "2020-01-01",
        "endDate": "2020-01-11"
    }
)

result = response.json()
print(f"返回 {len(result['data'])} 个科室的数据")
```

---

## 📊 时间维度说明

| 时间维度 | 值 | timeValue 格式 | 示例 | 日期范围 |
|---------|-----|--------------|------|---------|
| 按年 | YEAR | yyyy | 2020 | 2020-01-01 至 2020-12-31 |
| 按季度 | QUARTER | yyyy-Qn | 2020-Q1 | 2020-01-01 至 2020-03-31 |
| 按月 | MONTH | yyyy-MM | 2020-01 | 2020-01-01 至 2020-01-31 |
| 按天 | DAY | yyyy-MM-dd | 2020-01-01 | 2020-01-01 至 2020-01-01 |
| **自定义** | **CUSTOM** | **yyyy-MM-dd~yyyy-MM-dd** | **2020-01-01~2020-01-11** | **任意时间范围** |

### CUSTOM 时间维度特点

1. **灵活性**: 可以指定任意起止日期，不受年/季度/月/日的限制
2. **格式**: timeValue 格式为 `开始日期~结束日期`
3. **适用场景**:
   - 任意天数的统计（如：10天、45天）
   - 跨月统计（如：2020-01-15 到 2020-02-20）
   - 特定事件周期（如：活动期间、项目周期）

---

## 💾 数据存储示例

### 普通时间维度
```sql
SELECT * FROM t_indicator_result
WHERE metric_code = '总病案数' AND time_dimension = 'YEAR' AND time_value = '2020';
```

结果：
```
| metric_code | time_dimension | time_value | result_value |
|------------|----------------|------------|--------------|
| 总病案数    | YEAR          | 2020       | 10000        |
```

### CUSTOM 时间维度
```sql
SELECT * FROM t_indicator_result
WHERE metric_code = '总病案数' AND time_dimension = 'CUSTOM';
```

结果：
```
| metric_code | time_dimension | time_value            | result_value |
|------------|----------------|-----------------------|--------------|
| 总病案数    | CUSTOM         | 2020-01-01~2020-01-11 | 523          |
| 总病案数    | CUSTOM         | 2020-02-15~2020-03-20 | 1245         |
```

---

## ⚠️ 注意事项

### 1. 大小写不敏感
```python
# 以下写法都有效
timeDimension="CUSTOM"
timeDimension="custom"
timeDimension="Custom"
```

### 2. 日期格式
- 开始日期和结束日期都必须是 `yyyy-MM-dd` 格式
- 示例：`2020-01-01`，`2025-12-31`

### 3. 与批量计算的区别
- **批量计算** (batch-calculate): 会根据 timeDimension 自动拆分时间范围
  - 例如：`timeDimension=MONTH`, `2020-01-01~2020-03-31` → 拆分为3个月分别计算
- **自定义时间** (CUSTOM): 不会拆分，就按指定的完整时间范围计算
  - 例如：`timeDimension=CUSTOM`, `2020-01-01~2020-03-31` → 整体计算整个3个月的数据

---

## 🔍 验证测试

### 测试步骤

1. **部署更新后的应用**
   ```bash
   ssh root@81.71.44.180
   cd /data/indicator-management
   ./restart.sh
   ```

2. **测试单个指标计算**
   ```bash
   curl -X POST "http://81.71.44.180:8080/dgear/api/indicator-result/calculate?metricCode=总病案数&timeDimension=CUSTOM&startDate=2020-01-01&endDate=2020-01-11"
   ```

3. **检查结果**
   - 应该返回 `{"code": 200, "data": {...}}`
   - timeValue 应该是 `2020-01-01~2020-01-11`

4. **查询数据库验证**
   ```sql
   SELECT metric_code, time_dimension, time_value, result_value, calculation_status
   FROM t_indicator_result
   WHERE time_dimension = 'CUSTOM'
   ORDER BY create_time DESC
   LIMIT 5;
   ```

---

## 📝 更新记录

- **更新时间**: 2026-01-10
- **影响范围**: 所有指标计算接口
- **向后兼容**: ✅ 是（原有 YEAR/QUARTER/MONTH/DAY 不受影响）
- **需要重启**: ✅ 是
- **数据库变更**: ❌ 否（使用现有字段）

---

## 🎯 总结

通过添加 CUSTOM 时间维度，系统现在支持：

1. ✅ **标准时间维度**: YEAR, QUARTER, MONTH, DAY
2. ✅ **自定义时间范围**: CUSTOM（任意起止日期）
3. ✅ **大小写不敏感**: 支持 CUSTOM, custom, Custom 等
4. ✅ **完全向后兼容**: 不影响现有功能

用户现在可以灵活地进行任意时间范围的指标计算！
