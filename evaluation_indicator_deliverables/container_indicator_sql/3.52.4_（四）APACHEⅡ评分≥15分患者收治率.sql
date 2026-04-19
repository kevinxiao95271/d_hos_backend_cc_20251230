-- ===========================================
-- 0352 专病表指标注册脚本
-- 指标编码：3.52.4（四）APACHEⅡ评分≥15分患者收治率（入ICU24小时内）
-- 数据源：重症医学专病表查询
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '重症医学专病表查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%重症医学%2024%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

SET @numerator_kpi_name = '入ICU24小时内，APACHEⅡ评分≥15分的患者数';
SET @numerator_category_code = '3.52.4.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, '{"p_date_type":"out"}',
    '入ICU24小时内，APACHEⅡ评分≥15分患者数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映ICU收治患者的病情危重程度',
    '重症医学专病表查询', NULL, 'full', '分子：入ICU24小时内，APACHEⅡ评分≥15分的患者数。分母：同一统计周期内ICU收治患者总数。', '无', '无', NULL, '无', '无', '无',
    '出院日期', '出院科室名称', '是否入ICU24小时内APACHEII评分大于等于15分', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间","入院时间","APACHEII评分"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同一统计周期内ICU收治患者总数';
SET @denominator_category_code = '3.52.4.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, '{"p_date_type":"out"}',
    '同一统计周期内ICU收治患者总数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映ICU收治患者的病情危重程度',
    '重症医学专病表查询', NULL, 'full', '分子：入ICU24小时内，APACHEⅡ评分≥15分的患者数。分母：同一统计周期内ICU收治患者总数。', '无', '无', NULL, '无', '无', '无',
    '出院日期', '出院科室名称', '是否同期ICU收治患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '（四）急性生理与慢性健康评分（APACHEⅡ评分）≥15分患者收治率（入ICU24小时内）';
SET @category_code = '3.52.4';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, '{"p_date_type":"out"}',
    '入ICU后首次APACHEⅡ评分≥15分患者人数占同期ICU收治患者总数的比例', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映ICU收治患者的病情危重程度',
    '重症医学专病表查询', NULL, 'full', '分子：入ICU24小时内，APACHEⅡ评分≥15分的患者数。分母：同一统计周期内ICU收治患者总数。', NULL, NULL, '百分比（%）', '无', '无', '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间","入院时间","APACHEII评分"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型 FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
