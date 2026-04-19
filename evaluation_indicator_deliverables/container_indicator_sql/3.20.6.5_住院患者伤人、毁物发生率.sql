-- ===========================================
-- 3.20.6.5 5.住院患者伤人、毁物发生率
-- 数据源：手工填报；分子：出院患者在住院期间发生伤人、毁物人次数，分母：同期出院患者总人次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '出院患者在住院期间发生伤人、毁物人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者伤人、毁物发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '伤人、毁物指患者对他人、物品造成威胁和或伤害的各种行为，可表现为言语攻击、身体攻击、物品攻击等。同一患者多次按实际发生例次计算。', '无', '无', '无', NULL,
    '统计日期', '全院', '出院患者在住院期间发生伤人、毁物人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.6.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院患者在住院期间发生伤人、毁物人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期出院患者总人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者伤人、毁物发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期出院患者总人次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期出院患者总人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.6.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '5.住院患者伤人、毁物发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '出院患者在住院期间发生伤人、毁物人次数占同期出院患者总人次数的比例。', '精神专业质量控制指标（2020版）。', '反映住院患者伤人、毁物发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：出院患者在住院期间发生伤人、毁物人次数。分母：同期出院患者总人次数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.6.5"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '5.住院患者伤人、毁物发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
