-- ===========================================
-- 2.1.11 （十一）日间手术占择期手术比例（分子 2.1.11.1 + 分母 2.1.11.2 + 比率 2.1.11）
-- 数据源：病案首页明细查询
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '病案首页明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

-- 分子 2.1.11.1：出院患者日间手术台次数
CALL sp_kpi_item_create(
    '出院患者日间手术台次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '日间手术患者人数，在日间手术室或住院部手术室内、麻醉状态下完成的择期日间手术人数。', '《2.1 医疗服务能力指标.csv》', '反映日间手术开展。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分子：日间手术台次数。分母：同期出院患者择期手术台次数。', '出院患者日间手术台次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '日间手术台次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[{"field":"日间手术台次数","operator":">","value":0}]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.11.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院患者日间手术台次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.1.11.2：同期出院患者择期手术台次数
CALL sp_kpi_item_create(
    '同期出院患者择期手术台次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '同期出院患者择期手术人数，同一次住院多次手术按1人统计，含择期手术和介入治疗。', '《2.1 医疗服务能力指标.csv》', '反映择期手术总量。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分母：同期出院患者择期手术台次数。', '同期出院患者择期手术台次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '择期手术台次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[{"field":"择期手术台次数","operator":">","value":0}]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.11.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者择期手术台次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.1.11：（十一）日间手术占择期手术比例
CALL sp_kpi_item_create(
    '（十一）日间手术占择期手术比例', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '日间手术占择期手术比例是指出院患者日间手术台次数占同期出院患者择期手术台次数的比例。', '《2.1 医疗服务能力指标.csv》', '反映日间手术开展与床位周转效率。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分子：日间手术台次数。分母：同期出院患者择期手术台次数。手术名称和编码参阅《手术操作分类代码国家临床版3.0（2022汇总版）》。', '日间手术占择期手术比例', '百分比（%）', NULL, '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.11"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十一）日间手术占择期手术比例' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
