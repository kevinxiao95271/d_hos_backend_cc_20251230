-- ===========================================
-- 3.12.10 （十）严重或新的药品不良反应上报率
-- 数据源：手工填报；分子：严重或新的药品不良反应上报人数，分母：同期用药患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '严重或新的药品不良反应上报人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映严重或新的药品不良反应上报率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '医疗机构单位时间内上报的严重或新的药品不良反应人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '严重或新的药品不良反应上报人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '严重或新的药品不良反应上报人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期用药患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映严重或新的药品不良反应上报率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '单位时间内门诊、急诊和住院患者用药人数总和。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期用药患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期用药患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十）严重或新的药品不良反应上报率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '医疗机构单位时间内上报的严重或新的药品不良反应人数占同期用药患者总数的比例。', '药事管理专业医疗质量控制指标（2020版）。', '反映药品不良反应监测与上报情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：严重或新的药品不良反应上报人数。分母：同期用药患者总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.10"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十）严重或新的药品不良反应上报率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
