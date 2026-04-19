-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.5.3
-- 指标名称：术中自体血输注率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '性别重置技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '术中接受400ml及以上自体血（包括自体全血及自体血红细胞）输注例数';
SET @numerator_category_code = '5.1.5.3.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '性别重置技术手术对象术中接受 400ml 及以上自体血（包括自体全血及自体血红细胞）输注例数占同期术中接受 400ml 及以上输血治疗的总例数的比例。', '《性别重置技术临床应用管理规范（2022 版）》《性别重置技术临床应用质量控制指标（2022 版）》。', '自体血的应用可以显著降低异体输血带来的风险，是反映医院医疗质量的重要结构性指标之一。',
    '性别重置技术数据源', NULL, '分子：是指患者在实施性别重置手术过程中，因出血原因在术中接受 400ml 及以上自体血输注的例数。 分母：是指患者实施性别重置手术过程中，因出血原因在术中接受400ml 及以上输血治疗的手术例数。', '百分比（%）', '病历资料。', NULL,
    '出院日期', '出院科室名称', '是否完成术中自体血输注', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.5.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期术中接受400ml及以上输血治疗的总例数';
SET @denominator_category_code = '5.1.5.3.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '性别重置技术手术对象术中接受 400ml 及以上自体血（包括自体全血及自体血红细胞）输注例数占同期术中接受 400ml 及以上输血治疗的总例数的比例。', '《性别重置技术临床应用管理规范（2022 版）》《性别重置技术临床应用质量控制指标（2022 版）》。', '自体血的应用可以显著降低异体输血带来的风险，是反映医院医疗质量的重要结构性指标之一。',
    '性别重置技术数据源', NULL, '分子：是指患者在实施性别重置手术过程中，因出血原因在术中接受 400ml 及以上自体血输注的例数。 分母：是指患者实施性别重置手术过程中，因出血原因在术中接受400ml 及以上输血治疗的手术例数。', '百分比（%）', '病历资料。', NULL,
    '出院日期', '出院科室名称', '是否完成术中自体血输注', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.5.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '术中自体血输注率';
SET @category_code = '5.1.5.3';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '性别重置技术手术对象术中接受 400ml 及以上自体血（包括自体全血及自体血红细胞）输注例数占同期术中接受 400ml 及以上输血治疗的总例数的比例。', '《性别重置技术临床应用管理规范（2022 版）》《性别重置技术临床应用质量控制指标（2022 版）》。', '自体血的应用可以显著降低异体输血带来的风险，是反映医院医疗质量的重要结构性指标之一。',
    '性别重置技术数据源', NULL, '分子：是指患者在实施性别重置手术过程中，因出血原因在术中接受 400ml 及以上自体血输注的例数。 分母：是指患者实施性别重置手术过程中，因出血原因在术中接受400ml 及以上输血治疗的手术例数。', '百分比（%）', '病历资料。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.5.3"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
