-- 4.18.1.5 抗菌药物平均使用天数（社区获得性肺炎成人）
-- 分母 4.18.1.5.2 与 4.18.1.1.2 统计口径一致，采集源于该指标（须先执行 4.18.1.1）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-社区获得性肺炎（成人，首次住院）质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%社区获得性肺炎%' AND CATEGORY_NAME LIKE '%成人%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'CAP成人抗菌药物使用天数总和';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'monitor', 'value', NULL, @ds_id, @param,
    '每例患者抗菌药物使用时间（天数）总和', '无', '反映抗菌药物合理使用情况', '第四章-社区获得性肺炎（成人，首次住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：每例患者抗菌药物使用时间（天数）总和。分母：同期社区获得性肺炎出院患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '每例患者抗菌药物使用时间（天数）总和', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.18.1.5.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_category_code = '4.18.1.5.2';
SET @source_kpi_id = (
    SELECT k.ID FROM KPI_ITEM k
    INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.18.1.1.2'
    WHERE k.INVALID = 0 LIMIT 1
);

SET @den_name = '同期CAP成人出院患者总数_4.18.1.5';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'monitor', 'value', NULL, IF(@source_kpi_id IS NOT NULL, NULL, @ds_id), IF(@source_kpi_id IS NOT NULL, NULL, @param),
    '同期社区获得性肺炎出院患者总数', '无', '反映抗菌药物合理使用情况', IF(@source_kpi_id IS NOT NULL, '与指标编码4.18.1.1.2（同期社区获得性肺炎患者总数）同源，采集源于该指标', '第四章-社区获得性肺炎（成人，首次住院）质量控制查询'), NULL, 'full', NULL, NULL, '分子：每例患者抗菌药物使用时间（天数）总和。分母：同期社区获得性肺炎出院患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', IF(@source_kpi_id IS NOT NULL, '同期社区获得性肺炎患者总数', '同期社区获得性肺炎出院患者总数'), NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, IF(@source_kpi_id IS NOT NULL, 'datasource', NULL), NULL, @source_kpi_id, NULL, 1);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);
UPDATE KPI_ITEM SET SOURCE_KPI_ID = @source_kpi_id WHERE ID = @den_id AND @source_kpi_id IS NOT NULL;

SET @kpi_name = '抗菌药物平均使用天数';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, @ds_id, @param,
    '每例患者抗菌药物使用时间（天数）总和除以同期社区获得性肺炎出院患者总数', '无', '反映抗菌药物合理使用情况', '第四章-社区获得性肺炎（成人，首次住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：每例患者抗菌药物使用时间（天数）总和。分母：同期社区获得性肺炎出院患者总数。', '天', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.18.1.5"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
