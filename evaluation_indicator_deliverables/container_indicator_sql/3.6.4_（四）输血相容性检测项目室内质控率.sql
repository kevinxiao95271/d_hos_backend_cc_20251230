-- ===========================================
-- 3.6.4 （四）输血相容性检测项目室内质控率
-- 数据源：手工填报；分子：开展室内质控的输血相容性检测项目数，分母：医疗机构开展的输血相容性检测项目总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床用血%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '开展室内质控的输血相容性检测项目数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映输血相容性检测项目室内质控率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '开展室内质控的输血相容性检测项目数。', '无', '无', '无', NULL,
    '统计日期', '输血科', '开展室内质控的输血相容性检测项目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '开展室内质控的输血相容性检测项目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '医疗机构开展的输血相容性检测项目总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映输血相容性检测项目室内质控率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '医疗机构开展的输血相容性检测项目总数。', '无', '无', '无', NULL,
    '统计日期', '输血科', '医疗机构开展的输血相容性检测项目总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗机构开展的输血相容性检测项目总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）输血相容性检测项目室内质控率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '开展室内质控的输血相容性检测项目数占医疗机构开展的输血相容性检测项目总数的百分比。', '《临床用血质量控制指标（2019版）》。', '反映输血相容性检测室内质控开展情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：开展室内质控的输血相容性检测项目数。分母：医疗机构开展的输血相容性检测项目总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '输血科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）输血相容性检测项目室内质控率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
