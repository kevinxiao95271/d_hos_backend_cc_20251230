-- ===========================================
-- 3.27.11 （十一）每千门诊诊疗人次不良事件发生率
-- 数据源：手工填报；单位：千分比（‰）；分子：发生门诊不良事件例数，分母：同期门诊诊疗人次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%门诊管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '发生门诊不良事件例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '门诊管理医疗质量控制指标（2024版）。', '反映每千门诊诊疗人次不良事件发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '门诊不良事件指门诊患者在就诊时发生的不良事件和在门诊区域内发生的不良事件。', '无', '无', '无', NULL,
    '统计日期', '全院', '发生门诊不良事件例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.11.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '发生门诊不良事件例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期门诊诊疗人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '门诊管理医疗质量控制指标（2024版）。', '反映每千门诊诊疗人次不良事件发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期门诊诊疗人次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期门诊诊疗人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.11.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期门诊诊疗人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十一）每千门诊诊疗人次不良事件发生率', @category_id, NULL, 'decimal', 4, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '发生门诊不良事件例数占同期门诊诊疗人次数的比例，以千分比表示。', '门诊管理医疗质量控制指标（2024版）。', '反映每千门诊诊疗人次不良事件发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：发生门诊不良事件例数。分母：同期门诊诊疗人次数。指标值=(分子/分母)×1000‰。', '无', '千分比（‰）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.11"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十一）每千门诊诊疗人次不良事件发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
