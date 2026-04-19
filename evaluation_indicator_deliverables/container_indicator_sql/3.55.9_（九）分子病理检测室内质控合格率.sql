-- ===========================================
-- 3.55.9 （九）分子病理检测室内质控合格率
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%病理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '分子病理检测室内质控合格报告数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《病理专业医疗质量控制指标（2024年版）》。', '反映分子病理检测室内质控质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子病理检测室内质控合格是指检测流程及结果达到行业标准要求。', '无', '无', '无', NULL,
    '统计日期', '病理科', '分子病理检测室内质控合格报告数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.9.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '分子病理检测室内质控合格报告数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期分子病理检测报告总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《病理专业医疗质量控制指标（2024年版）》。', '反映分子病理检测室内质控质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期分子病理检测报告总数。', '无', '无', '无', NULL,
    '统计日期', '病理科', '同期分子病理检测报告总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.9.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期分子病理检测报告总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（九）分子病理检测室内质控合格率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '分子病理检测室内质控合格率是指分子病理检测室内质控合格病例数占同期同种类型分子病理检测病例总数的比例。', '《病理专业医疗质量控制指标（2024年版）》。', '反映分子病理检测室内质控质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：分子病理检测室内质控合格报告数。分母：同期分子病理检测报告总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '病理科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.9"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（九）分子病理检测室内质控合格率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
