-- ===========================================
-- 2.2.10.4 住院患者非计划手术率（分子+分母+比率）
-- 数据源：核心制度手术与护理明细查询
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '核心制度手术与护理明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

-- 分子 2.2.10.4.1
CALL sp_kpi_item_create(
    '行非计划手术的住院患者人次数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '行非计划手术的住院患者人次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映查房的质量。',
    '核心制度手术与护理明细查询', NULL, 'full', NULL, '无',
    '分子：行非计划手术的住院患者人次数。分母：同期住院患者总人次数。', '行非计划手术的住院患者人次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '是否行非计划手术的住院患者人次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[{"field":"同期住院患者人次数","operator":"=","value":1}]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '行非计划手术的住院患者人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.10.4.2
CALL sp_kpi_item_create(
    '同期住院患者总人次数_非计划手术分母', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '同期住院患者总人次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    '核心制度手术与护理明细查询', NULL, 'full', NULL, '无',
    '分母：同期住院患者总人次数。', '同期住院患者总人次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '同期住院患者人次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者总人次数_非计划手术分母' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.10.4
CALL sp_kpi_item_create(
    '住院患者非计划手术率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, @data_source_param,
    '行非计划手术的住院患者人次数占同期住院患者总人次数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映查房的质量。',
    '核心制度手术与护理明细查询', NULL, 'full', NULL, '无',
    '分子：行非计划手术的住院患者人次数。分母：同期住院患者总人次数。', '住院患者非计划手术率', '百分比（%）', NULL, '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型
FROM KPI_ITEM WHERE KPI_NAME = '住院患者非计划手术率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
