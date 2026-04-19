-- ===========================================
-- 3.3.11 检验项目替代评价方法使用率（CL-11）
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床检验专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.3.11.1
CALL sp_kpi_item_create(
    '使用替代评价方法的无室间质评计划检验项目数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映无室间质评计划的检验项目中实施替代评价的情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '替代评价方法包括：分割样品比对、实验室间比对、重新评价验证方法、替代微生物验证方法等。', '无', '无', '无', NULL,
    '标本日期', '检验科', '使用替代评价方法的无室间质评计划检验项目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.11.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '使用替代评价方法的无室间质评计划检验项目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.3.11.2
CALL sp_kpi_item_create(
    '无室间质评计划检验项目总数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映无室间质评计划的检验项目中实施替代评价的情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '标本日期', '检验科', '无室间质评计划检验项目总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.11.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '无室间质评计划检验项目总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.3.11
CALL sp_kpi_item_create(
    '检验项目替代评价方法使用率（CL-11）', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '无室间质评计划检验项目中使用替代评价方法的检验项目数占同期无室间质评计划检验项目总数的比例。', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映无室间质评计划的检验项目中实施替代评价的情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '替代评价方法包括：分割样品比对、实验室间比对、重新评价验证方法等。', '无', '无', '无', NULL,
    '标本日期', '检验科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.11"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '检验项目替代评价方法使用率（CL-11）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
