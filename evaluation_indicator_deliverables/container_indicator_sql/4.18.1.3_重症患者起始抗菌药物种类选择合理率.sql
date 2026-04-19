-- 4.18.1.3 重症患者起始抗菌药物种类选择合理率（社区获得性肺炎成人）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-社区获得性肺炎（成人，首次住院）质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%社区获得性肺炎%' AND CATEGORY_NAME LIKE '%成人%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'CAP重症患者起始抗菌药物合理选择数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '合理选择起初始抗菌药物的重症患者数', '无', '反映抗菌药物合理使用情况', '第四章-社区获得性肺炎（成人，首次住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：合理选择起初始抗菌药物的重症患者数。分母：同期重症肺炎患者总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '合理选择起初始抗菌药物的重症患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.18.1.3.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期重症肺炎患者总例数_4.18.1.3';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期重症肺炎患者总例数', '无', '反映抗菌药物合理使用情况', '第四章-社区获得性肺炎（成人，首次住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：合理选择起初始抗菌药物的重症患者数。分母：同期重症肺炎患者总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期重症肺炎患者总例数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.18.1.3.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '重症患者起始抗菌药物种类选择合理率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '合理选择起初始抗菌药物的重症患者数占同期重症肺炎患者总例数的比例', '无', '反映抗菌药物合理使用情况', '第四章-社区获得性肺炎（成人，首次住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：合理选择起初始抗菌药物的重症患者数。分母：同期重症肺炎患者总例数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.18.1.3"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
