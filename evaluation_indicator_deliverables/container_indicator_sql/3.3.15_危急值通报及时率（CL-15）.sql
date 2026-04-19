-- ===========================================
-- 3.3.15 危急值通报及时率（CL-15）
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床检验专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.3.15.1
CALL sp_kpi_item_create(
    '通报时间符合规定的危急值数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映危急值通报的及时性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '危急值通报时间是指从出现危急值到临床科室获取危急值的时间。', '无', '无', '无', NULL,
    '标本日期', '检验科', '通报时间符合规定的危急值数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.15.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '通报时间符合规定的危急值数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.3.15.2
CALL sp_kpi_item_create(
    '需要通报的危急值总数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映危急值通报的及时性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '危急值通报时间是指从出现危急值到临床科室获取危急值的时间。', '无', '无', '无', NULL,
    '标本日期', '检验科', '需要通报的危急值总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.15.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '需要通报的危急值总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.3.15
CALL sp_kpi_item_create(
    '危急值通报及时率（CL-15）', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '通报时间符合规定的危急值数占同期需要通报的危急值总数的比例。', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映危急值通报的及时性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '危急值通报时间是指从出现危急值到临床科室获取危急值的时间。', '无', '无', '无', NULL,
    '标本日期', '检验科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.15"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '危急值通报及时率（CL-15）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
