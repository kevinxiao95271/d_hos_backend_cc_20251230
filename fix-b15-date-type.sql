-- 修复所有指标项SQL - 确保B15字段正确转换为日期类型进行比较
-- 使用 DATE(B15) 或 STR_TO_DATE 来确保日期比较正确

USE d_hos_claude_0251230;

-- 更新所有指标项，将 B15 BETWEEN 改为 DATE(B15) BETWEEN 或使用日期函数
UPDATE t_indicator_item SET query_sql = REPLACE(query_sql, 'WHERE B15 BETWEEN', 'WHERE DATE(B15) BETWEEN');
UPDATE t_indicator_item SET query_sql = REPLACE(query_sql, 'WHERE d_mr.B15 BETWEEN', 'WHERE DATE(d_mr.B15) BETWEEN');
UPDATE t_indicator_item SET query_sql = REPLACE(query_sql, 'AND B15 BETWEEN', 'AND DATE(B15) BETWEEN');
UPDATE t_indicator_item SET query_sql = REPLACE(query_sql, 'AND d_mr.B15 BETWEEN', 'AND DATE(d_mr.B15) BETWEEN');

-- 显示更新结果
SELECT item_code, item_name,
       SUBSTRING(query_sql, 1, 200) as query_preview
FROM t_indicator_item
WHERE query_sql LIKE '%DATE(B15)%' OR query_sql LIKE '%DATE(d_mr.B15)%'
ORDER BY sort_order
LIMIT 10;
