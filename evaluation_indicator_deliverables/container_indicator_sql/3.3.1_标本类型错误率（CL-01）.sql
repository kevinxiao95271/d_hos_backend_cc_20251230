-- ===========================================
-- 3.3.1 标本类型错误率（CL-01）
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床检验专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.3.1.1
CALL sp_kpi_item_create(
    '类型不符合要求的标本数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映所采集标本的类型符合要求的情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '标本日期', '检验科', '类型不符合要求的标本数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '类型不符合要求的标本数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.3.1.2
CALL sp_kpi_item_create(
    '标本总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映所采集标本的类型符合要求的情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '标本日期', '检验科', '标本总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '标本总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.3.1
CALL sp_kpi_item_create(
    '标本类型错误率（CL-01）', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '类型不符合要求的标本数占同期标本总数的比例。', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映所采集标本的类型符合要求的情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '标本日期', '检验科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '标本类型错误率（CL-01）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
