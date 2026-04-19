-- ===========================================
-- 3.17.8 使用胰岛素治疗的糖尿病住院患者营养治疗后胰岛素使用剂量减少率
-- 数据源：手工填报；分子：使用剂量减少的糖尿病住院患者数，分母：同期使用胰岛素治疗并接受营养治疗的糖尿病住院患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床营养专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '使用剂量减少的糖尿病住院患者数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '临床营养专业医疗质量控制指标（2022版）。', '反映营养治疗后胰岛素使用剂量减少率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '接受营养治疗后，胰岛素使用剂量减少的糖尿病住院患者数。', '无', '无', '无', NULL,
    '统计日期', '全院', '使用剂量减少的糖尿病住院患者数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '使用剂量减少的糖尿病住院患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期使用胰岛素治疗并接受营养治疗的糖尿病住院患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '临床营养专业医疗质量控制指标（2022版）。', '反映营养治疗后胰岛素使用剂量减少率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期使用胰岛素治疗并接受营养治疗的糖尿病住院患者总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期使用胰岛素治疗并接受营养治疗的糖尿病住院患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期使用胰岛素治疗并接受营养治疗的糖尿病住院患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '使用胰岛素治疗的糖尿病住院患者营养治疗后胰岛素使用剂量减少率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '接受营养治疗后，胰岛素使用剂量减少的糖尿病住院患者数占同期使用胰岛素治疗并接受营养治疗的糖尿病住院患者总数的比例。', '临床营养专业医疗质量控制指标（2022版）。', '反映营养治疗对胰岛素用量的影响。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：使用剂量减少的糖尿病住院患者数。分母：同期使用胰岛素治疗并接受营养治疗的糖尿病住院患者总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '使用胰岛素治疗的糖尿病住院患者营养治疗后胰岛素使用剂量减少率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
