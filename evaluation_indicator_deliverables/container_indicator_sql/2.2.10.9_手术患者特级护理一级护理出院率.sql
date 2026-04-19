-- ===========================================
-- 2.2.10.9 手术患者特级护理/一级护理出院率（分子+分母+比率）
-- 数据源：核心制度手术与护理明细查询
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '核心制度手术与护理明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

-- 分子 2.2.10.9.1
CALL sp_kpi_item_create(
    '手术患者出院时为特级护理一级护理级别的患者数量', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '手术患者出院时为特级护理/一级护理级别的患者数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映对住院患者进行分级护理动态调整的情况。',
    '核心制度手术与护理明细查询', NULL, 'full', NULL, '无',
    '分子：手术患者出院时为特级护理/一级护理级别的患者数量。分母：同期手术患者总数量。', '手术患者出院时为特级护理一级护理级别的患者数量', '无', NULL, '无',
    '出院日期', '出院科室名称', '手术患者特级一级护理出院人数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[{"field":"同期手术患者总数量","operator":"=","value":1}]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.9.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '手术患者出院时为特级护理一级护理级别的患者数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.10.9.2
CALL sp_kpi_item_create(
    '同期手术患者总数量', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '同期手术患者总数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    '核心制度手术与护理明细查询', NULL, 'full', NULL, '无',
    '分母：同期手术患者总数量。', '同期手术患者总数量', '无', NULL, '无',
    '出院日期', '出院科室名称', '同期手术患者总数量', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.9.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期手术患者总数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.10.9
CALL sp_kpi_item_create(
    '手术患者特级护理/一级护理出院率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '手术患者出院时为特级护理/一级护理级别的患者数量占同期手术患者总数量的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映对住院患者进行分级护理动态调整的情况。',
    '核心制度手术与护理明细查询', NULL, 'full', NULL, '无',
    '分子：手术患者出院时为特级护理/一级护理级别的患者数量。分母：同期手术患者总数量。', '手术患者特级护理/一级护理出院率', '百分比（%）', NULL, '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.9"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型
FROM KPI_ITEM WHERE KPI_NAME = '手术患者特级护理/一级护理出院率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
