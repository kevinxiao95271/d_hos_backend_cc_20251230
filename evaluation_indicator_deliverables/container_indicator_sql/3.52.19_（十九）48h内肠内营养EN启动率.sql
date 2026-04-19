-- ===========================================
-- 0352 专病表指标注册脚本
-- 指标编码：3.52.19（十九）48h内肠内营养（EN）启动率
-- 数据源：重症医学专病表查询（需扩展入住>48h/48h内启动EN值字段）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '重症医学专病表查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%重症医学%2024%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

SET @numerator_kpi_name = '入住ICU超过48h的患者中48h内启动EN的患者人数';
SET @numerator_category_code = '3.52.19.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, '{"p_date_type":"out"}',
    '入住ICU超过48h的患者中48h内启动EN的患者人数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映营养治疗的规范性和对肠内营养启动指征的把握能力',
    '重症医学专病表查询', NULL, 'full', '分子：入住ICU超过48h的患者中48h内启动EN的患者人数。分母：同期入住ICU超过48h的患者总人数。', '无', '无', NULL, '无', '无', '无',
    '出院日期', '出院科室名称', '是否入住ICU超过48h且48h内启动EN', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期入住ICU超过48h的患者总人数';
SET @denominator_category_code = '3.52.19.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, '{"p_date_type":"out"}',
    '同期入住ICU超过48h的患者总人数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映营养治疗的规范性和对肠内营养启动指征的把握能力',
    '重症医学专病表查询', NULL, 'full', '分子：入住ICU超过48h的患者中48h内启动EN的患者人数。分母：同期入住ICU超过48h的患者总人数。', '无', '无', NULL, '无', '无', '无',
    '出院日期', '出院科室名称', '是否同期入住ICU超过48h患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '（十九）48h内肠内营养（EN）启动率';
SET @category_code = '3.52.19';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, '{"p_date_type":"out"}',
    '入住ICU超过48h的患者中48h内启动EN的患者人数占同期入住ICU超过48h的患者总人数的比例', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映营养治疗的规范性和对肠内营养启动指征的把握能力',
    '重症医学专病表查询', NULL, 'full', '患者EN启动前应排除EN禁忌证，参考《中国成人患者肠外肠内营养临床应用指南（2023版）》。', NULL, NULL, '百分比（%）', '无', '无', '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型 FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
