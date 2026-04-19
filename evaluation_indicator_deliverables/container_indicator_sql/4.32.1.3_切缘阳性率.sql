-- 4.32.1.3 切缘阳性率（胃癌）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-胃癌（手术治疗）质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%胃癌%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = '胃癌手术病理切缘阳性例数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'decrease', 'value', NULL, @ds_id, @param,
    '手术患者病理切缘阳性例数', '无', '评价手术切除质量', '第四章-胃癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：手术患者病理切缘阳性例数。分母：同期胃癌手术病理例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '手术患者病理切缘阳性例数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.32.1.3.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期胃癌手术病理例数_4.32.1.3';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期胃癌手术病理例数', '无', '评价手术切除质量', '第四章-胃癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：手术患者病理切缘阳性例数。分母：同期胃癌手术病理例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期胃癌手术病理例数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.32.1.3.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '切缘阳性率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'decrease', 'ratio', NULL, @ds_id, @param,
    '手术患者病理切缘阳性例数占同期胃癌手术病理例数的比例', '无', '评价手术切除质量', '第四章-胃癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：手术患者病理切缘阳性例数。分母：同期胃癌手术病理例数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.32.1.3"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
