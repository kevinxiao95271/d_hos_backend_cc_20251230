-- 4.37.1.3 腹膜透析退出患者治疗时间（均值型：月总和/退出患者数）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-终末期肾病腹膜透析质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%终末期肾病%' AND CATEGORY_NAME LIKE '%腹膜透析%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = '退出患者腹膜透析月总和';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '退出患者腹膜透析月总和', '无', '反映腹膜透析治疗持续时间', '第四章-终末期肾病腹膜透析质量控制查询', NULL, 'full', NULL, NULL, '分子：退出患者腹膜透析月总和。分母：同期退出腹膜透析患者数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '退出患者腹膜透析月总和', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.37.1.3.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期退出腹膜透析患者数_4.37.1.3';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期退出腹膜透析患者数', '无', '反映腹膜透析治疗持续时间', '第四章-终末期肾病腹膜透析质量控制查询', NULL, 'full', NULL, NULL, '分子：退出患者腹膜透析月总和。分母：同期退出腹膜透析患者数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期退出腹膜透析患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.37.1.3.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '腹膜透析退出患者治疗时间_月';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'decimal', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '退出患者腹膜透析月总和/同期退出腹膜透析患者数（月）', '无', '反映腹膜透析治疗持续时间', '第四章-终末期肾病腹膜透析质量控制查询', NULL, 'full', NULL, NULL, '分子：退出患者腹膜透析月总和。分母：同期退出腹膜透析患者数。', '月', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.37.1.3"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
