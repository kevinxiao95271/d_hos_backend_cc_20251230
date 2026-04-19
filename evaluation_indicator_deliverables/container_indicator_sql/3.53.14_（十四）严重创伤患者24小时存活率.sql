-- ===========================================
-- 3.53.14 （十四）严重创伤患者24小时存活率
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '就诊24小时后存活的严重创伤患者人数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊严重创伤的救治能力。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：严重创伤患者在急诊科救治24小时后存活的总例数。分母：同期严重创伤患者在急诊科救治的总例数。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '就诊24小时后存活的严重创伤患者人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.14.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '就诊24小时后存活的严重创伤患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期严重创伤患者总人数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊严重创伤的救治能力。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：严重创伤患者在急诊科救治24小时后存活的总例数。分母：同期严重创伤患者在急诊科救治的总例数。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '同期严重创伤患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.14.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期严重创伤患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十四）严重创伤患者24小时存活率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '严重创伤患者24小时存活率是指就诊24小时后存活的严重创伤患者人数占同期严重创伤患者总人数的比例。', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊严重创伤的救治能力。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：严重创伤患者在急诊科救治24小时后存活的总例数。分母：同期严重创伤患者在急诊科救治的总例数。', '同上。', '百分比（%）', '无', NULL,
    '就诊日期', '急诊科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.14"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十四）严重创伤患者24小时存活率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
