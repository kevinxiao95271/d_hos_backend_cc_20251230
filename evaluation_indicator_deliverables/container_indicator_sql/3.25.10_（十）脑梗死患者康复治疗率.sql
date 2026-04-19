-- ===========================================
-- 3.25.10 （十）脑梗死患者康复治疗率
-- 数据源：手工填报；分子：接受康复治疗的脑梗死患者人数，分母：同期脑梗死患者总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%脑损伤评价%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '接受康复治疗的脑梗死患者人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', 'continuous_monitor', @data_source_id, @data_source_param,
    '无', '脑损伤评价医疗质量控制指标（2024版）。', '反映脑梗死患者康复治疗率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '接受康复治疗的脑梗死患者人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '接受康复治疗的脑梗死患者人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '接受康复治疗的脑梗死患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期脑梗死患者总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', 'continuous_monitor', @data_source_id, @data_source_param,
    '无', '脑损伤评价医疗质量控制指标（2024版）。', '反映脑梗死患者康复治疗率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期脑梗死患者总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期脑梗死患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期脑梗死患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十）脑梗死患者康复治疗率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', 'continuous_monitor', @data_source_id, @data_source_param,
    '接受康复治疗的脑梗死患者人数占同期脑梗死患者总人数的比例。', '脑损伤评价医疗质量控制指标（2024版）。', '反映脑梗死患者康复治疗情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：接受康复治疗的脑梗死患者人数。分母：同期脑梗死患者总人数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.10"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十）脑梗死患者康复治疗率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
