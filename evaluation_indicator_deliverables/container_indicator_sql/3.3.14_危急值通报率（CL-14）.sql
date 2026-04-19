-- ===========================================
-- 3.3.14 危急值通报率（CL-14）
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床检验专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.3.14.1
CALL sp_kpi_item_create(
    '已通报的危急值数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映危急值通报情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '危急值数以单个检验项目在单次检测中出现的危急值作为独立计数单位，但对同一标本/样品重复检测出现的危急值数计为 1。', '无', '无', '无', NULL,
    '标本日期', '检验科', '已通报的危急值数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.14.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '已通报的危急值数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.3.14.2
CALL sp_kpi_item_create(
    '需要通报的危急值总数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映危急值通报情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '危急值数以单个检验项目在单次检测中出现的危急值作为独立计数单位。', '无', '无', '无', NULL,
    '标本日期', '检验科', '需要通报的危急值总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.14.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '需要通报的危急值总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.3.14
CALL sp_kpi_item_create(
    '危急值通报率（CL-14）', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '已通报的危急值数占同期需要通报的危急值总数的比例。', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映危急值通报情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '危急值是指表明患者可能正处于生命危险的边缘状态，必须立刻报告给该患者主管医师的检验结果。', '无', '无', '无', NULL,
    '标本日期', '检验科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.14"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '危急值通报率（CL-14）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
