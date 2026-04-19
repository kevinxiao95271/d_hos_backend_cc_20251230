-- 4.29.1.7 病死率（肺癌，手术治疗）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-肺癌（手术治疗）质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%肺癌%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = '肺癌某病种死亡人数_4.29.1.7';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'decrease', 'value', NULL, @ds_id, @param,
    '某病种的死亡人数', '无', '评价医疗质量的重要指标', '第四章-肺癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：某病种的死亡人数。分母：同期某病种出院总人数。此指标数据来自HQMS病案首页，不取自单病种质量监测平台。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '某病种的死亡人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.29.1.7.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期某病种出院总人数_4.29.1.7';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期某病种出院总人数', '无', '评价医疗质量的重要指标', '第四章-肺癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：某病种的死亡人数。分母：同期某病种出院总人数。此指标数据来自HQMS病案首页，不取自单病种质量监测平台。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期某病种出院总人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.29.1.7.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '病死率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'decrease', 'ratio', NULL, @ds_id, @param,
    '某病种死亡人数占同期某病种出院总人数的比例', '无', '评价医疗质量的重要指标', '第四章-肺癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：某病种的死亡人数。分母：同期某病种出院总人数。此指标数据来自HQMS病案首页，不取自单病种质量监测平台。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.29.1.7"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
