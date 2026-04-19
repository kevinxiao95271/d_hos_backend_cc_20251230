-- 4.4.1.1 患者血栓和出血风险评估率（房颤）
-- 说明：分母 4.4.1.1.2（同期房颤患者总数）为本科目最小分母编码；4.4.1.2.2 / 4.4.1.3.2 / 4.4.2.1.2 / 4.4.2.2.2 均源于本编码以保证口径一致
SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-房颤质量控制查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%四、房颤%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

SET @numerator_kpi_name = '房颤血栓和出血风险评估患者数';
CALL sp_kpi_item_create(@numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param,
    '进行血栓和出血风险评估的患者数', '无', '评价房颤患者评估的规范性', '第四章-房颤质量控制查询', NULL, 'full', NULL, NULL, '分子：进行血栓和出血风险评估的患者数。分母：同期房颤患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '进行血栓和出血风险评估的患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.4.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期房颤患者总数_4.4.1.1';
CALL sp_kpi_item_create(@denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param,
    '同期房颤患者总数', '无', '评价房颤患者评估的规范性', '第四章-房颤质量控制查询', NULL, 'full', NULL, NULL, '分子：进行血栓和出血风险评估的患者数。分母：同期房颤患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期房颤患者总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.4.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '患者血栓和出血风险评估率';
CALL sp_kpi_item_create(@kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, @data_source_param,
    '进行血栓和出血风险评估的患者数占同期房颤患者总数的比例', '无', '评价房颤患者评估的规范性', '第四章-房颤质量控制查询', NULL, 'full', NULL, NULL, '分子：进行血栓和出血风险评估的患者数。分母：同期房颤患者总数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.4.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
