-- 4.36.1.1 新入血液透析患者血源性传染病标志物检验完成率（终末期肾病血液透析）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-终末期肾病血液透析质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%终末期肾病%' AND CATEGORY_NAME LIKE '%血液透析%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = '新入血透患者血源性传染病标志物检验人数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '新入血液透析患者血源性传染病标志物检验的患者数', '无', '反映感染防控规范性', '第四章-终末期肾病血液透析质量控制查询', NULL, 'full', NULL, NULL, '分子：新入血液透析患者血源性传染病标志物检验的患者数。分母：同期新入血液透析患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '新入血液透析患者血源性传染病标志物检验的患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.36.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期新入血液透析患者总数_4.36.1.1';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期新入血液透析患者总数', '无', '反映感染防控规范性', '第四章-终末期肾病血液透析质量控制查询', NULL, 'full', NULL, NULL, '分子：新入血液透析患者血源性传染病标志物检验的患者数。分母：同期新入血液透析患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期新入血液透析患者总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.36.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '新入血液透析患者血源性传染病标志物检验完成率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '新入血液透析患者血源性传染病标志物检验的患者数占同期新入血液透析患者总数的比例', '无', '反映感染防控规范性', '第四章-终末期肾病血液透析质量控制查询', NULL, 'full', NULL, NULL, '分子：新入血液透析患者血源性传染病标志物检验的患者数。分母：同期新入血液透析患者总数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.36.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
