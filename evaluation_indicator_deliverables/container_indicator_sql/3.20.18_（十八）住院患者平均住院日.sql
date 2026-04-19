-- ===========================================
-- 3.20.18 （十八）住院患者平均住院日
-- 数据源：手工填报；单位：天；分子：出院患者占用总床日数，分母：同期出院患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '出院患者占用总床日数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者平均住院日分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '出院患者占用总床日数指考核年度所有出院人数的住院床日之和，包括正常分娩、未产出院、住院经检查无病出院、未治出院及健康人进行人工流产或绝育手术后正常出院者的住院床日数。', '无', '无', '无', NULL,
    '统计日期', '全院', '出院患者占用总床日数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.18.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院患者占用总床日数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期出院患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者平均住院日分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期出院患者总数指同期出院人数，即考核年度内所有住院后出院的人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期出院患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.18.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十八）住院患者平均住院日', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '住院患者平均住院日是指考核年度医院平均每个出院患者占用的住院床日数，亦称出院患者平均住院日。', '精神专业质量控制指标（2020版）。', '反映住院患者平均住院日。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：出院患者占用总床日数。分母：同期出院患者总数。', '无', '天', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.18"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十八）住院患者平均住院日' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
