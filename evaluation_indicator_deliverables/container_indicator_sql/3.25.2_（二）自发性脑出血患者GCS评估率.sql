-- ===========================================
-- 3.25.2 （二）自发性脑出血患者格拉斯哥昏迷量表（GCS）评估率
-- 数据源：手工填报；分子：完成GCS评分的自发性脑出血患者例数，分母：同期自发性脑出血患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%脑损伤评价%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '完成GCS评分的自发性脑出血患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', 'continuous_monitor', @data_source_id, @data_source_param,
    '无', '脑损伤评价医疗质量控制指标（2024版）。', '反映自发性脑出血患者GCS评估率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    'GCS评估应包括入院和出院前评估，参考《高血压性脑出血中国多学科诊治指南》和《中国脑出血诊治指南（2019）》。', '无', '无', '无', NULL,
    '统计日期', '全院', '完成GCS评分的自发性脑出血患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '完成GCS评分的自发性脑出血患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期自发性脑出血患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', 'continuous_monitor', @data_source_id, @data_source_param,
    '无', '脑损伤评价医疗质量控制指标（2024版）。', '反映自发性脑出血患者GCS评估率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期自发性脑出血患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期自发性脑出血患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期自发性脑出血患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二）自发性脑出血患者格拉斯哥昏迷量表（GCS）评估率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', 'continuous_monitor', @data_source_id, @data_source_param,
    '完成GCS评分的自发性脑出血患者例数占同期自发性脑出血患者总例数的比例。', '脑损伤评价医疗质量控制指标（2024版）。', '反映自发性脑出血患者GCS评估情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：完成GCS评分的自发性脑出血患者例数。分母：同期自发性脑出血患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二）自发性脑出血患者格拉斯哥昏迷量表（GCS）评估率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
