-- ===========================================
-- 3.28.3 核医学实验室室间质量评价项目参加率（NM-03）
-- 数据源：手工填报
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%核医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '核医学实验室室间质量评价项目参加率（NM-03）', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '核医学实验室参加国家或省级临床检验中心组织的室间质评的检验项目数占同期核医学实验室已开展且同时国家或省级临床检验中心已组织的室间质评检验项目总数的比例。', '无', '反映核医学实验室检测项目进行外部质量监测的情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '检查日期', '核医学科', '室间质评参加项目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '核医学实验室室间质量评价项目参加率（NM-03）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
