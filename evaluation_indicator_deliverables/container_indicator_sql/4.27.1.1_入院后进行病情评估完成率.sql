-- 4.27.1.1 入院后进行病情评估完成率（异位妊娠，手术治疗）
-- 说明：分母编码 4.27.1.1.2（同期异位妊娠患者总例数）为 4.27.1 小节统一源分母；
--       4.27.1.2.2、4.27.1.3.2、4.27.2.1.2、4.27.2.2.2 与上述口径一致，注册脚本中采集源于本指标。
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-异位妊娠（手术治疗）质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%异位妊娠%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = '异位妊娠入院后超声β-HCG评估患者数_4.27.1.1';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '入院后进行超声检查、β-HCG的患者数', '无', '反映异位妊娠入院后进行病情评估情况', '第四章-异位妊娠（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：入院后进行超声检查、β-HCG的患者数。分母：同期异位妊娠患者总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '入院后进行超声检查、β-HCG的患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.27.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期异位妊娠总人数_4.27.1.1';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期异位妊娠总人', '无', '反映异位妊娠入院后进行病情评估情况', '第四章-异位妊娠（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：入院后进行超声检查、β-HCG的患者数。分母：同期异位妊娠患者总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期异位妊娠患者总例数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.27.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '入院后进行病情评估完成率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '入院后进行超声检查、β-HCG的患者数占同期异位妊娠患者总例数的比例', '无', '反映异位妊娠入院后进行病情评估情况', '第四章-异位妊娠（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：入院后进行超声检查、β-HCG的患者数。分母：同期异位妊娠患者总例数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.27.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
