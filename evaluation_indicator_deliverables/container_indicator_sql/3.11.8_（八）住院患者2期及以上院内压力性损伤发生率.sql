-- ===========================================
-- 3.11.8 （八）住院患者2期及以上院内压力性损伤发生率
-- 数据源：手工填报；分子：住院患者2期及以上院内压力性损伤新发病例数，分母：同期住院患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%护理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '住院患者2期及以上院内压力性损伤新发病例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映住院患者2期及以上院内压力性损伤发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '单位时间内患者入院24小时后新发的2期及以上压力性损伤例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '住院患者2期及以上院内压力性损伤新发病例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院患者2期及以上院内压力性损伤新发病例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映住院患者2期及以上院内压力性损伤发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '住院患者总数为统计周期期初在院患者数与单位时间内新入院患者数之和。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期住院患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（八）住院患者2期及以上院内压力性损伤发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，住院患者2期及以上院内压力性损伤新发病例数与住院患者总数的比例。', '护理专业质量控制指标。', '反映院内压力性损伤防控情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：住院患者2期及以上院内压力性损伤新发病例数。分母：同期住院患者总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（八）住院患者2期及以上院内压力性损伤发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
