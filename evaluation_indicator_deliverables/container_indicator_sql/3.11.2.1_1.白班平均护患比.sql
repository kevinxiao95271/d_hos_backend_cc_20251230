-- ===========================================
-- 3.11.2.1 1.白班平均护患比
-- 数据源：手工填报；分子：每天白班护理患者数之和，分母：同期每天白班责任护士之和
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%护理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '每天白班护理患者数之和', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映白班平均护患比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内所有白班时段内护士护理患者总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '每天白班护理患者数之和',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.2.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '每天白班护理患者数之和' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期每天白班责任护士之和', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映白班平均护患比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内医院每天白班时段上班的直接护理患者的护士数总和。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期每天白班责任护士之和',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.2.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期每天白班责任护士之和' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '1.白班平均护患比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，每天白班责任护士数之和与其负责照护的住院患者数之和的比。', '护理专业质量控制指标。', '反映白班护患配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：每天白班护理患者数之和。分母：同期每天白班责任护士之和。', '无', '比值（1：X）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.2.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '1.白班平均护患比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
