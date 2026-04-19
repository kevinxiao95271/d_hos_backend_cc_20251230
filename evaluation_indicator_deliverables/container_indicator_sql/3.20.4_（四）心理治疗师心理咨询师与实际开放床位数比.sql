-- ===========================================
-- 3.20.4 （四）心理治疗师/心理咨询师与实际开放床位数比
-- 数据源：手工填报；分子：心理治疗师/心理咨询师人员数，分母：精神科实际开放床位数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '心理治疗师/心理咨询师人员数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映心理治疗师/心理咨询师与床位数比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '心理治疗师/心理咨询师包括取得心理治疗师、心理咨询师专业技术资格证书并从事心理治疗/心理咨询相关工作的人员。', '无', '无', '无', NULL,
    '统计日期', '全院', '心理治疗师/心理咨询师人员数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '心理治疗师/心理咨询师人员数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '精神科实际开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映心理治疗师/心理咨询师与床位数比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '精神科实际开放床位数。', '无', '无', '无', NULL,
    '统计日期', '全院', '精神科实际开放床位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '精神科实际开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）心理治疗师/心理咨询师与实际开放床位数比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '心理治疗师/心理咨询师人员数与精神科实际开放床位数的比例。', '精神专业质量控制指标（2020版）。', '反映心理治疗师/心理咨询师配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：心理治疗师/心理咨询师人员数。分母：精神科实际开放床位数。', '无', 'X∶1', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）心理治疗师/心理咨询师与实际开放床位数比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
