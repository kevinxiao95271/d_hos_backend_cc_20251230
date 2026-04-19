-- ===========================================
-- 3.11.6 （六）住院患者身体约束率
-- 数据源：手工填报；分子：住院患者身体约束日数，分母：同期住院患者实际占用床日数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%护理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '住院患者身体约束日数', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映住院患者身体约束率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内住院患者身体约束的总日数。', '无', '无', '无', NULL,
    '统计日期', '全院', '住院患者身体约束日数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.6.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院患者身体约束日数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院患者实际占用床日数', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映住院患者身体约束率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内住院病区每天凌晨0点住院患者实际占用的床日数总和。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期住院患者实际占用床日数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.6.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者实际占用床日数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（六）住院患者身体约束率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，住院患者身体约束日数与住院患者实际占用床日数的比例。', '护理专业质量控制指标。', '反映住院患者身体约束使用情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：住院患者身体约束日数。分母：同期住院患者实际占用床日数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.6"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（六）住院患者身体约束率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
