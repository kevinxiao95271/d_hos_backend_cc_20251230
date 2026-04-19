-- ===========================================
-- 3.16.2 （二）康复医学科医师床配比
-- 数据源：手工填报；分子：康复医学科医师人数，分母：同期康复医学科病房开放床位数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%康复医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '康复医学科医师人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '康复医学专业医疗质量控制指标（2022版）。', '反映康复医学科医师床配比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '康复医师指在本医疗机构注册、专门从事康复医疗工作的执业医师。', '无', '无', '无', NULL,
    '统计日期', '全院', '康复医学科医师人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.16.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '康复医学科医师人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期康复医学科病房开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '康复医学专业医疗质量控制指标（2022版）。', '反映康复医学科医师床配比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期康复医学科病房开放床位数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期康复医学科病房开放床位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.16.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期康复医学科病房开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二）康复医学科医师床配比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '康复医学科每张实际开放病床配备的康复医师数量。', '康复医学专业医疗质量控制指标（2022版）。', '反映康复医学科医师配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：康复医学科医师人数。分母：同期康复医学科病房开放床位数。每床至少配备0.25名医师。', '无', 'X：1', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.16.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二）康复医学科医师床配比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
