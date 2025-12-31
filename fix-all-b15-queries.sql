-- 修复所有指标项SQL中的B15日期比较问题
-- B15字段类型为 varchar(40)，需要使用 DATE(B15) 进行日期比较

USE d_hos_claude_0251230;

-- 更新所有包含 B15 BETWEEN 的SQL语句
-- 将 B15 BETWEEN 替换为 DATE(B15) BETWEEN

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, 'WHERE B15 BETWEEN', 'WHERE DATE(B15) BETWEEN')
WHERE query_sql LIKE '%WHERE B15 BETWEEN%';

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, 'WHERE d_mr.B15 BETWEEN', 'WHERE DATE(d_mr.B15) BETWEEN')
WHERE query_sql LIKE '%WHERE d_mr.B15 BETWEEN%';

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, 'AND B15 BETWEEN', 'AND DATE(B15) BETWEEN')
WHERE query_sql LIKE '%AND B15 BETWEEN%';

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, 'AND d_mr.B15 BETWEEN', 'AND DATE(d_mr.B15) BETWEEN')
WHERE query_sql LIKE '%AND d_mr.B15 BETWEEN%';

-- 查看修复后的结果
SELECT
    item_code,
    item_name,
    CASE
        WHEN query_sql LIKE '%DATE(B15)%' OR query_sql LIKE '%DATE(d_mr.B15)%' THEN '✓ 已修复'
        WHEN query_sql LIKE '%B15%' THEN '⚠ 仍需检查'
        ELSE '无B15字段'
    END as fix_status,
    SUBSTRING(query_sql, 1, 150) as sql_preview
FROM t_indicator_item
WHERE query_sql LIKE '%B15%'
ORDER BY sort_order;

-- 统计修复情况
SELECT
    '总指标项数' as item,
    COUNT(*) as count
FROM t_indicator_item
UNION ALL
SELECT
    '包含B15的指标项' as item,
    COUNT(*) as count
FROM t_indicator_item
WHERE query_sql LIKE '%B15%'
UNION ALL
SELECT
    '已修复为DATE(B15)' as item,
    COUNT(*) as count
FROM t_indicator_item
WHERE query_sql LIKE '%DATE(B15)%' OR query_sql LIKE '%DATE(d_mr.B15)%';
