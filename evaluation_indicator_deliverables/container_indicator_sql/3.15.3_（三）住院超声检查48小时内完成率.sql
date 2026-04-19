-- ===========================================
-- 3.15.3 （三）住院超声检查48小时内完成率
-- 数据源：手工填报；分子：48h内完成检查并出具报告的例数，分母：同期临床开具住院超声检查申请单总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%超声诊断专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '单位时间内在临床开具住院超声检查申请48h内完成检查并出具超声检查报告的例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '超声诊断专业医疗质量控制指标（2022版）。', '反映住院超声检查48小时内完成率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '在临床开具住院超声检查申请48小时内完成检查并出具超声检查报告的例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '单位时间内在临床开具住院超声检查申请48h内完成检查并出具超声检查报告的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.15.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '单位时间内在临床开具住院超声检查申请48h内完成检查并出具超声检查报告的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期临床开具住院超声检查申请单总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '超声诊断专业医疗质量控制指标（2022版）。', '反映住院超声检查48小时内完成率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期临床开具住院超声检查申请单总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期临床开具住院超声检查申请单总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.15.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期临床开具住院超声检查申请单总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（三）住院超声检查48小时内完成率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，在临床开具住院超声检查申请48小时内完成检查并出具超声检查报告的例数，占同期临床开具住院超声检查申请单总数的比例。', '超声诊断专业医疗质量控制指标（2022版）。', '反映住院超声检查及时性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：单位时间内在临床开具住院超声检查申请48h内完成检查并出具超声检查报告的例数。分母：同期临床开具住院超声检查申请单总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.15.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（三）住院超声检查48小时内完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
