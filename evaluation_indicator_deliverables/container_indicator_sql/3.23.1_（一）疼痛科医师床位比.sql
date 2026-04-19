-- ===========================================
-- 3.23.1 （一）疼痛科医师床位比
-- 数据源：手工填报；单位：X∶1；分子：疼痛科医师人数，分母：病区实际开放床位数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%疼痛专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '疼痛科医师人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映疼痛科医师床位比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '疼痛科医师指在本医疗机构注册、全职从事疼痛科治疗工作的执业医师。', '无', '无', '无', NULL,
    '统计日期', '全院', '疼痛科医师人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '疼痛科医师人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '病区实际开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映疼痛科医师床位比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '病区实际开放床位数。', '无', '无', '无', NULL,
    '统计日期', '全院', '病区实际开放床位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '病区实际开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）疼痛科医师床位比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '疼痛科医师人数与病区实际开放床位数之比。', '疼痛专业医疗质量控制指标（2023版）。', '反映疼痛科医师资源配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：疼痛科医师人数。分母：病区实际开放床位数。', '无', 'X∶1', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）疼痛科医师床位比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
