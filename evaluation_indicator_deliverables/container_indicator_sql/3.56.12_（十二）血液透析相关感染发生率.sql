-- ===========================================
-- 3.56.12 （十二）血液透析相关感染发生率
-- 数据源：手工填报；分子：血液透析患者新发生相关感染的例次数，分母：同期血液透析总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医院感染管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '血液透析患者新发生相关感染的例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映血液透析相关感染发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '血液透析患者新发生相关感染的例次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '血液透析患者新发生相关感染的例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.12.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '血液透析患者新发生相关感染的例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期血液透析总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映血液透析相关感染发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期血液透析总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期血液透析总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.12.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期血液透析总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十二）血液透析相关感染发生率', @category_id, NULL, 'permille', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '血液透析患者新发生相关感染的例次数占同期血液透析总人数的比例。', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映血液透析相关感染发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：血液透析患者新发生相关感染的例次数。分母：同期血液透析总人数。', '无', '千分率（‰）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1000.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.12"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十二）血液透析相关感染发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
