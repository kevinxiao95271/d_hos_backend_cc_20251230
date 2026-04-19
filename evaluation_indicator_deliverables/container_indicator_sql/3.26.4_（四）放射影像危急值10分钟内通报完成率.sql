-- ===========================================
-- 3.26.4 （四）放射影像危急值10分钟内通报完成率
-- 数据源：手工填报；分子：发现放射影像危急值后10分钟内完成通报的病例数，分母：同期放射影像危急值总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%放射影像专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '发现放射影像危急值后10分钟内完成通报的病例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '放射影像专业医疗质量控制指标（2024版）。', '反映放射影像危急值10分钟内通报完成率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '危急值通报完成指按医疗机构认可流程向临床相关部门或医师完成通报，且双方均有通报时间、内容及通报/接收人员署名记录。危急值包括急性肺栓塞、急性主动脉夹层、急性脑出血、脑疝、消化道穿孔等。', '无', '无', '无', NULL,
    '统计日期', '全院', '发现放射影像危急值后10分钟内完成通报的病例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '发现放射影像危急值后10分钟内完成通报的病例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期放射影像危急值总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '放射影像专业医疗质量控制指标（2024版）。', '反映放射影像危急值10分钟内通报完成率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期放射影像危急值总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期放射影像危急值总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期放射影像危急值总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）放射影像危急值10分钟内通报完成率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '发现放射影像危急值后10分钟内完成通报的病例数占同期放射影像危急值总例数的比例。', '放射影像专业医疗质量控制指标（2024版）。', '反映放射影像危急值通报完成情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：发现放射影像危急值后10分钟内完成通报的病例数。分母：同期放射影像危急值总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）放射影像危急值10分钟内通报完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
