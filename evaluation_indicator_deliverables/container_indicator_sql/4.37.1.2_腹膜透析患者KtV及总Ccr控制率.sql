-- 4.37.1.2 腹膜透析患者Kt/V及总Ccr控制率
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-终末期肾病腹膜透析质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%终末期肾病%' AND CATEGORY_NAME LIKE '%腹膜透析%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'Kt/V≥1.7且总Ccr≥50的腹透患者数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    'Kt/V≥1.7/周且总Ccr≥50L/1.73㎡/周的腹膜透析患者数', '无', '反映腹膜透析充分性', '第四章-终末期肾病腹膜透析质量控制查询', NULL, 'full', NULL, NULL, '分子：Kt/V≥1.7/周且总Ccr≥50L/1.73㎡/周的腹膜透析患者数。分母：同期腹膜透析患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', 'Kt_V大于等于1_7且总Ccr大于等于50的腹膜透析患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.37.1.2.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期腹膜透析患者总数_4.37.1.2';
-- 分母 4.37.1.2.2 源于 4.37.1.1.2，须先执行 4.37.1.1_腹膜透析患者定时完成检验情况.sql
SET @source_kpi_id = (
    SELECT k.ID FROM KPI_ITEM k
    INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.37.1.1.2'
    WHERE k.INVALID = 0 LIMIT 1
);

CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, IF(@source_kpi_id IS NOT NULL, NULL, @ds_id),
    IF(@source_kpi_id IS NOT NULL, NULL, @param),
    '同期腹膜透析患者总数', '无', '反映腹膜透析充分性', IF(@source_kpi_id IS NOT NULL, '与指标编码4.37.1.1.2（同期腹膜透析患者总数）同源，采集源于该指标', '第四章-终末期肾病腹膜透析质量控制查询'), NULL, 'full', NULL, NULL, '分子：Kt/V≥1.7/周且总Ccr≥50L/1.73㎡/周的腹膜透析患者数。分母：同期腹膜透析患者总数。（与4.37.1.1.2一致）', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', IF(@source_kpi_id IS NOT NULL, '同期腹膜透析患者总数', '同期腹膜透析患者总数_4_37_1_2'), NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.37.1.2.2"}]'), NULL, NULL, IF(@source_kpi_id IS NOT NULL, 'datasource', NULL), NULL, @source_kpi_id, NULL, 1);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

UPDATE KPI_ITEM SET SOURCE_KPI_ID = @source_kpi_id WHERE ID = @den_id AND @source_kpi_id IS NOT NULL;

SET @kpi_name = '腹膜透析患者Kt/V及总Ccr控制率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    'Kt/V≥1.7/周且总Ccr≥50L/1.73㎡/周的腹膜透析患者数占同期腹膜透析患者总数的比例', '无', '反映腹膜透析充分性', '第四章-终末期肾病腹膜透析质量控制查询', NULL, 'full', NULL, NULL, '分子：Kt/V≥1.7/周且总Ccr≥50L/1.73㎡/周的腹膜透析患者数。分母：同期腹膜透析患者总数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.37.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
