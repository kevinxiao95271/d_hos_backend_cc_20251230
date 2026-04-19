-- ===========================================
-- 3.26.2 （二）急诊放射影像检查报告2小时完成率
-- 数据源：手工填报；分子：2小时内完成的急诊放射影像检查报告份数，分母：同期急诊放射影像检查报告总份数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%放射影像专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '2小时内完成的急诊放射影像检查报告份数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '放射影像专业医疗质量控制指标（2024版）。', '反映急诊放射影像检查报告2小时完成率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '急诊放射影像检查指急诊科开具的X线检查和CT检查。报告完成时间指从患者开始接受X线或CT检查到检查报告正式出具的时间。', '无', '无', '无', NULL,
    '统计日期', '全院', '2小时内完成的急诊放射影像检查报告份数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '2小时内完成的急诊放射影像检查报告份数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期急诊放射影像检查报告总份数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '放射影像专业医疗质量控制指标（2024版）。', '反映急诊放射影像检查报告2小时完成率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期急诊放射影像检查报告总份数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期急诊放射影像检查报告总份数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期急诊放射影像检查报告总份数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二）急诊放射影像检查报告2小时完成率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '2小时内完成检查的报告份数占同期急诊放射影像检查报告总份数的比例。', '放射影像专业医疗质量控制指标（2024版）。', '反映急诊放射影像检查报告2小时完成情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：2小时内完成的急诊放射影像检查报告份数。分母：同期急诊放射影像检查报告总份数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二）急诊放射影像检查报告2小时完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
