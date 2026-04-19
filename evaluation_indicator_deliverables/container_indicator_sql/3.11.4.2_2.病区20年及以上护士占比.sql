-- ===========================================
-- 3.11.4.2 2.病区20年及以上护士占比
-- 数据源：手工填报；分子：病区工作年限≥20年的护士总数，分母：同期病区执业护士总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%护理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '病区工作年限≥20年的护士总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映病区20年及以上护士占比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '病区工作年限≥20年的护士总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '病区工作年限≥20年的护士总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.4.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '病区工作年限≥20年的护士总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期病区执业护士总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映病区20年及以上护士占比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期病区执业护士总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期病区执业护士总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.4.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期病区执业护士总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '2.病区20年及以上护士占比', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，在病区工作、工作年限≥20年的护士在病区执业护士中所占的比例。', '护理专业质量控制指标。', '反映病区护士梯队结构。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：病区工作年限≥20年的护士总数。分母：同期病区执业护士总人数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.4.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '2.病区20年及以上护士占比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
