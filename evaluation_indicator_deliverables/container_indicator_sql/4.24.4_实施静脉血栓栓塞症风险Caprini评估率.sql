-- 4.24.4 实施静脉血栓栓塞症风险（Caprini）评估率（髋关节置换术）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-髋关节置换术质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%髋关节置换术%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = '髋关节置换术实施Caprini评估患者数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '实施静脉血栓栓塞症风险（Caprini）评估的患者数', '无', '反映患者VTE预防情况', '第四章-髋关节置换术质量控制查询', NULL, 'full', NULL, NULL, '分子：实施静脉血栓栓塞症风险（Caprini）评估的患者数。分母：同期手术患者总例数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '实施静脉血栓栓塞症风险Caprini评估的患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.24.4.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期髋关节置换术手术患者总例数_4.24.4';
-- 分母 4.24.4.2 源于 4.24.3.2，须先执行 4.24.3_髋膝关节置换术单侧手术输血量小于400ml的比率.sql
SET @source_kpi_id = (
    SELECT k.ID FROM KPI_ITEM k
    INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.24.3.2'
    WHERE k.INVALID = 0 LIMIT 1
);

CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, IF(@source_kpi_id IS NOT NULL, NULL, @ds_id),
    IF(@source_kpi_id IS NOT NULL, NULL, @param),
    '同期手术患者总例数', '无', '反映患者VTE预防情况', IF(@source_kpi_id IS NOT NULL, '与指标编码4.24.3.2（4.24.3.2）同源，采集源于该指标', '第四章-髋关节置换术质量控制查询'), NULL, 'full', NULL, NULL, '分子：实施静脉血栓栓塞症风险（Caprini）评估的患者数。分母：同期手术患者总例数。（与4.24.3.2一致）', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', IF(@source_kpi_id IS NOT NULL, '4.24.3.2', '同期手术患者总例数'), NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.24.4.2"}]'), NULL, NULL, IF(@source_kpi_id IS NOT NULL, 'datasource', NULL), NULL, @source_kpi_id, NULL, 1);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

UPDATE KPI_ITEM SET SOURCE_KPI_ID = @source_kpi_id WHERE ID = @den_id AND @source_kpi_id IS NOT NULL;

SET @kpi_name = '实施静脉血栓栓塞症风险（Caprini）评估率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '实施静脉血栓栓塞症风险（Caprini）评估的患者数占同期手术患者总例数的比例', '无', '反映患者VTE预防情况', '第四章-髋关节置换术质量控制查询', NULL, 'full', NULL, NULL, '分子：实施静脉血栓栓塞症风险（Caprini）评估的患者数。分母：同期手术患者总例数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.24.4"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
