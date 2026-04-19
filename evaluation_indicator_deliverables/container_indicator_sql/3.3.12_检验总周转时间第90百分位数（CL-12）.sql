-- ===========================================
-- 3.3.12 检验总周转时间第 90 百分位数（CL-12）
-- 数据源：手工填报（单值指标，单位为分钟）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床检验专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '检验总周转时间第 90 百分位数（CL-12）', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '将检验总周转时间由短到长排序后取其第 90 百分位数。', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映标本运送、实验室检测及结果报告的及时性和效率。',
    '手工填报', NULL, 'full', NULL, NULL,
    '检验总周转时间是指实验室的所有标本从标本采集到发送报告的时间（以分钟为单位）。', '无', '分钟', '无', NULL,
    '标本日期', '检验科', '检验总周转时间第90百分位数（分钟）',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.12"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '检验总周转时间第 90 百分位数（CL-12）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
