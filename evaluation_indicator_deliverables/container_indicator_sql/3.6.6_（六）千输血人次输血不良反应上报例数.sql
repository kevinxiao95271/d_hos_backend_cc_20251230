-- ===========================================
-- 3.6.6 （六）千输血人次输血不良反应上报例数
-- 数据源：手工填报；分子：输血不良反应上报例数，分母：输血人次/1000
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床用血%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '输血不良反应上报例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映千输血人次输血不良反应上报例数分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '输血不良反应上报例数。', '无', '无', '无', NULL,
    '统计日期', '输血科', '输血不良反应上报例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.6.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '输血不良反应上报例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '输血人次/1000', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映千输血人次输血不良反应上报例数分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '输血人次/1000，填报可为同期输血人次除以1000。', '无', '无', '无', NULL,
    '统计日期', '输血科', '输血人次/1000',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.6.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '输血人次/1000' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（六）千输血人次输血不良反应上报例数', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，每千输血人次中输血不良反应上报例数。', '《临床用血质量控制指标（2019版）》。', '反映输血不良反应上报情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：输血不良反应上报例数。分母：输血人次/1000。', '无', '例', '无', NULL,
    '统计日期', '输血科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.6"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（六）千输血人次输血不良反应上报例数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
