-- ===========================================
-- 3.28.7 正电子发射断层成像/计算机断层成像（PET/CT）报告要素完整率（NM-07）
-- 数据源：手工填报
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%核医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.28.7.1
CALL sp_kpi_item_create(
    'PET/CT 报告要素书写完整的例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映 PET/CT 报告书写的规范性和完整性。',
    '手工填报', NULL, 'full', NULL, NULL,
    'PET/CT 报告要素书写完整是指报告的内容、数据和信息等要素完备，要素具体内容见附表。报告需根据不同药物调整要素种类，如注射正电子药物为 18F-FDG ，要素中需增加血糖浓度内容。', 'PET/CT 报告要素书写完整是指报告的内容、数据和信息等要素完备，要素具体内容见附表。报告需根据不同药物调整要素种类，如注射正电子药物为 18F-FDG ，要素中需增加血糖浓度内容。', '无', '无', NULL,
    '检查日期', '核医学科', 'PET/CT 报告要素书写完整的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.7.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'PET/CT 报告要素书写完整的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.28.7.2
CALL sp_kpi_item_create(
    'PET/CT 报告总 例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映 PET/CT 报告书写的规范性和完整性。',
    '手工填报', NULL, 'full', NULL, NULL,
    'PET/CT 报告要素书写完整是指报告的内容、数据和信息等要素完备，要素具体内容见附表。报告需根据不同药物调整要素种类，如注射正电子药物为 18F-FDG ，要素中需增加血糖浓度内容。', 'PET/CT 报告要素书写完整是指报告的内容、数据和信息等要素完备，要素具体内容见附表。报告需根据不同药物调整要素种类，如注射正电子药物为 18F-FDG ，要素中需增加血糖浓度内容。', '无', '无', NULL,
    '检查日期', '核医学科', 'PET/CT 报告总 例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.7.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'PET/CT 报告总 例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.28.7
CALL sp_kpi_item_create(
    '正电子发射断层成像/计算机断层成像（PET/CT）报告要素完整率（NM-07）', @category_id, NULL, 'integer', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    'PET/CT 报告要素书写完整的例数占同期PET/CT 报告总 例数的比例。', '无', '反映 PET/CT 报告书写的规范性和完整性。',
    '手工填报', NULL, 'full', NULL, NULL,
    'PET/CT 报告要素书写完整是指报告的内容、数据和信息等要素完备，要素具体内容见附表。报告需根据不同药物调整要素种类，如注射正电子药物为 18F-FDG ，要素中需增加血糖浓度内容。', 'PET/CT 报告要素书写完整是指报告的内容、数据和信息等要素完备，要素具体内容见附表。报告需根据不同药物调整要素种类，如注射正电子药物为 18F-FDG ，要素中需增加血糖浓度内容。', '无', '无', NULL,
    '检查日期', '核医学科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.7"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '正电子发射断层成像/计算机断层成像（PET/CT）报告要素完整率（NM-07）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
