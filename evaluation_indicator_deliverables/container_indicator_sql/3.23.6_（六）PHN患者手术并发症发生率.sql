-- ===========================================
-- 3.23.6 （六）PHN患者手术并发症发生率
-- 数据源：手工填报；分子：PHN患者行手术治疗发生并发症的例数，分母：同期PHN患者手术治疗总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%疼痛专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    'PHN患者行手术治疗发生并发症的例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映PHN患者手术并发症发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '手术并发症指与手术相关的感染、出血、气胸、神经功能障碍、器官组织损伤、全脊髓麻醉。', '无', '无', '无', NULL,
    '统计日期', '全院', 'PHN患者行手术治疗发生并发症的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.6.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'PHN患者行手术治疗发生并发症的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期PHN患者手术治疗总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映PHN患者手术并发症发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期PHN患者手术治疗总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期PHN患者手术治疗总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.6.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期PHN患者手术治疗总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（六）PHN患者手术并发症发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    'PHN患者行手术治疗发生并发症的例数占同期PHN患者手术治疗总例数的比例。', '疼痛专业医疗质量控制指标（2023版）。', '反映PHN患者手术并发症发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：PHN患者行手术治疗发生并发症的例数。分母：同期PHN患者手术治疗总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.6"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（六）PHN患者手术并发症发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
