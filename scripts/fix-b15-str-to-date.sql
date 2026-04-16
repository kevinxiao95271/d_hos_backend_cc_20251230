-- 修复所有指标项SQL - 使用正确的日期格式转换
-- B15格式: 2020/1/18 10:00 (斜杠分隔)
-- 修复方案: 使用 STR_TO_DATE(B15, '%Y/%m/%d') 替代 DATE(B15)

USE d_hos_claude_0251230;

-- 方案1: 对于按年统计的查询，使用YEAR函数（推荐）
-- 将 DATE(B15) BETWEEN #{startDate} AND #{endDate}
-- 改为 STR_TO_DATE(B15, '%Y/%m/%d') >= #{startDate} AND STR_TO_DATE(B15, '%Y/%m/%d') <= #{endDate}

UPDATE t_indicator_item
SET query_sql = REPLACE(
    query_sql,
    'DATE(B15) BETWEEN',
    'STR_TO_DATE(B15, ''%Y/%m/%d'') BETWEEN'
)
WHERE query_sql LIKE '%DATE(B15) BETWEEN%';

UPDATE t_indicator_item
SET query_sql = REPLACE(
    query_sql,
    'DATE(d_mr.B15) BETWEEN',
    'STR_TO_DATE(d_mr.B15, ''%Y/%m/%d'') BETWEEN'
)
WHERE query_sql LIKE '%DATE(d_mr.B15) BETWEEN%';

-- 验证更新结果
SELECT
    item_code,
    item_name,
    CASE
        WHEN query_sql LIKE '%STR_TO_DATE(B15%' OR query_sql LIKE '%STR_TO_DATE(d_mr.B15%' THEN '✓ 已修复'
        WHEN query_sql LIKE '%DATE(B15)%' OR query_sql LIKE '%DATE(d_mr.B15)%' THEN '⚠ 使用DATE()可能不准确'
        WHEN query_sql LIKE '%B15%' THEN '⚠ 需要检查'
        ELSE '无B15字段'
    END as fix_status,
    SUBSTRING(query_sql, 1, 150) as sql_preview
FROM t_indicator_item
WHERE query_sql LIKE '%B15%'
ORDER BY sort_order
LIMIT 10;

-- 统计
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
    '已修复为STR_TO_DATE' as item,
    COUNT(*) as count
FROM t_indicator_item
WHERE query_sql LIKE '%STR_TO_DATE(B15%' OR query_sql LIKE '%STR_TO_DATE(d_mr.B15%';
