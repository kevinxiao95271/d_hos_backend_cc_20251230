-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.9.3.15.1（与CSV文件中的编码完全一致）
-- 指标名称：出院时脑梗死患者抗栓/他汀类药物治疗率
-- 创建日期：2026-02-05
-- ===========================================

-- 依赖：请确保数据源"脑梗死专病表查询"已创建
SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '脑梗死专病表查询' AND INVALID = 0
    LIMIT 1
);

-- 查询类别ID：根据类别名称"脑梗死"从数据库查询（使用LIKE模糊匹配）
SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE CATEGORY_NAME LIKE '%脑梗死%' AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';

-- 创建分子指标（3.9.3.15.1.1）
SET @numerator_kpi_name = '出院时给予抗栓药物治疗的脑梗死患者数';
SET @numerator_category_code = '3.9.3.15.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '出院时给予抗栓药物治疗的脑梗死患者数', '《神经系统疾病医疗质量控制指标（2020 年版）》《中国缺血性脑卒中和短暂性脑缺血发作二级预防指南（2014 年版）》。', '反映脑梗死二级预防规范化诊疗情况。',
    '脑梗死专病表查询', NULL, '分子：出院时给予抗栓药物治疗的脑梗死患者数。分母：同期住院脑梗死患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否出院时给予抗栓药物治疗', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建分母指标（3.9.3.15.1.2）
SET @denominator_kpi_name = '同期住院脑梗死患者总数';
SET @denominator_category_code = '3.9.3.15.1.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期住院脑梗死患者总数', '《神经系统疾病医疗质量控制指标（2020 年版）》《中国缺血性脑卒中和短暂性脑缺血发作二级预防指南（2014 年版）》。', '反映脑梗死二级预防规范化诊疗情况。',
    '脑梗死专病表查询', NULL, '分子：出院时给予抗栓药物治疗的脑梗死患者数。分母：同期住院脑梗死患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期住院脑梗死患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建比率指标（3.9.3.15.1）
SET @kpi_name = '出院时脑梗死患者抗栓治疗率';
SET @category_code = '3.9.3.15.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '单位时间内，出院时给予抗栓药物治疗（包括抗血小板药物和抗凝药物治疗）的脑梗死患者数占同期住院脑梗死患者总数的比例。', '《神经系统疾病医疗质量控制指标（2020 年版）》《中国缺血性脑卒中和短暂性脑缺血发作二级预防指南（2014 年版）》。', '反映脑梗死二级预防规范化诊疗情况。',
    '脑梗死专病表查询', NULL, '分子：出院时给予抗栓药物治疗的脑梗死患者数。分母：同期住院脑梗死患者总数。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL);

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
