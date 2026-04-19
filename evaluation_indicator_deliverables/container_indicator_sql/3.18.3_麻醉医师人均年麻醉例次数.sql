-- ===========================================
-- 3.18.3 麻醉医师人均年麻醉例次数
-- 数据源：手工填报；分子：麻醉科年麻醉总例次数，分母：同期麻醉科固定在岗医师总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%麻醉专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '麻醉科年麻醉总例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映麻醉医师人均年麻醉例次数分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '麻醉科年麻醉总例次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '麻醉科年麻醉总例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '麻醉科年麻醉总例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期麻醉科固定在岗医师总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映麻醉医师人均年麻醉例次数分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '参与临床麻醉工作的本院麻醉科医师，不包含规培住院医师（外院）、进修生、支援医师及多点执业医师。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期麻醉科固定在岗医师总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期麻醉科固定在岗医师总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '麻醉医师人均年麻醉例次数', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，麻醉科固定在岗医师平均完成的麻醉例次数。', '麻醉专业医疗质量控制指标（2022版）。', '反映麻醉医师工作负荷。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：麻醉科年麻醉总例次数。分母：同期麻醉科固定在岗医师总数。', '无', '例次数', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '麻醉医师人均年麻醉例次数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
