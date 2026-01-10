# CUSTOM时间维度数据库字段调整

## 问题描述

在使用 CUSTOM 时间维度时出现数据库错误：

```
Data truncation: Data too long for column 'time_value' at row 1
```

## 原因分析

### 各时间维度的 timeValue 长度

| 时间维度 | timeValue 格式 | 示例 | 长度 |
|---------|---------------|------|------|
| YEAR | yyyy | 2020 | 4 |
| QUARTER | yyyy-Qn | 2020-Q1 | 7 |
| MONTH | yyyy-MM | 2020-01 | 7 |
| DAY | yyyy-MM-dd | 2020-01-01 | 10 |
| **CUSTOM** | **yyyy-MM-dd~yyyy-MM-dd** | **2020-01-01~2020-12-31** | **21** |

当前数据库表 `time_value` 字段长度不足以存储 CUSTOM 时间维度的值（21个字符）。

## 解决方案

### 需要修改的表

1. `t_indicator_result` - 指标计算结果表
2. `t_indicator_result_dept` - 科室下钻结果表

### SQL修改脚本

```sql
-- 修改指标计算结果表
ALTER TABLE t_indicator_result
MODIFY COLUMN time_value VARCHAR(30) COMMENT '时间值（支持CUSTOM格式：yyyy-MM-dd~yyyy-MM-dd）';

-- 修改科室下钻结果表
ALTER TABLE t_indicator_result_dept
MODIFY COLUMN time_value VARCHAR(30) COMMENT '时间值（支持CUSTOM格式：yyyy-MM-dd~yyyy-MM-dd）';
```

### 执行步骤

1. **SSH登录数据库服务器**
   ```bash
   ssh root@81.71.44.180
   ```

2. **连接MySQL数据库**
   ```bash
   mysql -h gz-cdb-bq7gk3k5.sql.tencentcdb.com -P 63606 -u root -pYiguo9527_ d_hos_claude_0251230
   ```

3. **执行修改**
   ```sql
   -- 检查当前字段长度
   SHOW COLUMNS FROM t_indicator_result LIKE 'time_value';
   SHOW COLUMNS FROM t_indicator_result_dept LIKE 'time_value';

   -- 修改字段长度
   ALTER TABLE t_indicator_result
   MODIFY COLUMN time_value VARCHAR(30) COMMENT '时间值（支持CUSTOM格式：yyyy-MM-dd~yyyy-MM-dd）';

   ALTER TABLE t_indicator_result_dept
   MODIFY COLUMN time_value VARCHAR(30) COMMENT '时间值（支持CUSTOM格式：yyyy-MM-dd~yyyy-MM-dd）';

   -- 验证修改
   SHOW COLUMNS FROM t_indicator_result LIKE 'time_value';
   SHOW COLUMNS FROM t_indicator_result_dept LIKE 'time_value';
   ```

4. **退出MySQL**
   ```sql
   EXIT;
   ```

### 验证修改

修改完成后，再次测试API：

```bash
curl -X POST "http://81.71.44.180:8080/dgear/api/indicator-result/calculate?metricCode=总病案数&timeDimension=CUSTOM&startDate=2020-01-01&endDate=2020-01-11"
```

应该返回成功响应，并且 timeValue 为 `2020-01-01~2020-01-11`。

## 远程执行方式

如果想通过Python脚本远程执行（需要安装 mysql-connector-python）：

```python
import mysql.connector

conn = mysql.connector.connect(
    host="gz-cdb-bq7gk3k5.sql.tencentcdb.com",
    port=63606,
    user="root",
    password="Yiguo9527_",
    database="d_hos_claude_0251230"
)

cursor = conn.cursor()

# 修改表结构
sqls = [
    "ALTER TABLE t_indicator_result MODIFY COLUMN time_value VARCHAR(30) COMMENT '时间值（支持CUSTOM格式：yyyy-MM-dd~yyyy-MM-dd）'",
    "ALTER TABLE t_indicator_result_dept MODIFY COLUMN time_value VARCHAR(30) COMMENT '时间值（支持CUSTOM格式：yyyy-MM-dd~yyyy-MM-dd）'"
]

for sql in sqls:
    cursor.execute(sql)
    print(f"✓ 执行成功: {sql[:50]}...")

conn.commit()
cursor.close()
conn.close()

print("\n数据库字段修改完成！")
```

## 影响范围

- ✅ **向后兼容**: 扩大字段长度不影响现有数据
- ✅ **数据完整性**: 现有的 YEAR/QUARTER/MONTH/DAY 数据不受影响
- ✅ **性能影响**: VARCHAR(30) vs VARCHAR(20) 对性能影响微乎其微
- ⚠️ **需要停机**: 修改表结构时建议暂停应用（或选择低峰期）

## 后续检查

修改完成后，建议检查：

1. **字段长度**
   ```sql
   SHOW COLUMNS FROM t_indicator_result LIKE 'time_value';
   ```
   应该显示 `varchar(30)`

2. **测试插入**
   ```sql
   SELECT time_value, LENGTH(time_value) as len
   FROM t_indicator_result
   WHERE time_dimension = 'CUSTOM'
   LIMIT 5;
   ```

3. **API测试**
   使用各种时间范围测试CUSTOM维度

---

**更新时间**: 2026-01-10
**影响表**: t_indicator_result, t_indicator_result_dept
**字段修改**: time_value VARCHAR(20) → VARCHAR(30)
