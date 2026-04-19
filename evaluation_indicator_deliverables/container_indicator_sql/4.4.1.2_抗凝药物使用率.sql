-- 4.4.1.2 抗凝药物使用率（房颤）
-- 分母 4.4.1.2.2 源于 4.4.1.1.2，须先执行 4.4.1.1_患者血栓和出血风险评估率.sql
SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-房颤质量控制查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%四、房颤%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

SET @numerator_kpi_name = '房颤使用抗凝药物患者数';
CALL sp_kpi_item_create(@numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param,
    '住院期间使用抗凝药物的患者数', '无', '评价房颤治疗的规范性', '第四章-房颤质量控制查询', NULL, 'full', NULL, NULL, '分子：住院期间使用抗凝药物的患者数。分母：同期房颤患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '住院期间使用抗凝药物的患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.4.1.2.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期房颤患者总数_4.4.1.2';
SET @source_kpi_id = (
    SELECT k.ID FROM KPI_ITEM k
    INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.4.1.1.2'
    WHERE k.INVALID = 0 LIMIT 1
);
CALL sp_kpi_item_create(@denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL,
    IF(@source_kpi_id IS NOT NULL, NULL, @data_source_id),
    IF(@source_kpi_id IS NOT NULL, NULL, @data_source_param),
    '同期房颤患者总数', '无', '评价房颤治疗的规范性',
    IF(@source_kpi_id IS NOT NULL, '与指标编码4.4.1.1.2（同期房颤患者总数）同源，采集源于该指标', '第四章-房颤质量控制查询'), NULL, 'full', NULL, NULL,
    '分子：住院期间使用抗凝药物的患者数。分母：同期房颤患者总数（与4.4.1.1.2一致）。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', IF(@source_kpi_id IS NOT NULL, '同期房颤患者总数', '同期房颤患者总数_抗凝'), NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.4.1.2.2"}]'), NULL, NULL, IF(@source_kpi_id IS NOT NULL, 'datasource', NULL), NULL, @source_kpi_id, NULL, 1);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);
UPDATE KPI_ITEM SET SOURCE_KPI_ID = @source_kpi_id WHERE ID = @denominator_kpi_id AND @source_kpi_id IS NOT NULL;

SET @kpi_name = '抗凝药物使用率';
CALL sp_kpi_item_create(@kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, @data_source_param,
    '住院期间使用抗凝药物的患者数占同期房颤患者总数的比例', '无', '评价房颤治疗的规范性', '第四章-房颤质量控制查询', NULL, 'full', NULL, NULL, '分子：住院期间使用抗凝药物的患者数。分母：同期房颤患者总数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.4.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
