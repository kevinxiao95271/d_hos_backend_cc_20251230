-- ===========================================
-- 3.55.10 （十）免疫组化染色室间质评合格率
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%病理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '免疫组化染色室间质评合格次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《病理专业医疗质量控制指标（2024年版）》。', '反映免疫组化染色室间质评质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '免疫组化染色室间质评合格是指参加省级以上病理质控中心组织的免疫组化染色室间质评并达到合格标准。', '无', '无', '无', NULL,
    '统计日期', '病理科', '免疫组化染色室间质评合格次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '免疫组化染色室间质评合格次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期免疫组化染色室间质评总次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《病理专业医疗质量控制指标（2024年版）》。', '反映免疫组化染色室间质评质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期免疫组化染色室间质评总次数。', '无', '无', '无', NULL,
    '统计日期', '病理科', '同期免疫组化染色室间质评总次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期免疫组化染色室间质评总次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十）免疫组化染色室间质评合格率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '免疫组化染色室间质评合格率是指免疫组化染色室间质评合格次数占同期免疫组化染色室间质评总次数的比例。', '《病理专业医疗质量控制指标（2024年版）》。', '反映免疫组化染色室间质评质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：免疫组化染色室间质评合格次数。分母：同期免疫组化染色室间质评总次数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '病理科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.10"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十）免疫组化染色室间质评合格率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
