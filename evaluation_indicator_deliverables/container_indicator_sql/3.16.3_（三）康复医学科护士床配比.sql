-- ===========================================
-- 3.16.3 （三）康复医学科护士床配比
-- 数据源：手工填报；分子：康复医学科护士人数，分母：同期康复医学科病房开放床位数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%康复医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '康复医学科护士人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '康复医学专业医疗质量控制指标（2022版）。', '反映康复医学科护士床配比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '康复医学科岗位的执业护士总人数，含病产假、外出进修护士。排除未取得护士执业资格、未在本院注册的护士。', '无', '无', '无', NULL,
    '统计日期', '全院', '康复医学科护士人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.16.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '康复医学科护士人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期康复医学科病房开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '康复医学专业医疗质量控制指标（2022版）。', '反映康复医学科护士床配比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期康复医学科病房开放床位数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期康复医学科病房开放床位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.16.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期康复医学科病房开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（三）康复医学科护士床配比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '康复医学科平均实际开放病床配备的护士数量。', '康复医学专业医疗质量控制指标（2022版）。', '反映康复医学科护士配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：康复医学科护士人数。分母：同期康复医学科病房开放床位数。每床至少配备0.3名护士。', '无', 'X：1', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.16.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（三）康复医学科护士床配比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
