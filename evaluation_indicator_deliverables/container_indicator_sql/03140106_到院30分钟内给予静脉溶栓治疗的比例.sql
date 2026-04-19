-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.14.1.6（与CSV文件中的编码完全一致）
-- 指标名称：发病24小时内急性STEMI患者到院30分钟内给予静脉溶栓治疗的比例
-- 创建日期：2026-02-04
-- ===========================================

-- 依赖：请确保数据源"急性ST段抬高型心肌梗死专病表查询"已创建
SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '急性ST段抬高型心肌梗死专病表查询' AND INVALID = 0
    LIMIT 1
);

-- 查询类别ID：根据类别名称"急性ST段抬高型心肌梗死"从数据库查询（使用LIKE模糊匹配）
SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE (CATEGORY_NAME LIKE '%急性ST段抬高型心肌梗死%' OR CATEGORY_NAME LIKE '%STEMI%') AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';

-- 创建分子指标（3.14.1.6.1）
SET @numerator_kpi_name = '发病24小时内急性STEMI患者中DTN时间小于等于30分钟的患者数';
SET @numerator_category_code = '3.14.1.6.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '发病24小时内急性STEMI患者中DTN时间小于等于30分钟的患者数', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价医院对急性STEMI患者救治的及时性',
    '急性ST段抬高型心肌梗死专病表查询', NULL, '分子：发病24小时内急性STEMI患者中DTN时间小于等于30分钟的患者数。分母：同期发病24小时内接受静脉溶栓治疗的急性STEMI患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否DTN时间小于等于30分钟', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间","到达医院接诊时间","静脉溶栓治疗时间DTN"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL
);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建分母指标（3.14.1.6.2）
SET @denominator_kpi_name = '同期发病24小时内接受静脉溶栓治疗的急性STEMI患者总数';
SET @denominator_category_code = '3.14.1.6.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '发病24小时内接受静脉溶栓治疗的急性STEMI患者总数', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价医院对急性STEMI患者救治的及时性',
    '急性ST段抬高型心肌梗死专病表查询', NULL, '分子：发病24小时内急性STEMI患者中DTN时间小于等于30分钟的患者数。分母：同期发病24小时内接受静脉溶栓治疗的急性STEMI患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期发病24小时内接受静脉溶栓治疗', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间","到院时发病小时数"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL
);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建比率指标（3.14.1.6）
SET @kpi_name = '发病24小时内急性STEMI患者到院30分钟内给予静脉溶栓治疗的比例';
SET @category_code = '3.14.1.6';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '发病24小时内急性STEMI患者中，从到院至给予静脉溶栓药物（DTN）时间≤30分钟的患者数，占同期发病24小时内接受静脉溶栓治疗的急性STEMI患者总数的比例', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价医院对急性STEMI患者救治的及时性',
    '急性ST段抬高型心肌梗死专病表查询', NULL, '分子：发病24小时内急性STEMI患者中DTN时间小于等于30分钟的患者数。分母：同期发病24小时内接受静脉溶栓治疗的急性STEMI患者总数。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间","到达医院接诊时间","静脉溶栓治疗时间DTN"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL
);

SELECT
    k.ID AS 指标ID,
    k.KPI_NAME AS 指标名称,
    k.KPI_TYPE AS 指标类型,
    k.NUMERATOR_KPI_ID AS 分子指标ID,
    k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k
WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0
ORDER BY k.CREATE_TIME DESC
LIMIT 1;
