-- ===========================================
-- 2.2.4 （四）手术患者住院死亡率
-- 数据源：病案首页明细查询（扩展后）
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '病案首页明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%住院质量与安全指标%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.4.1：手术患者住院死亡人数
CALL sp_kpi_item_create(
    '手术患者住院死亡人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '手术患者住院死亡人数。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '住院死亡类指标，反映医院医疗质量。',
    '病案首页明细查询', NULL, 'full', NULL, NULL,
    '分子：手术患者判定为住院期间施行手术（包含各类介入治疗、内窥镜下手术，不包含诊断性操作）。分母：指患者在本次住院期间施行一次或多次手术（包含各类介入治疗、内窥镜下手术，但不包含诊断性操作）的，均按1例统计。', '手术患者住院死亡人数', '无', NULL, NULL,
    '出院日期', '出院科室名称', '手术患者住院死亡人数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间","离院方式"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '手术患者住院死亡人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.4.2：同期住院手术患者手术人数（病例数）
CALL sp_kpi_item_create(
    '同期住院手术患者手术人数（病例数）', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期住院手术患者手术人数（病例数）。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '住院死亡类指标，反映医院医疗质量。',
    '病案首页明细查询', NULL, 'full', NULL, NULL,
    '分子：手术患者住院死亡人数。分母：指患者在本次住院期间施行一次或多次手术（包含各类介入治疗、内窥镜下手术，但不包含ICD-9-CM-3手术编码中注明为诊断性操作）的，均按1例统计。', '同期住院手术患者手术人数（病例数）', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期住院手术患者手术人数（病例数）', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院手术患者手术人数（病例数）' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.4：（四）手术患者住院死亡率
CALL sp_kpi_item_create(
    '（四）手术患者住院死亡率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '手术患者住院死亡率是指手术患者住院死亡人数占同期住院患者手术人数（病例数）的比例。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '住院死亡类指标，反映医院医疗质量。',
    '病案首页明细查询', NULL, 'full', NULL, NULL,
    '分子：手术患者住院死亡人数。分母：指患者在本次住院期间施行一次或多次手术（包含各类介入治疗、内窥镜下手术，但不包含诊断性操作）的，均按1例统计。', '（四）手术患者住院死亡率', '百分比（%）', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间","离院方式"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）手术患者住院死亡率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
