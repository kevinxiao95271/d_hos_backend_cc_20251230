-- ===========================================
-- 3.6.5 （五）输血相容性检测室间质评项目参加率
-- 数据源：手工填报；分子：参加室间质评的输血相容性检测项目数，分母：所参加的室间质评机构输血相容性检测室间质评项目总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床用血%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '参加室间质评的输血相容性检测项目数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映输血相容性检测室间质评项目参加率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '参加室间质评的输血相容性检测项目数。', '无', '无', '无', NULL,
    '统计日期', '输血科', '参加室间质评的输血相容性检测项目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '参加室间质评的输血相容性检测项目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '所参加的室间质评机构输血相容性检测室间质评项目总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映输血相容性检测室间质评项目参加率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '所参加的室间质评机构输血相容性检测室间质评项目总数。', '无', '无', '无', NULL,
    '统计日期', '输血科', '所参加的室间质评机构输血相容性检测室间质评项目总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '所参加的室间质评机构输血相容性检测室间质评项目总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（五）输血相容性检测室间质评项目参加率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '参加室间质评的输血相容性检测项目数占所参加的室间质评机构输血相容性检测室间质评项目总数的百分比。', '《临床用血质量控制指标（2019版）》。', '反映输血相容性检测室间质评参加情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：参加室间质评的输血相容性检测项目数。分母：所参加的室间质评机构输血相容性检测室间质评项目总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '输血科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.5"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（五）输血相容性检测室间质评项目参加率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
