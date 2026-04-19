-- ===========================================
-- 2.1.8 （八）出院患者手术占比（分子 2.1.8.1 + 分母 2.1.8.2 + 比率 2.1.8）
-- 数据源：病案首页明细查询（同期出院口径统一）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '病案首页明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

-- 分子 2.1.8.1：出院患者手术台次数
CALL sp_kpi_item_create(
    '出院患者手术台次数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '出院患者手术人次数，同一次住院多次手术按1人统计，手术和介入治疗人数累加。', '《2.1 医疗服务能力指标.csv》', '反映医疗机构手术服务能力。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分子：出院患者手术人次数。分母：同期出院总人次数。', '出院患者手术台次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '手术台次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[{"field":"手术台次数","operator":">","value":0}]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院患者手术台次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.1.8.2：同期出院患者总人次数
CALL sp_kpi_item_create(
    '同期出院患者总人次数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '同期出院总人次数，统一使用MR数据源。', '《2.1 医疗服务能力指标.csv》', '反映医疗机构出院规模。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分母：指同期出院总人次数。', '同期出院患者总人次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '出院人次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.1.8：（八）出院患者手术占比
CALL sp_kpi_item_create(
    '（八）出院患者手术占比', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '出院患者手术占比是指年度出院患者实施手术治疗台次数占同期出院患者总人次数的比例。', '《2.1 医疗服务能力指标.csv》', '反映医疗机构手术服务能力与诊疗技术能力。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分子：出院患者手术人次数。分母：同期出院总人次数。手术和介入治疗统计按照《手术操作分类代码国家临床版3.0》实施。', '出院患者手术占比', '百分比（%）', NULL, '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（八）出院患者手术占比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
