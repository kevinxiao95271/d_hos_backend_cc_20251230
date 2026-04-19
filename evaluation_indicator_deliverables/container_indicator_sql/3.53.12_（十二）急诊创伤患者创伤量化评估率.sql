-- ===========================================
-- 3.53.12 （十二）急诊创伤患者创伤量化评估率
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '急诊创伤患者应用创伤评分系统完成量化评估的例数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊创伤评估的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '创伤评分系统包括修正创伤评分（RTS）、简明损伤评分（AIS）、损伤严重度评分（ISS）、创伤评分和损伤严重程度评分（TRISS）、国际分类损伤严重程度评分（ICISS）、创伤严重程度特征评分（ASCOT）等，至少使用上述一种评分进行创伤患者评估，即视为完成创伤量化评估。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '急诊创伤患者应用创伤评分系统完成量化评估的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.12.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '急诊创伤患者应用创伤评分系统完成量化评估的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期急诊创伤患者总例数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊创伤评估的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '创伤评分系统包括修正创伤评分（RTS）、简明损伤评分（AIS）、损伤严重度评分（ISS）等，至少使用上述一种评分进行创伤患者评估，即视为完成创伤量化评估。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '同期急诊创伤患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.12.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期急诊创伤患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十二）急诊创伤患者创伤量化评估率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '急诊创伤患者创伤量化评估率是指急诊创伤患者应用创伤评分系统完成量化评估的例数占同期急诊创伤患者总例数的比例。', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊创伤评估的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '创伤评分系统包括修正创伤评分（RTS）、简明损伤评分（AIS）、损伤严重度评分（ISS）、创伤评分和损伤严重程度评分（TRISS）、国际分类损伤严重程度评分（ICISS）、创伤严重程度特征评分（ASCOT）等，至少使用上述一种评分进行创伤患者评估，即视为完成创伤量化评估。', '同上。', '百分比（%）', '无', NULL,
    '就诊日期', '急诊科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.12"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十二）急诊创伤患者创伤量化评估率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
