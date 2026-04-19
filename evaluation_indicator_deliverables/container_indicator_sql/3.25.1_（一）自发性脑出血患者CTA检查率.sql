-- ===========================================
-- 3.25.1 （一）自发性脑出血患者电子计算机断层扫描血管成像（CTA）检查率
-- 数据源：手工填报；分子：行CTA的自发性脑出血患者例数，分母：同期自发性脑出血患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%脑损伤评价%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '行CTA的自发性脑出血患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', 'continuous_monitor', @data_source_id, @data_source_param,
    '无', '脑损伤评价医疗质量控制指标（2024版）。', '反映自发性脑出血患者CTA检查率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '自发性脑出血指除外伤、明显的结构性原因（如血管畸形、囊状动脉瘤、易出血的肿瘤、手术）引起的原发性脑出血。', '无', '无', '无', NULL,
    '统计日期', '全院', '行CTA的自发性脑出血患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '行CTA的自发性脑出血患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期自发性脑出血患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', 'continuous_monitor', @data_source_id, @data_source_param,
    '无', '脑损伤评价医疗质量控制指标（2024版）。', '反映自发性脑出血患者CTA检查率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期自发性脑出血患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期自发性脑出血患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期自发性脑出血患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）自发性脑出血患者电子计算机断层扫描血管成像（CTA）检查率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', 'continuous_monitor', @data_source_id, @data_source_param,
    '行CTA的自发性脑出血患者例数占同期自发性脑出血患者总例数的比例。', '脑损伤评价医疗质量控制指标（2024版）。', '反映自发性脑出血患者CTA检查情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：行CTA的自发性脑出血患者例数。分母：同期自发性脑出血患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）自发性脑出血患者电子计算机断层扫描血管成像（CTA）检查率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
