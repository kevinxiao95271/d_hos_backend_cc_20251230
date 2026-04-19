-- ===========================================
-- 2.2.10.25 麻醉医师手术时间重合率（分子+分母+比率）
-- 数据源：核心制度手术时间重合明细查询
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '核心制度手术时间重合明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

-- 分子 2.2.10.25.1
CALL sp_kpi_item_create(
    '同一时间内手术麻醉医师为同一人的手术例数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '同一时间内手术麻醉医师为同一人的手术例数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映麻醉医师参与手术安全核查情况。',
    '核心制度手术时间重合明细查询', NULL, 'full', NULL, '无',
    '本指标中「同一时间」是指手术未结束时间与其他手术开始时间重合。', '同一时间内手术麻醉医师为同一人的手术例数', '无', NULL, '无',
    '出院日期', '出院科室名称', '是否麻醉医师时间重合', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[{"field":"手术例数","operator":"=","value":1}]', '["住院号","病案号","患者姓名","手术时间","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.25.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同一时间内手术麻醉医师为同一人的手术例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.10.25.2
CALL sp_kpi_item_create(
    '同期住院患者手术总例数_麻醉重合分母', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '同期住院患者手术总例数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    '核心制度手术时间重合明细查询', NULL, 'full', NULL, '无',
    '分母：同期住院患者手术总例数。', '同期住院患者手术总例数', '无', NULL, '无',
    '出院日期', '出院科室名称', '手术例数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","手术时间","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.25.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者手术总例数_麻醉重合分母' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.10.25
CALL sp_kpi_item_create(
    '麻醉医师手术时间重合率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, @data_source_param,
    '同一时间内手术麻醉医师为同一人的手术例数占同期住院患者手术总例数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映麻醉医师参与手术安全核查情况。',
    '核心制度手术时间重合明细查询', NULL, 'full', NULL, '无',
    '本指标中「同一时间」是指手术未结束时间与其他手术开始时间重合。', '麻醉医师手术时间重合率', '百分比（%）', NULL, '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","手术时间","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.25"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型
FROM KPI_ITEM WHERE KPI_NAME = '麻醉医师手术时间重合率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
