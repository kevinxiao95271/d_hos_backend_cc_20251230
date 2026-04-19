-- ===========================================
-- 3.6.2 （二）《临床输血申请单》合格率
-- 数据源：手工填报；分子：填写规范且符合用血条件的申请单数，分母：同期输血科（血库）接收的申请单总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床用血%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '填写规范且符合用血条件的申请单数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映《临床输血申请单》合格率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '填写规范且符合用血条件的申请单数。', '无', '无', '无', NULL,
    '统计日期', '输血科', '填写规范且符合用血条件的申请单数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '填写规范且符合用血条件的申请单数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期输血科（血库）接收的申请单总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映《临床输血申请单》合格率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期输血科（血库）接收的申请单总数。', '无', '无', '无', NULL,
    '统计日期', '输血科', '同期输血科（血库）接收的申请单总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期输血科（血库）接收的申请单总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二）《临床输血申请单》合格率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '填写规范且符合用血条件的《临床输血申请单》数量占同期输血科（血库）接收的《临床输血申请单》总数的百分比。', '《临床用血质量控制指标（2019版）》。', '反映《临床输血申请单》填写及输血前评估的规范程度。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：填写规范且符合用血条件的申请单数。分母：同期输血科（血库）接收的申请单总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '输血科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二）《临床输血申请单》合格率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
