-- ===========================================
-- 3.11.1.2 2.重症医学科床护比
-- 数据源：手工填报；分子：重症医学科执业护士人数，分母：同期重症医学科实际开放床位数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%护理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '重症医学科执业护士人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映重症医学科床护比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '重症医学科执业护士人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '重症医学科执业护士人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.1.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '重症医学科执业护士人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期重症医学科实际开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映重症医学科床护比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期重症医学科实际开放床位数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期重症医学科实际开放床位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.1.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期重症医学科实际开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '2.重症医学科床护比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，重症医学科实际开放床位与所配备的执业护士人数的比。', '护理专业质量控制指标。', '反映重症医学科护理人力配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：重症医学科执业护士人数。分母：同期重症医学科实际开放床位数。', '无', '比值（1：X）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.1.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '2.重症医学科床护比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
