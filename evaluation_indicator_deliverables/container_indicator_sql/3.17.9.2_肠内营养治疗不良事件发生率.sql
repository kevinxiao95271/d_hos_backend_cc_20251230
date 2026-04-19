-- ===========================================
-- 3.17.9.2 肠内营养治疗不良事件发生率
-- 数据源：手工填报；分子：实施肠内营养治疗不良事件发生例数，分母：同期实施肠内营养治疗总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床营养专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '实施肠内营养治疗不良事件发生例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '临床营养专业医疗质量控制指标（2022版）。', '反映肠内营养治疗不良事件发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '肠内营养不良事件主要包括胃肠道并发症、代谢并发症、感染并发症、置管并发症及配制与运送过程不良事件等。', '无', '无', '无', NULL,
    '统计日期', '全院', '实施肠内营养治疗不良事件发生例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.9.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实施肠内营养治疗不良事件发生例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期实施肠内营养治疗总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '临床营养专业医疗质量控制指标（2022版）。', '反映肠内营养治疗不良事件发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期实施肠内营养治疗总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期实施肠内营养治疗总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.9.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期实施肠内营养治疗总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '肠内营养治疗不良事件发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '实施肠内营养治疗过程中不良事件发生例数占同期实施肠内营养治疗总例数的比例。', '临床营养专业医疗质量控制指标（2022版）。', '反映肠内营养治疗安全性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：实施肠内营养治疗不良事件发生例数。分母：同期实施肠内营养治疗总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.9.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '肠内营养治疗不良事件发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
