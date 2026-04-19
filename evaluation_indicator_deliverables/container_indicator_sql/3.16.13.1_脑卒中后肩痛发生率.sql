-- ===========================================
-- 3.16.13.1 脑卒中后肩痛发生率
-- 数据源：手工填报；分子：单位时间内康复医学科住院期间发生肩痛的住院脑卒中患者数，分母：同期康复医学科住院脑卒中患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%康复医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '单位时间内康复医学科住院期间发生肩痛的住院脑卒中患者数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '康复医学专业医疗质量控制指标（2022版）。', '反映脑卒中后肩痛发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '脑卒中后肩痛包括复杂性区域疼痛综合征（肩手综合征）、肩部软组织疾病或损伤等。', '无', '无', '无', NULL,
    '统计日期', '全院', '单位时间内康复医学科住院期间发生肩痛的住院脑卒中患者数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.16.13.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '单位时间内康复医学科住院期间发生肩痛的住院脑卒中患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期康复医学科住院脑卒中患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '康复医学专业医疗质量控制指标（2022版）。', '反映脑卒中后肩痛发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期康复医学科住院脑卒中患者总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期康复医学科住院脑卒中患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.16.13.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期康复医学科住院脑卒中患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '脑卒中后肩痛发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，发生肩痛的康复医学科住院脑卒中患者数占同期康复医学科住院脑卒中患者总数的比例。', '康复医学专业医疗质量控制指标（2022版）。', '反映脑卒中后肩痛发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：单位时间内康复医学科住院期间发生肩痛的住院脑卒中患者数。分母：同期康复医学科住院脑卒中患者总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.16.13.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '脑卒中后肩痛发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
