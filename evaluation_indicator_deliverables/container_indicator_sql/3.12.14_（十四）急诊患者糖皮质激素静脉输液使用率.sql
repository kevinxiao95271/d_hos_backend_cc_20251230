-- ===========================================
-- 3.12.14 （十四）急诊患者糖皮质激素静脉输液使用率
-- 数据源：手工填报；分子：急诊患者静脉使用糖皮质激素人数，分母：同期急诊患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '急诊患者静脉使用糖皮质激素人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映急诊患者糖皮质激素静脉输液使用率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '急诊静脉使用糖皮质激素的患者数。', '无', '无', '无', NULL,
    '统计日期', '全院', '急诊患者静脉使用糖皮质激素人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.14.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '急诊患者静脉使用糖皮质激素人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期急诊患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映急诊患者糖皮质激素静脉输液使用率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期急诊患者总数。对不能区分门急诊的基层医疗机构按门诊患者计算。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期急诊患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.14.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期急诊患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十四）急诊患者糖皮质激素静脉输液使用率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '急诊静脉使用糖皮质激素的患者数占同期急诊患者总数的比例。', '药事管理专业医疗质量控制指标（2020版）。', '反映急诊患者糖皮质激素静脉使用情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：急诊患者静脉使用糖皮质激素人数。分母：同期急诊患者总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.14"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十四）急诊患者糖皮质激素静脉输液使用率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
