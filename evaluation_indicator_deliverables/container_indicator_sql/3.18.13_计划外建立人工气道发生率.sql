-- ===========================================
-- 3.18.13 计划外建立人工气道发生率
-- 数据源：手工填报；分子：单位时间内计划外建立人工气道的麻醉科患者数，分母：同期麻醉科患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%麻醉专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '单位时间内计划外建立人工气道的麻醉科患者数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映计划外建立人工气道发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '计划外建立人工气道指患者进入手术室后直至离开手术室前，因呼吸骤停或严重呼吸抑制等而进行的人工气道建立，包括气管插管、喉罩置入和紧急气管造口术。', '无', '无', '无', NULL,
    '统计日期', '全院', '单位时间内计划外建立人工气道的麻醉科患者数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.13.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '单位时间内计划外建立人工气道的麻醉科患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期麻醉科患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映计划外建立人工气道发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期麻醉科患者总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期麻醉科患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.13.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期麻醉科患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '计划外建立人工气道发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，计划外建立人工气道的麻醉科患者数占同期麻醉科患者总数的比例。', '麻醉专业医疗质量控制指标（2022版）。', '反映计划外建立人工气道发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：单位时间内计划外建立人工气道的麻醉科患者数。分母：同期麻醉科患者总数。', '无', '千分比（‰）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.13"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '计划外建立人工气道发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
