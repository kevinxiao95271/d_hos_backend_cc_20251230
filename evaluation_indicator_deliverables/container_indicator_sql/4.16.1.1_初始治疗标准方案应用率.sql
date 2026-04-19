-- 4.16.1.1 初始治疗标准方案应用率（惊厥性癫痫持续状态）
-- 说明：分母编码 4.16.1.1.2（同期住院惊厥性癫痫持续状态患者总数）为 4.16.1 小节统一源分母；
--       4.16.1.2.2、4.16.1.3.2、4.16.1.4.2、4.16.2.1.2、4.16.2.2.2 与上述口径一致，注册脚本中采集源于本指标。
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-惊厥性癫痫持续状态质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%惊厥性癫痫持续状态%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'CSE标准初始治疗方案应用患者数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '应用标准初始治疗方案治疗的住院惊厥性癫痫持续状态患者数', '无', '反映惊厥性癫痫持续状态诊疗的规范性', '第四章-惊厥性癫痫持续状态质量控制查询', NULL, 'full', NULL, NULL, '分子：应用标准初始治疗方案治疗的住院惊厥性癫痫持续状态患者数。分母：同期住院惊厥性癫痫持续状态患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '应用标准初始治疗方案治疗的住院惊厥性癫痫持续状态患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.16.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期CSE住院患者总数_4.16.1.1';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期住院惊厥性癫痫持续状态患者总数', '无', '反映惊厥性癫痫持续状态诊疗的规范性', '第四章-惊厥性癫痫持续状态质量控制查询', NULL, 'full', NULL, NULL, '分子：应用标准初始治疗方案治疗的住院惊厥性癫痫持续状态患者数。分母：同期住院惊厥性癫痫持续状态患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期住院惊厥性癫痫持续状态患者总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.16.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '初始治疗标准方案应用率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '应用标准初始治疗方案治疗的住院惊厥性癫痫持续状态患者数占同期住院惊厥性癫痫持续状态患者总数的比例', '无', '反映惊厥性癫痫持续状态诊疗的规范性', '第四章-惊厥性癫痫持续状态质量控制查询', NULL, 'full', NULL, NULL, '分子：应用标准初始治疗方案治疗的住院惊厥性癫痫持续状态患者数。分母：同期住院惊厥性癫痫持续状态患者总数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.16.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
