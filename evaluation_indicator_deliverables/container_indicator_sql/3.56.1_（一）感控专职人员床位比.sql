-- ===========================================
-- 3.56.1 （一）感控专职人员床位比
-- 数据源：手工填报；分子：同期感控专职人员数，分母：实际开放床位数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医院感染管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '实际开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映感控专职人员床位比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '实际开放床位数。', '无', '无', '无', NULL,
    '统计日期', '全院', '实际开放床位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实际开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期感控专职人员数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映感控专职人员床位比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期感控专职人员数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期感控专职人员数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期感控专职人员数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）感控专职人员床位比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '感控专职人员数与实际开放床位数的比值。', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映医疗机构感控人力配置情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：同期感控专职人员数。分母：实际开放床位数。', '无', '比值', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）感控专职人员床位比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
