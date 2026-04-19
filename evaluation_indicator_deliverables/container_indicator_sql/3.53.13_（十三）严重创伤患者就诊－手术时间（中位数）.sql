-- ===========================================
-- 3.53.13 （十三）严重创伤患者就诊－手术时间（中位数）
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '（十三）严重创伤患者就诊－手术时间（中位数）', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '严重创伤患者就诊－手术时间（中位数）是指严重创伤患者从急诊就诊至开始施行手术时间由长到短排序后取中位数。', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊创伤救治效率。',
    '手工填报', NULL, 'full', NULL, NULL,
    '1.严重创伤患者指ISS≥16、RTS＜11或发生创伤性休克的患者（至少符合其一）。2.创伤性休克指因创伤而引起的休克，包括失血和非失血原因引起的休克。3.手术定义参照《医疗机构手术分级管理办法》，不包括气管插管、中心静脉置管。', '同上。', '分钟', '无', NULL,
    '就诊日期', '急诊科', '（十三）严重创伤患者就诊－手术时间（中位数）',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.13"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十三）严重创伤患者就诊－手术时间（中位数）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
