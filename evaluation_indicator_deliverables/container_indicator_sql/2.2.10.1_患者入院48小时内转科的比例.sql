-- ===========================================
-- 2.2.10.1 患者入院48小时内转科的比例（分子+分母+比率）
-- 数据源：核心制度住院与转科明细查询
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '核心制度住院与转科明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

-- 分子 2.2.10.1.1
CALL sp_kpi_item_create(
    '入院48小时内转科患者人次数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '入院48小时内转科患者人次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映首诊医师和首诊科室对患者病情评估的充分性。',
    '核心制度住院与转科明细查询', NULL, 'full', NULL, '无',
    '本指标不包括患者转入/转出 ICU 的情况。', '入院48小时内转科患者人次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '入院48小时内转科人次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[{"field":"同期入院患者人次数","operator":"=","value":1}]', '["住院号","病案号","患者姓名","入院日期","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '入院48小时内转科患者人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.10.1.2
CALL sp_kpi_item_create(
    '同期入院患者总人次数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '同期入院患者总人次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    '核心制度住院与转科明细查询', NULL, 'full', NULL, '无',
    '本指标不包括患者转入/转出 ICU 的情况。', '同期入院患者总人次数', '无', NULL, '无',
    '出院日期', '出院科室名称', '同期入院患者人次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","入院日期","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期入院患者总人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.10.1
CALL sp_kpi_item_create(
    '患者入院48小时内转科的比例', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, @data_source_param,
    '入院48小时内转科患者人次数占同期入院患者总人次数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映首诊医师和首诊科室对患者病情评估的充分性。',
    '核心制度住院与转科明细查询', NULL, 'full', NULL, '无',
    '本指标不包括患者转入/转出 ICU 的情况。', '患者入院48小时内转科的比例', '百分比（%）', NULL, '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","入院日期","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型
FROM KPI_ITEM WHERE KPI_NAME = '患者入院48小时内转科的比例' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
