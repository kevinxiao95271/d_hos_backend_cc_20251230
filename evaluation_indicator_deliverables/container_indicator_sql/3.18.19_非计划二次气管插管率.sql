-- ===========================================
-- 3.18.19 非计划二次气管插管率
-- 数据源：手工填报；分子：单位时间内非计划二次气管插管患者数，分母：同期术后气管插管拔除患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%麻醉专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '单位时间内非计划二次气管插管患者数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映非计划二次气管插管率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '非计划二次气管插管指患者术后气管插管拔除后6小时内非计划再次行气管插管术，不包括因非计划二次手术而接受再次气管插管。', '无', '无', '无', NULL,
    '统计日期', '全院', '单位时间内非计划二次气管插管患者数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.19.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '单位时间内非计划二次气管插管患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期术后气管插管拔除患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映非计划二次气管插管率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期术后气管插管拔除患者总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期术后气管插管拔除患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.19.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期术后气管插管拔除患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '非计划二次气管插管率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，非计划二次气管插管患者数占同期术后气管插管拔除患者总数的比例。', '麻醉专业医疗质量控制指标（2022版）。', '反映非计划二次气管插管发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：单位时间内非计划二次气管插管患者数。分母：同期术后气管插管拔除患者总数。', '无', '千分比（‰）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.19"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '非计划二次气管插管率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
