-- 4.5.1.1 术前评估完成率（主动脉瓣置换术）
-- 说明：分母 4.5.1.1.2（同期手术患者的总例数）为本科目最小分母编码；4.5.1.2.2 / 4.5.1.3.2 / 4.5.1.4.2 / 4.5.2.x.2 均源于本编码以保证口径一致
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-主动脉瓣置换术质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%主动脉瓣置换术%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'AVR术前评估完成患者数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '手术前完成病情评估的患者数', '无', '反映术前评估的规范性', '第四章-主动脉瓣置换术质量控制查询', NULL, 'full', NULL, NULL, '分子：手术前完成病情评估的患者数。分母：同期手术患者的总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '手术前完成病情评估的患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.5.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期AVR手术患者总例数_4.5.1.1';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期手术患者的总例数', '无', '反映术前评估的规范性', '第四章-主动脉瓣置换术质量控制查询', NULL, 'full', NULL, NULL, '分子：手术前完成病情评估的患者数。分母：同期手术患者的总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期手术患者的总例数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.5.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '术前评估完成率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '手术前完成病情评估的患者数占同期手术患者总例数的比例', '无', '反映术前评估的规范性', '第四章-主动脉瓣置换术质量控制查询', NULL, 'full', NULL, NULL, '分子：手术前完成病情评估的患者数。分母：同期手术患者的总例数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.5.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
