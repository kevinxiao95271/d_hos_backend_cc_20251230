-- ===========================================
-- 3.18.23 全身麻醉气管插管拔管后声音嘶哑发生率
-- 数据源：手工填报；分子：单位时间内全身麻醉气管插管拔管后声音嘶哑发生例次数，分母：同期全身麻醉气管插管总例次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%麻醉专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '单位时间内全身麻醉气管插管拔管后声音嘶哑发生例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映全身麻醉气管插管拔管后声音嘶哑发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '全身麻醉气管插管拔管后声音嘶哑指新发的、在拔管后72小时内没有恢复的声音嘶哑，排除咽喉、颈部以及胸部手术等原因。', '无', '无', '无', NULL,
    '统计日期', '全院', '单位时间内全身麻醉气管插管拔管后声音嘶哑发生例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.23.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '单位时间内全身麻醉气管插管拔管后声音嘶哑发生例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期全身麻醉气管插管总例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映全身麻醉气管插管拔管后声音嘶哑发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期全身麻醉气管插管总例次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期全身麻醉气管插管总例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.23.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期全身麻醉气管插管总例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '全身麻醉气管插管拔管后声音嘶哑发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，全身麻醉气管插管拔管后声音嘶哑发生例次数占同期全身麻醉气管插管总例次数的比例。', '麻醉专业医疗质量控制指标（2022版）。', '反映全麻气管插管拔管后声音嘶哑发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：单位时间内全身麻醉气管插管拔管后声音嘶哑发生例次数。分母：同期全身麻醉气管插管总例次数。', '无', '万分比（‱）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.23"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '全身麻醉气管插管拔管后声音嘶哑发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
