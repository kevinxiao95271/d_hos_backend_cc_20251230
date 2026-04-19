-- ===========================================
-- 3.55.2 （二）每百张病床病理技术人员数
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%病理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '病理技术人员数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《病理专业医疗质量控制指标（2024年版）》。', '反映病理技术人员资源配置情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '病理技术人员指具有相应专业技术职务任职资格，进行病理切片、染色、免疫组化及分子病理等工作的专业技术人员。', '无', '无', '无', NULL,
    '统计日期', '病理科', '病理技术人员数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '病理技术人员数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期该医疗机构实际开放床位', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《病理专业医疗质量控制指标（2024年版）》。', '反映病理技术人员资源配置情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期该医疗机构实际开放床位数。', '无', '无', '无', NULL,
    '统计日期', '病理科', '同期该医疗机构实际开放床位',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期该医疗机构实际开放床位' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二）每百张病床病理技术人员数', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '每100张实际开放床位病理技术人员的数量。', '《病理专业医疗质量控制指标（2024年版）》。', '反映病理技术人员资源配置情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：病理技术人员数。分母：同期该医疗机构实际开放床位。', '无', '名', '无', NULL,
    '统计日期', '病理科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["病理科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.55.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二）每百张病床病理技术人员数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
