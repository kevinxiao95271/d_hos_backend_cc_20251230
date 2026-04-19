-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.19.5.1
-- 指标名称：胃癌患者首次治疗前临床TNM分期诊断率
-- 创建日期：2026-03-09
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '胃癌专病表查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%肿瘤%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

SET @numerator_kpi_name = '首次治疗前完成临床TNM分期诊断的胃癌患者数';
SET @numerator_category_code = '3.19.5.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '首次治疗前完成临床TNM分期诊断的胃癌患者数', '《肿瘤专业医疗质量控制指标（2023版）》。', '评价肿瘤专业诊疗规范性。',
    '胃癌专病表查询', NULL, '分子：首次治疗前完成临床TNM分期诊断的胃癌患者数。分母：同期接受首次治疗的胃癌患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否首次治疗前完成临床TNM分期诊断的胃癌', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期接受首次治疗的胃癌患者总数';
SET @denominator_category_code = '3.19.5.1.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期接受首次治疗的胃癌患者总数', '《肿瘤专业医疗质量控制指标（2023版）》。', '评价肿瘤专业诊疗规范性。',
    '胃癌专病表查询', NULL, '分子：首次治疗前完成临床TNM分期诊断的胃癌患者数。分母：同期接受首次治疗的胃癌患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期接受首次治疗的胃癌患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '胃癌患者首次治疗前临床TNM分期诊断率';
SET @category_code = '3.19.5.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '胃癌患者首次治疗前临床TNM分期诊断率的定义和计算方法', '《肿瘤专业医疗质量控制指标（2023版）》。', '评价肿瘤专业诊疗规范性。',
    '胃癌专病表查询', NULL, '分子：首次治疗前完成临床TNM分期诊断的胃癌患者数。分母：同期接受首次治疗的胃癌患者总数。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
