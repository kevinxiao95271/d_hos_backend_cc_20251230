-- ===========================================
-- 0352 专病表指标注册脚本
-- 指标编码：3.52.5.1 感染性休克患者1小时bundle完成率
-- 数据源：重症医学专病表查询（需扩展 1h bundle 值字段）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '重症医学专病表查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%重症医学%2024%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

SET @numerator_kpi_name = '入ICU诊断为感染性休克并在1h内完成bundle的患者数';
SET @numerator_category_code = '3.52.5.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, '{"p_date_type":"out"}',
    '入ICU诊断为感染性休克并在1h内完成bundle的患者数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映感染性休克的治疗规范性及诊疗能力',
    '重症医学专病表查询', NULL, 'full', '分子：入ICU诊断为感染性休克并在1h内完成bundle的患者数。分母：同一统计周期内入ICU诊断为感染性休克患者总数。', '无', '无', NULL, '无', '无', '无',
    '出院日期', '出院科室名称', '是否入ICU诊断为感染性休克并在1h内完成bundle', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同一统计周期内入ICU诊断为感染性休克患者总数_1h';
SET @denominator_category_code = '3.52.5.1.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, '{"p_date_type":"out"}',
    '同一统计周期内入ICU诊断为感染性休克患者总数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映感染性休克的治疗规范性及诊疗能力',
    '重症医学专病表查询', NULL, 'full', '分子：入ICU诊断为感染性休克并在1h内完成bundle的患者数。分母：同一统计周期内入ICU诊断为感染性休克患者总数。', '无', '无', NULL, '无', '无', '无',
    '出院日期', '出院科室名称', '是否同期入ICU诊断为感染性休克患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '感染性休克患者1小时bundle完成率';
SET @category_code = '3.52.5.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, '{"p_date_type":"out"}',
    '入ICU诊断为感染性休克并完成bundle的患者人数占同期入ICU诊断为感染性休克的患者总人数的比例（1小时）', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映感染性休克的治疗规范性及诊疗能力',
    '重症医学专病表查询', NULL, 'full', '完成bundle指按《拯救脓毒症运动：国际脓毒症与脓毒性休克管理指南（2021版）》在相应时间节点完成对应措施。感染性休克患者不包括ICU期间新发生的病例及儿童。', NULL, NULL, '百分比（%）', '无', '无', '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型 FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
