-- ===========================================
-- 3.23.8 （八）癌症疼痛患者24h内疼痛全面评估完成率
-- 数据源：手工填报；分子：入院24小时内完成疼痛全面评估的癌症疼痛患者例数，分母：同期癌症疼痛住院患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%疼痛专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '入院24小时内完成疼痛全面评估的癌症疼痛患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映癌症疼痛患者24h内疼痛全面评估完成率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '疼痛全面评估指使用简明疼痛评估量表(BPI)等方法对患者疼痛程度、性质、部位等方面进行全面评估。癌症疼痛诊断编码包括R52.1、R52.2、R52.9。', '无', '无', '无', NULL,
    '统计日期', '全院', '入院24小时内完成疼痛全面评估的癌症疼痛患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '入院24小时内完成疼痛全面评估的癌症疼痛患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期癌症疼痛住院患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映癌症疼痛患者24h内疼痛全面评估完成率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期癌症疼痛住院患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期癌症疼痛住院患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期癌症疼痛住院患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（八）癌症疼痛患者24h内疼痛全面评估完成率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '入院24小时内完成疼痛全面评估的癌症疼痛患者例数占同期癌症疼痛住院患者总例数的比例。', '疼痛专业医疗质量控制指标（2023版）。', '反映癌症疼痛患者24h内疼痛全面评估完成情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：入院24小时内完成疼痛全面评估的癌症疼痛患者例数。分母：同期癌症疼痛住院患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（八）癌症疼痛患者24h内疼痛全面评估完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
