-- ===========================================
-- 3.20.2 （二）精神科护士与实际开放床位数比
-- 数据源：手工填报；分子：医院病区执业护士总人数，分母：精神科实际开放床位数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '医院病区执业护士总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映精神科护士与床位数比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '医院所配备的病区执业护士人数。每床位至少配备0.35名护士。', '无', '无', '无', NULL,
    '统计日期', '全院', '医院病区执业护士总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医院病区执业护士总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '精神科实际开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映精神科护士与床位数比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '精神科实际开放床位数。', '无', '无', '无', NULL,
    '统计日期', '全院', '精神科实际开放床位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '精神科实际开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二）精神科护士与实际开放床位数比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '医院所配备的病区执业护士人数与精神科实际开放床位数的比例。', '精神专业质量控制指标（2020版）。', '反映精神科护士配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：医院病区执业护士总人数。分母：精神科实际开放床位数。', '无', 'X∶1', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二）精神科护士与实际开放床位数比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
