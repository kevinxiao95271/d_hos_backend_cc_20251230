-- ===========================================
-- 3.27.8 （八）门诊危急值30分钟内通报完成率
-- 数据源：手工填报；分子：30分钟内完成通报的门诊危急值例数，分母：同期全部门诊危急值例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%门诊管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '30分钟内完成通报的门诊危急值例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '门诊管理医疗质量控制指标（2024版）。', '反映门诊危急值30分钟内通报完成率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '门诊危急值指门诊患者在各项检查、检验中发现的危急值。30分钟内完成通报指发现危急值30分钟内通知到患者或家属。', '无', '无', '无', NULL,
    '统计日期', '全院', '30分钟内完成通报的门诊危急值例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '30分钟内完成通报的门诊危急值例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期全部门诊危急值例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '门诊管理医疗质量控制指标（2024版）。', '反映门诊危急值30分钟内通报完成率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期全部门诊危急值例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期全部门诊危急值例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期全部门诊危急值例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（八）门诊危急值30分钟内通报完成率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '30分钟内完成通报的门诊危急值例数占同期门诊危急值总例数的比例。', '门诊管理医疗质量控制指标（2024版）。', '反映门诊危急值30分钟内通报完成情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：30分钟内完成通报的门诊危急值例数。分母：同期全部门诊危急值例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（八）门诊危急值30分钟内通报完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
