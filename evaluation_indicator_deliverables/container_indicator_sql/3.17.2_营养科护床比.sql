-- ===========================================
-- 3.17.2 营养科护床比
-- 数据源：手工填报；分子：营养科护士总数，分母：同期医疗机构实际开放床位数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床营养专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '营养科护士总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '临床营养专业医疗质量控制指标（2022版）。', '反映营养科护床比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '营养科护士指取得护士（师）执业资格，在本医疗机构注册并从事护士（师）工作的营养科在职人员。', '无', '无', '无', NULL,
    '统计日期', '全院', '营养科护士总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '营养科护士总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期医疗机构实际开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '临床营养专业医疗质量控制指标（2022版）。', '反映营养科护床比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期医疗机构实际开放床位数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期医疗机构实际开放床位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期医疗机构实际开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '营养科护床比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '营养科护士总数与同期医疗机构实际开放床位数之比。', '临床营养专业医疗质量控制指标（2022版）。', '反映营养科护士配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：营养科护士总数。分母：同期医疗机构实际开放床位数。', '无', '1:X', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '营养科护床比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
