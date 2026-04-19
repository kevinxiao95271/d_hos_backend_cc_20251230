-- 4.51.1.4 新生儿母乳喂养率（HBV感染分娩母婴阻断）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-HBV感染分娩母婴阻断质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%HBV%' AND CATEGORY_NAME LIKE '%母婴%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'HBV母亲分娩新生儿母乳喂养人数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    'HBV感染母亲分娩的新生儿母乳喂养人数', '无', '反映母乳喂养指导', '第四章-HBV感染分娩母婴阻断质量控制查询', NULL, 'full', NULL, NULL, '分子：HBV感染母亲分娩的新生儿母乳喂养人数。分母：同期HBV感染孕产妇总人数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', 'HBV感染母亲分娩的新生儿母乳喂养人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.51.1.4.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期HBV母亲分娩新生儿总数_4.51.1.4';
-- 分母 4.51.1.4.2 源于 4.51.1.1.2，须先执行 4.51.1.1_HBV感染分娩母婴传播风险评估率.sql
SET @source_kpi_id = (
    SELECT k.ID FROM KPI_ITEM k
    INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.51.1.1.2'
    WHERE k.INVALID = 0 LIMIT 1
);

CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, IF(@source_kpi_id IS NOT NULL, NULL, @ds_id),
    IF(@source_kpi_id IS NOT NULL, NULL, @param),
    '同期HBV感染孕产妇总人数', '无', '反映母乳喂养指导', IF(@source_kpi_id IS NOT NULL, '与指标编码4.51.1.1.2（同期HBV感染孕产妇总人数）同源，采集源于该指标', '第四章-HBV感染分娩母婴阻断质量控制查询'), NULL, 'full', NULL, NULL, '分子：HBV感染母亲分娩的新生儿母乳喂养人数。分母：同期HBV感染孕产妇总人数。（与4.51.1.1.2一致）', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', IF(@source_kpi_id IS NOT NULL, '同期HBV感染孕产妇总人数', '同期HBV感染母亲分娩的新生儿总数'), NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.51.1.4.2"}]'), NULL, NULL, IF(@source_kpi_id IS NOT NULL, 'datasource', NULL), NULL, @source_kpi_id, NULL, 1);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

UPDATE KPI_ITEM SET SOURCE_KPI_ID = @source_kpi_id WHERE ID = @den_id AND @source_kpi_id IS NOT NULL;

SET @kpi_name = '新生儿母乳喂养率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    'HBV感染母亲分娩的新生儿母乳喂养人数占同期HBV感染母亲分娩新生儿总数的比例', '无', '反映母乳喂养指导', '第四章-HBV感染分娩母婴阻断质量控制查询', NULL, 'full', NULL, NULL, '分子：HBV感染母亲分娩的新生儿母乳喂养人数。分母：同期HBV感染母亲分娩的新生儿总数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.51.1.4"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
