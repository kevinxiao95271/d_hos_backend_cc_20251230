-- ===========================================
-- 2.1.9 （九）出院患者微创手术占比（分子 2.1.9.1 + 分母 2.1.9.2 + 比率 2.1.9）
-- 数据源：病案首页明细查询
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '病案首页明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

-- 分子 2.1.9.1：出院患者微创手术台次数
CALL sp_kpi_item_create(
    '出院患者微创手术台次数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '出院患者微创手术人数，同一次住院多次微创手术按1人统计。', '《2.1 医疗服务能力指标.csv》', '反映微创技术应用。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分子：微创手术人数。分母：同期出院患者手术（含介入）人次数。', '出院患者微创手术台次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '微创手术台次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[{"field":"微创手术台次数","operator":">","value":0}]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.9.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院患者微创手术台次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.1.9.2：同期出院患者手术台次数
CALL sp_kpi_item_create(
    '同期出院患者手术台次数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '同期出院患者手术（含介入）人次数，统一使用MR数据源。', '《2.1 医疗服务能力指标.csv》', '反映手术总量。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分母：同期出院患者手术（含介入）人次数。', '同期出院患者手术台次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '手术台次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[{"field":"手术台次数","operator":">","value":0}]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.9.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者手术台次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.1.9：（九）出院患者微创手术占比
CALL sp_kpi_item_create(
    '（九）出院患者微创手术占比', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '出院患者微创手术占比是指出院患者实施微创手术台次数占同期出院患者手术台次数的比例。', '《2.1 医疗服务能力指标.csv》', '反映微创技术应用与医疗服务能力。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分子：微创手术人数。分母：同期出院患者手术（含介入）人次数。微创手术目录参照国家三级公立医院绩效考核微创手术目录。', '出院患者微创手术占比', '百分比（%）', NULL, '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.9"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（九）出院患者微创手术占比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
