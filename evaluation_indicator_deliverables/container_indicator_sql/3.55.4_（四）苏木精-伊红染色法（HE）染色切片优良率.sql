-- ===========================================
-- 3.55.4 （四）苏木精-伊红染色法（HE）染色切片优良率
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%病理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    'HE染色优良切片数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《病理专业医疗质量控制指标（2024年版）》。', '反映HE染色切片质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    'HE染色优良切片是指达到行业优良标准要求的HE染色切片。', '无', '无', '无', NULL,
    '统计日期', '病理科', 'HE染色优良切片数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'HE染色优良切片数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期HE染色切片总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《病理专业医疗质量控制指标（2024年版）》。', '反映HE染色切片质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期HE染色切片总数。', '无', '无', '无', NULL,
    '统计日期', '病理科', '同期HE染色切片总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期HE染色切片总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）苏木精-伊红染色法（Hematoxylin Eosinstaining，HE）染色切片优良率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    'HE染色切片优良率是指HE染色优良切片数占同期HE染色切片总数的比例。', '《病理专业医疗质量控制指标（2024年版）》。', '反映HE染色切片质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：HE染色优良切片数。分母：同期HE染色切片总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '病理科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）苏木精-伊红染色法（Hematoxylin Eosinstaining，HE）染色切片优良率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
