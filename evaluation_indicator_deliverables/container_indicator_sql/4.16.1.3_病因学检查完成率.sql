-- 4.16.1.3 病因学检查完成率（惊厥性癫痫持续状态）
-- 分母 4.16.1.3.2 与 4.16.1.1.2 统计口径一致，采集源于该指标（须先执行 4.16.1.1）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-惊厥性癫痫持续状态质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%惊厥性癫痫持续状态%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'CSE病因学检查72h内完成患者数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '入院72小时内完成神经影像学检查和脑脊液相关病因学检查的患者数', '无', '评价惊厥性癫痫持续状态诊疗的规范性', '第四章-惊厥性癫痫持续状态质量控制查询', NULL, 'full', NULL, NULL, '分子：入院72小时内完成神经影像学检查和脑脊液相关病因学检查的患者数。分母：同期住院惊厥性癫痫持续状态患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '入院72小时内完成神经影像学检查和脑脊液相关病因学检查的患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.16.1.3.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_category_code = '4.16.1.3.2';
SET @den_name = '同期CSE住院患者总数_4.16.1.3';
SET @source_kpi_id = (
    SELECT k.ID FROM KPI_ITEM k
    INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.16.1.1.2'
    WHERE k.INVALID = 0 LIMIT 1
);

CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, IF(@source_kpi_id IS NOT NULL, NULL, @ds_id),
    IF(@source_kpi_id IS NOT NULL, NULL, @param),
    '同期住院惊厥性癫痫持续状态患者总数', '无', '评价惊厥性癫痫持续状态诊疗的规范性', IF(@source_kpi_id IS NOT NULL, '与指标编码4.16.1.1.2（同期住院惊厥性癫痫持续状态患者总数）同源，采集源于该指标', '第四章-惊厥性癫痫持续状态质量控制查询'), NULL, 'full', NULL, NULL, '分子：入院72小时内完成神经影像学检查和脑脊液相关病因学检查的患者数。分母：同期住院惊厥性癫痫持续状态患者总数。（与4.16.1.1.2一致）', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', IF(@source_kpi_id IS NOT NULL, '同期住院惊厥性癫痫持续状态患者总数', '同期住院惊厥性癫痫持续状态患者总数'), NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, IF(@source_kpi_id IS NOT NULL, 'datasource', NULL), NULL, @source_kpi_id, NULL, 1);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

UPDATE KPI_ITEM SET SOURCE_KPI_ID = @source_kpi_id WHERE ID = @den_id AND @source_kpi_id IS NOT NULL;

SET @kpi_name = '病因学检查完成率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '入院72小时内完成神经影像学检查和脑脊液相关病因学检查的患者数占同期住院惊厥性癫痫持续状态患者总数的比例', '无', '评价惊厥性癫痫持续状态诊疗的规范性', '第四章-惊厥性癫痫持续状态质量控制查询', NULL, 'full', NULL, NULL, '分子：入院72小时内完成神经影像学检查和脑脊液相关病因学检查的患者数。分母：同期住院惊厥性癫痫持续状态患者总数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.16.1.3"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
