-- 4.2.1.1 心脏功能评估率（入院48小时内超声心动图检查率）（心力衰竭）
-- 说明：分母 4.2.1.1.2（同期心力衰竭患者总数）为本科目最小分母编码；4.2.1.2.2 / 4.2.1.3.2 / 4.2.1.4.2 / 4.2.1.5.2 / 4.2.2.1.2 / 4.2.2.2.2 均源于本编码以保证口径一致
SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-心力衰竭质量控制查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%二、心力衰竭%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

SET @numerator_kpi_name = '入院48小时内超声心动图检查的心力衰竭患者数';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param,
    '入院48小时内进行超声心动图检查的心力衰竭患者人数', '无', '评价心力衰竭患者评估的规范性、及时性',
    '第四章-心力衰竭质量控制查询', NULL, 'full', NULL, NULL, '分子：入院48小时内超声心动图检查的心力衰竭患者人数。分母：同期心力衰竭患者的总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '入院48小时内超声心动图检查数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.2.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期心力衰竭患者总数_4.2.1.1';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param,
    '同期心力衰竭患者总数', '无', '评价心力衰竭患者评估的规范性、及时性',
    '第四章-心力衰竭质量控制查询', NULL, 'full', NULL, NULL, '分子：入院48小时内超声心动图检查的心力衰竭患者人数。分母：同期心力衰竭患者的总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期心力衰竭患者总数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.2.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '心脏功能评估率';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, @data_source_param,
    '入院48小时内超声心动图检查的心力衰竭患者数占同期心力衰竭患者总数的比例', '无', '评价心力衰竭患者评估的规范性、及时性',
    '第四章-心力衰竭质量控制查询', NULL, 'full', NULL, NULL, '分子：入院48小时内超声心动图检查的心力衰竭患者人数。分母：同期心力衰竭患者的总例数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.2.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
