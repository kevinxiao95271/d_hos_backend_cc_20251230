-- 修复心力衰竭相关指标项的ICD编码匹配问题
-- 问题: C03C = 'I50' 精确匹配无法匹配 I50.904 等编码
-- 修复: 改为 C03C LIKE 'I50%' 模糊匹配

USE d_hos_claude_0251230;

-- 修复所有心力衰竭相关的指标项SQL
-- 将 C03C = 'I50' 改为 C03C LIKE 'I50%'
-- 将 C06x01C = 'I50' 改为 C06x01C LIKE 'I50%'

UPDATE t_indicator_item
SET query_sql = REPLACE(
    REPLACE(query_sql, "C03C = 'I50'", "C03C LIKE 'I50%'"),
    "C06x01C = 'I50'", "C06x01C LIKE 'I50%'"
)
WHERE item_code IN ('a0041', 'a0043', 'a0046', 'a0049');

-- 验证修复结果
SELECT
    item_code,
    item_name,
    SUBSTRING(query_sql, LOCATE('I50', query_sql) - 20, 60) as icd_snippet
FROM t_indicator_item
WHERE item_code IN ('a0041', 'a0043', 'a0046', 'a0049');
