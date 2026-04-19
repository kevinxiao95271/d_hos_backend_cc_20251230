-- ===========================================
-- 3.18.24 麻醉后新发昏迷发生率
-- 数据源：手工填报；分子：单位时间内全身麻醉后新发昏迷发生例次数，分母：同期非颅脑手术全身麻醉总例次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%麻醉专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '单位时间内全身麻醉后新发昏迷发生例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映麻醉后新发昏迷发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '全身麻醉后新发昏迷指麻醉前清醒患者（格拉斯哥昏迷评分为15分）接受全身麻醉下非颅脑手术后没有苏醒，持续昏迷（格拉斯哥昏迷评分≤8分）超过24小时，除外因医疗目的给予镇静催眠者。', '无', '无', '无', NULL,
    '统计日期', '全院', '单位时间内全身麻醉后新发昏迷发生例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.24.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '单位时间内全身麻醉后新发昏迷发生例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期非颅脑手术全身麻醉总例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映麻醉后新发昏迷发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期非颅脑手术全身麻醉总例次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期非颅脑手术全身麻醉总例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.24.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期非颅脑手术全身麻醉总例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '麻醉后新发昏迷发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，全身麻醉后新发昏迷发生例次数占同期非颅脑手术全身麻醉总例次数的比例。', '麻醉专业医疗质量控制指标（2022版）。', '反映麻醉后新发昏迷发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：单位时间内全身麻醉后新发昏迷发生例次数。分母：同期非颅脑手术全身麻醉总例次数。', '无', '万分比（‱）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.24"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '麻醉后新发昏迷发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
