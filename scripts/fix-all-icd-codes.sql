-- 修复所有指标项的ICD编码精确匹配问题
-- 将所有 = 'ICD编码' 改为 LIKE 'ICD编码%'

USE d_hos_claude_0251230;

-- 肺炎相关指标项 (J12, J13, J14, J15, J16, J17, J18)
UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C03C = 'J18'", "C03C LIKE 'J18%'")
WHERE query_sql LIKE "%C03C = 'J18'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C06x01C = 'J18'", "C06x01C LIKE 'J18%'")
WHERE query_sql LIKE "%C06x01C = 'J18'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C03C = 'J12'", "C03C LIKE 'J12%'")
WHERE query_sql LIKE "%C03C = 'J12'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C06x01C = 'J12'", "C06x01C LIKE 'J12%'")
WHERE query_sql LIKE "%C06x01C = 'J12'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C03C = 'J13'", "C03C LIKE 'J13%'")
WHERE query_sql LIKE "%C03C = 'J13'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C06x01C = 'J13'", "C06x01C LIKE 'J13%'")
WHERE query_sql LIKE "%C06x01C = 'J13'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C03C = 'J14'", "C03C LIKE 'J14%'")
WHERE query_sql LIKE "%C03C = 'J14'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C06x01C = 'J14'", "C06x01C LIKE 'J14%'")
WHERE query_sql LIKE "%C06x01C = 'J14'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C03C = 'J15'", "C03C LIKE 'J15%'")
WHERE query_sql LIKE "%C03C = 'J15'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C06x01C = 'J15'", "C06x01C LIKE 'J15%'")
WHERE query_sql LIKE "%C06x01C = 'J15'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C03C = 'J16'", "C03C LIKE 'J16%'")
WHERE query_sql LIKE "%C03C = 'J16'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C06x01C = 'J16'", "C06x01C LIKE 'J16%'")
WHERE query_sql LIKE "%C06x01C = 'J16'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C03C = 'J17'", "C03C LIKE 'J17%'")
WHERE query_sql LIKE "%C03C = 'J17'%";

UPDATE t_indicator_item
SET query_sql = REPLACE(query_sql, "C06x01C = 'J17'", "C06x01C LIKE 'J17%'")
WHERE query_sql LIKE "%C06x01C = 'J17'%";

-- 验证修复结果
SELECT
    item_code,
    item_name,
    CASE
        WHEN query_sql REGEXP "(C03C|C06x01C)\\s*=\\s*'[IJ][0-9]" THEN '⚠ 仍有精确匹配'
        WHEN query_sql LIKE '%LIKE%I%' OR query_sql LIKE '%LIKE%J%' THEN '✓ 已使用LIKE'
        ELSE '无ICD编码'
    END as icd_status
FROM t_indicator_item
WHERE item_code IN ('a0050', 'a0052', 'a0055', 'a0058', 'a0059', 'a0061', 'a0064', 'a0067');
