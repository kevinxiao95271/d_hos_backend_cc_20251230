-- ===========================================
-- 3.3.10 室间质评项目合格率（CL-10）
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床检验专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.3.10.1
CALL sp_kpi_item_create(
    '室间质评成绩合格的检验项目数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映实验室参加室间质评计划的合格情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '标本日期', '检验科', '室间质评成绩合格的检验项目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '室间质评成绩合格的检验项目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.3.10.2
CALL sp_kpi_item_create(
    '参加室间质评的检验项目总数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映实验室参加室间质评计划的合格情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '标本日期', '检验科', '参加室间质评的检验项目总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '参加室间质评的检验项目总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.3.10
CALL sp_kpi_item_create(
    '室间质评项目合格率（CL-10）', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '参加国家或省级临床检验中心组织室间质评成绩合格的检验项目数占同期参加室间质评检验项目总数的比例。', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映实验室参加室间质评计划的合格情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '标本日期', '检验科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.10"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '室间质评项目合格率（CL-10）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
