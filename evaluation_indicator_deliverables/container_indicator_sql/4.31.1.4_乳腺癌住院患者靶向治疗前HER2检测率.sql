-- 4.31.1.4 乳腺癌住院患者靶向治疗前HER2检测率（乳腺癌）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-乳腺癌（手术治疗）质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%乳腺癌%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = '乳腺癌靶向治疗前HER2检测例数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '乳腺癌住院患者靶向治疗前完成HER2检测的病例数', '无', '反映乳腺癌靶向治疗的规范性', '第四章-乳腺癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：乳腺癌住院患者进行靶向治疗前完成HER2检测的病例数。分母：同期开展靶向治疗患者人次。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '乳腺癌住院患者靶向治前HER2检测例数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.31.1.4.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期乳腺癌靶向治疗患者人次_4.31.1.4';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期开展靶向治疗患者人次', '无', '反映乳腺癌靶向治疗的规范性', '第四章-乳腺癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：乳腺癌住院患者进行靶向治疗前完成HER2检测的病例数。分母：同期开展靶向治疗患者人次。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期开展靶向治疗患者人次', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.31.1.4.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '乳腺癌住院患者靶向治疗前HER2检测率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '乳腺癌住院患者靶向治疗前完成HER2检测的病例数占同期开展靶向治疗患者人次的比例', '无', '反映乳腺癌靶向治疗的规范性', '第四章-乳腺癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：乳腺癌住院患者进行靶向治疗前完成HER2检测的病例数。分母：同期开展靶向治疗患者人次。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.31.1.4"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
