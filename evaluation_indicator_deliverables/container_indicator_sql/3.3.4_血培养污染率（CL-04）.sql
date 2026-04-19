-- ===========================================
-- 3.3.4 血培养污染率（CL-04）
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床检验专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.3.4.1
CALL sp_kpi_item_create(
    '污染的血培养套数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映血培养过程操作的正确性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '一套血培养指一个患者一个穿刺点采集的一套样本。', '一套血培养指一个患者一个穿刺点采集的一套样本。', '无', '无', NULL,
    '标本日期', '检验科', '污染的血培养套数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '污染的血培养套数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.3.4.2
CALL sp_kpi_item_create(
    '血培养总套数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映血培养过程操作的正确性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '一套血培养指一个患者一个穿刺点采集的一套样本。', '一套血培养指一个患者一个穿刺点采集的一套样本。', '无', '无', NULL,
    '标本日期', '检验科', '血培养总套数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '血培养总套数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.3.4
CALL sp_kpi_item_create(
    '血培养污染率（CL-04）', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, @data_source_param,
    '污染的血培养套数占同期血培养总套数的比例。', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映血培养过程操作的正确性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '一套血培养指一个患者一个穿刺点采集的一套样本。', '一套血培养指一个患者一个穿刺点采集的一套样本。', '无', '无', NULL,
    '标本日期', '检验科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '血培养污染率（CL-04）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
