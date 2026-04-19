-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.10.1.8
-- 指标名称：治疗6个月后24小时尿蛋白<1g的患者比例
-- 创建日期：2026-02-05
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = 'IgA肾病专病表查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%肾病%' OR CATEGORY_NAME LIKE '%IgA肾病%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

SET @numerator_kpi_name = '治疗6个月后，24小时尿蛋白＜1g的IgA肾病患者数';
SET @numerator_category_code = '3.10.1.8.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '治疗6个月后，24小时尿蛋白＜1g的IgA肾病患者数', '《肾病专业医疗质量控制指标（2021年版）》。', '评价IgA肾病患者治疗效果',
    'IgA肾病专病表查询', NULL, '分子：治疗6个月后，24小时尿蛋白＜1g的IgA肾病患者数。分母：同期随访的IgA肾病患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否24小时尿蛋白小于1g', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期随访的IgA肾病患者总数';
SET @denominator_category_code = '3.10.1.8.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期随访的IgA肾病患者总数', '《肾病专业医疗质量控制指标（2021年版）》。', '评价IgA肾病患者治疗效果',
    'IgA肾病专病表查询', NULL, '分子：治疗6个月后，24小时尿蛋白＜1g的IgA肾病患者数。分母：同期随访的IgA肾病患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期随访的IgA肾病患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '治疗6个月后24小时尿蛋白<1g的患者比例';
SET @category_code = '3.10.1.8';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    'IgA肾病随访患者中治疗6个月后24小时尿蛋白<1g的患者比例', '《肾病专业医疗质量控制指标（2021年版）》。', '评价IgA肾病患者治疗效果',
    'IgA肾病专病表查询', NULL, '分子：治疗6个月后，24小时尿蛋白＜1g的IgA肾病患者数。分母：同期随访的IgA肾病患者总数。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
