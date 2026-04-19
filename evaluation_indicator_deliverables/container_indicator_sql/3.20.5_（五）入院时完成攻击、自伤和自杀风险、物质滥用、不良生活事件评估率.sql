-- ===========================================
-- 3.20.5 （五）入院时完成攻击、自伤和自杀风险、物质滥用、不良生活事件评估率
-- 数据源：手工填报；分子：住院患者入院时完成攻击、自伤和自杀风险、物质滥用、不良生活事件评估人数，分母：同期入院患者总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '住院患者入院时完成攻击、自伤和自杀风险、物质滥用、不良生活事件评估人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映入院时完成相关评估率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '入院时根据病情选择风险评估表进行评估，评估量表包括YMRS、攻击风险评估表、HAMD、ADL、PANSS、TESS、护士观察量表、自杀危险因素评估表等。', '无', '无', '无', NULL,
    '统计日期', '全院', '住院患者入院时完成攻击、自伤和自杀风险、物质滥用、不良生活事件评估人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院患者入院时完成攻击、自伤和自杀风险、物质滥用、不良生活事件评估人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期入院患者总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映入院时完成相关评估率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期入院患者总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期入院患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期入院患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（五）入院时完成攻击、自伤和自杀风险、物质滥用、不良生活事件评估率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '住院患者入院时完成攻击、自伤和自杀风险、物质滥用、不良生活事件评估人数占同期入院患者总人数的比例。', '精神专业质量控制指标（2020版）。', '反映入院时风险评估完成情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：住院患者入院时完成攻击、自伤和自杀风险、物质滥用、不良生活事件评估人数。分母：同期入院患者总人数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.5"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（五）入院时完成攻击、自伤和自杀风险、物质滥用、不良生活事件评估率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
