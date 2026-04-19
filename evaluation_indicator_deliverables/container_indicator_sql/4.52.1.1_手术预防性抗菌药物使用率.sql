-- 4.52.1.1 手术预防性抗菌药物使用率（主动脉腔内修复术）
-- 说明：分母编码 4.52.1.1.2（同期主动脉腔内修复手术治疗患者总例数）为 4.52.1 及资源消耗 4.52.2 统一源分母；
--       4.52.1.2.2、4.52.1.3.2、4.52.2.1.2、4.52.2.2.2 等与本章要求一致的指标分母，注册脚本中采集源于本指标。
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-主动脉腔内修复术质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%主动脉腔内修复%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'TEVAR手术预防性应用抗菌药物例数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '手术预防性应用抗菌药物的患者例数', '无', '反映预防用抗菌药物使用', '第四章-主动脉腔内修复术质量控制查询', NULL, 'full', NULL, NULL, '分子：手术预防性应用抗菌药物的患者例数。分母：同期主动脉腔内修复手术治疗患者总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '手术预防性应用抗菌药物的患者例数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.52.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期TEVAR手术患者总例数_4.52.1.1';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期主动脉腔内修复手术治疗患者总例数', '无', '反映预防用抗菌药物使用', '第四章-主动脉腔内修复术质量控制查询', NULL, 'full', NULL, NULL, '分子：手术预防性应用抗菌药物的患者例数。分母：同期主动脉腔内修复手术治疗患者总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期主动脉腔内修复手术治疗患者总例数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.52.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '手术预防性抗菌药物使用率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '手术预防性应用抗菌药物的患者例数占同期主动脉腔内修复手术治疗患者总例数的比例', '无', '反映预防用抗菌药物使用', '第四章-主动脉腔内修复术质量控制查询', NULL, 'full', NULL, NULL, '分子：手术预防性应用抗菌药物的患者例数。分母：同期主动脉腔内修复手术治疗患者总例数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.52.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
