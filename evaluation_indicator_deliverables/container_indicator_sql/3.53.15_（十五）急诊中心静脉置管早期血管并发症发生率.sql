-- ===========================================
-- 3.53.15 （十五）急诊中心静脉置管早期血管并发症发生率
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '急诊中心静脉置管发生早期血管并发症的例数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊科中心静脉置管操作质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '中心静脉置管早期血管并发症是指中心静脉导管置入时及置入24小时内发生的血管相关并发症，包括动脉损伤、严重出血、局部血肿、胸腔积血及腹膜后血肿等。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '急诊中心静脉置管发生早期血管并发症的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.15.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '急诊中心静脉置管发生早期血管并发症的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期急诊中心静脉置管总例数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊科中心静脉置管操作质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '中心静脉置管早期血管并发症是指中心静脉导管置入时及置入24小时内发生的血管相关并发症，包括动脉损伤、严重出血、局部血肿、胸腔积血及腹膜后血肿等。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '同期急诊中心静脉置管总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.15.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期急诊中心静脉置管总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十五）急诊中心静脉置管早期血管并发症发生率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, @data_source_param,
    '急诊中心静脉置管早期血管并发症发生率是指急诊中心静脉置管发生早期血管并发症的例数占同期急诊中心静脉置管总例数的比例。', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊科中心静脉置管操作质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '中心静脉置管早期血管并发症是指中心静脉导管置入时及置入24小时内发生的血管相关并发症，包括动脉损伤、严重出血、局部血肿、胸腔积血及腹膜后血肿等。', '同上。', '百分比（%）', '无', NULL,
    '就诊日期', '急诊科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.15"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十五）急诊中心静脉置管早期血管并发症发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
