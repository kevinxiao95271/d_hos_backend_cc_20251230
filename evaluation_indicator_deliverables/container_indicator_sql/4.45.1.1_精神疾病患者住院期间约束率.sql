-- 4.45.1.1 精神疾病患者住院期间约束率（住院精神疾病）
-- 说明：分母编码 4.45.1.1.2（同期出院患者总人数）为 4.45.1 小节统一源分母；
--       4.45.1.2.2、4.45.1.3.2、4.45.1.4.2 等与本章要求一致的指标分母，注册脚本中采集源于本指标。
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-住院精神疾病质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%住院精神疾病%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = '住院期间使用约束人数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'decrease', 'value', NULL, @ds_id, @param,
    '精神疾病患者住院期间使用约束的人数', '无', '反映约束使用情况', '第四章-住院精神疾病质量控制查询', NULL, 'full', NULL, NULL, '分子：精神疾病患者住院期间使用约束的人数。分母：同期出院患者总人数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '精神疾病患者住院期间使用约束的人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.45.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期出院患者总人数_4.45.1.1';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期出院患者总人数', '无', '反映约束使用情况', '第四章-住院精神疾病质量控制查询', NULL, 'full', NULL, NULL, '分子：精神疾病患者住院期间使用约束的人数。分母：同期出院患者总人数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期出院患者总人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.45.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '精神疾病患者住院期间约束率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'decrease', 'ratio', NULL, @ds_id, @param,
    '精神疾病患者住院期间使用约束的人数占同期出院患者总人数的比例', '无', '反映约束使用情况', '第四章-住院精神疾病质量控制查询', NULL, 'full', NULL, NULL, '分子：精神疾病患者住院期间使用约束的人数。分母：同期出院患者总人数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.45.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
