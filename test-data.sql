-- ========================================
-- 测试数据初始化脚本
-- 用于快速验证系统功能
-- ========================================

USE d_hos_claude_0251230;

-- 清空现有数据（仅用于测试环境）
TRUNCATE TABLE t_indicator_result;
TRUNCATE TABLE t_indicator_result_dept;
-- 注意：不清空 t_indicator 和 t_indicator_item，因为这些是配置数据

-- ========================================
-- 插入更多测试指标项
-- ========================================

INSERT INTO t_indicator_item (item_code, item_name, item_type, data_source, query_sql, aggregate_function, aggregate_field, calculation_condition, unit, status, sort_order) VALUES
-- 肺炎相关指标项（已存在，这里是完整示例）
('a0050', '肺炎（住院、成人）病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C LIKE ''J18%'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C LIKE ''J18%'') AND A14 >= 18',
'COUNT', '*', '出院日期=指定时间范围 AND (出院主要诊断 OR 出院其他诊断1) LIKE ("J13%" OR "J14%" OR "J15%" OR "J18%") AND 年龄≥18', '人', 1, 62),

('a0052', '肺炎（住院、成人）出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C LIKE ''J18%'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C LIKE ''J18%'') AND A14 >= 18',
'SUM', 'B20', '出院日期=指定时间范围 AND (出院主要诊断 OR 出院其他诊断1) LIKE ("J13%" OR "J14%" OR "J15%" OR "J18%") AND 年龄≥18', '床日', 1, 64)
ON DUPLICATE KEY UPDATE
    item_name = VALUES(item_name),
    query_sql = VALUES(query_sql);

-- ========================================
-- 插入完整的指标树结构
-- ========================================

INSERT INTO t_indicator (metric_code, metric_name, parent_code, indicator_level, is_leaf, metric_type, calculation_type, expression, related_items, unit, support_dept_drill, status, sort_order) VALUES
-- 一级指标
('10', '重点病种质量控制指标', NULL, 1, 0, 'QUALITATIVE', 'EXPRESSION', NULL, NULL, NULL, 0, 1, 10),

-- 二级指标
('10.3', '肺炎（住院、成人）', '10', 2, 0, 'QUALITATIVE', 'EXPRESSION', NULL, NULL, NULL, 0, 1, 103),

-- 三级指标（叶子节点）
('10.3.1', '肺炎（住院、成人）病种例数', '10.3', 3, 1, 'QUANTITATIVE', 'ITEM', 'a0050', '["a0050"]', '人', 1, 1, 1031),
('10.3.2', '肺炎（住院、成人）平均住院日', '10.3', 3, 1, 'QUANTITATIVE', 'EXPRESSION', 'a0052/a0050', '["a0050","a0052"]', '天', 1, 1, 1032),

-- 四级指标（10.3.2 的组成部分）
('10.3.2.1', '肺炎（住院、成人）出院患者占用总床日数', '10.3.2', 4, 1, 'QUANTITATIVE', 'ITEM', 'a0052', '["a0052"]', '床日', 1, 1, 10321),
('10.3.2.2', '同期肺炎（住院、成人）病种例数', '10.3.2', 4, 1, 'QUANTITATIVE', 'ITEM', 'a0050', '["a0050"]', '人', 1, 1, 10322)
ON DUPLICATE KEY UPDATE
    metric_name = VALUES(metric_name),
    expression = VALUES(expression),
    related_items = VALUES(related_items);

-- ========================================
-- 验证查询
-- ========================================

-- 查看指标项
SELECT item_code, item_name, item_type, unit, status FROM t_indicator_item ORDER BY sort_order;

-- 查看指标树形结构
SELECT metric_code, metric_name, parent_code, indicator_level, is_leaf, calculation_type, expression, unit
FROM t_indicator
ORDER BY sort_order;

-- 统计信息
SELECT
    '指标项总数' as item,
    COUNT(*) as count
FROM t_indicator_item
WHERE status = 1
UNION ALL
SELECT
    '指标总数' as item,
    COUNT(*) as count
FROM t_indicator
WHERE status = 1
UNION ALL
SELECT
    '叶子指标数' as item,
    COUNT(*) as count
FROM t_indicator
WHERE status = 1 AND is_leaf = 1;

-- ========================================
-- 测试SQL查询（验证数据存在）
-- ========================================

-- 查询2025年1月的肺炎病例数（示例）
-- SELECT COUNT(*) as result_value
-- FROM D_MR
-- WHERE B15 BETWEEN '2025-01-01' AND '2025-01-31'
-- AND (C03C LIKE 'J13%' OR C03C LIKE 'J14%' OR C03C LIKE 'J15%' OR C03C LIKE 'J18%'
--      OR C06x01C LIKE 'J13%' OR C06x01C LIKE 'J14%' OR C06x01C LIKE 'J15%' OR C06x01C LIKE 'J18%')
-- AND A14 >= 18;

-- 查询2025年1月的总床日数（示例）
-- SELECT IFNULL(SUM(B20), 0) as result_value
-- FROM D_MR
-- WHERE B15 BETWEEN '2025-01-01' AND '2025-01-31'
-- AND (C03C LIKE 'J13%' OR C03C LIKE 'J14%' OR C03C LIKE 'J15%' OR C03C LIKE 'J18%'
--      OR C06x01C LIKE 'J13%' OR C06x01C LIKE 'J14%' OR C06x01C LIKE 'J15%' OR C06x01C LIKE 'J18%')
-- AND A14 >= 18;
