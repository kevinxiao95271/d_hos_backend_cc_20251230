-- ===========================================
-- 3.27.6 （六）门诊化疗严重不良反应发生率
-- 数据源：手工填报；分子：发生严重不良反应的门诊化疗患者人次数，分母：同期门诊化疗患者总人次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%门诊管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '发生严重不良反应的门诊化疗患者人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '门诊管理医疗质量控制指标（2024版）。', '反映门诊化疗严重不良反应发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '门诊化疗严重不良反应指化疗期间和随访中出现≥3级的治疗相关不良反应，参考《常见不良反应术语评定标准（CTCAE）5.0版》。', '无', '无', '无', NULL,
    '统计日期', '全院', '发生严重不良反应的门诊化疗患者人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.6.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '发生严重不良反应的门诊化疗患者人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期门诊化疗患者总人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '门诊管理医疗质量控制指标（2024版）。', '反映门诊化疗严重不良反应发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期门诊化疗患者总人次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期门诊化疗患者总人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.6.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期门诊化疗患者总人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（六）门诊化疗严重不良反应发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '发生严重不良反应的门诊化疗患者人次数占同期门诊化疗患者总人次数的比例。', '门诊管理医疗质量控制指标（2024版）。', '反映门诊化疗严重不良反应发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：发生严重不良反应的门诊化疗患者人次数。分母：同期门诊化疗患者总人次数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.6"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（六）门诊化疗严重不良反应发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
