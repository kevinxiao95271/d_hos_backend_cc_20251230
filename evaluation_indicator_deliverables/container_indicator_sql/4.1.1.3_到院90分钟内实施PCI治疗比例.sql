-- ===========================================
-- 第四章单病种质控指标 4.1.1.3（按 CSV 0401-0409.csv 编码）
-- 3.到院90分钟内实施PCI治疗的比例
-- ===========================================

SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '第四章-急性心肌梗死（ST段抬高型，首次住院）质量控制查询' AND INVALID = 0
    LIMIT 1
);

SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE CATEGORY_NAME LIKE '%急性心肌梗死%' AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

SET @numerator_kpi_name = '发病24小时内DTD≤90分钟患者数';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param,
    '发病24小时内急性STEMI患者中，从到院至导丝通过靶血管（DTD）时间≤90分钟的患者数', '无', '评价急性STEMI救治的及时性',
    '第四章-急性心肌梗死（ST段抬高型，首次住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：发病24小时内DTD≤90分钟患者数。分母：同期发病24小时内急性STEMI患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '发病24小时内DTD≤90分钟患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.1.1.3.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期发病24小时内急性STEMI患者总数_4.1.1.3';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param,
    '同期发病24小时内急性STEMI患者总数', '无', '评价急性STEMI救治的及时性',
    '第四章-急性心肌梗死（ST段抬高型，首次住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：发病24小时内DTD≤90分钟患者数。分母：同期发病24小时内急性STEMI患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期发病24小时内急性STEMI患者总数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.1.1.3.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '到院90分钟内实施PCI治疗的比例';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, @data_source_param,
    '发病24小时内DTD≤90分钟患者数占同期发病24小时内急性STEMI患者总数的比例', '无', '评价急性STEMI救治的及时性',
    '第四章-急性心肌梗死（ST段抬高型，首次住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：发病24小时内DTD≤90分钟患者数。分母：同期发病24小时内急性STEMI患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.1.1.3"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
