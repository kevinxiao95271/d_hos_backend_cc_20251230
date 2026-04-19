-- ===========================================
-- 3.26.3 （三）放射影像报告书写规范率
-- 数据源：手工填报；分子：书写规范的放射影像检查报告例数，分母：同期放射影像检查总例次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%放射影像专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '书写规范的放射影像检查报告例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '放射影像专业医疗质量控制指标（2024版）。', '反映放射影像报告书写规范率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '书写规范指：1.有放射科医生签名；2.结论（或印象）与影像描述内容相符；3.无明显错误（所查脏器缺如但报告为正常、描述器官/部位/方位/单位/数据错误、未删除有歧义模板文字、患者信息不符或缺失等）。', '无', '无', '无', NULL,
    '统计日期', '全院', '书写规范的放射影像检查报告例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '书写规范的放射影像检查报告例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期放射影像检查总例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '放射影像专业医疗质量控制指标（2024版）。', '反映放射影像报告书写规范率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期放射影像检查总例次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期放射影像检查总例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期放射影像检查总例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（三）放射影像报告书写规范率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '书写规范的放射影像检查报告份数占同期放射影像检查报告总份数的比例。', '放射影像专业医疗质量控制指标（2024版）。', '反映放射影像报告书写规范情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：书写规范的放射影像检查报告例数。分母：同期放射影像检查总例次数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（三）放射影像报告书写规范率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
