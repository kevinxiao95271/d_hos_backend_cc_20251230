-- ===========================================
-- 3.20.19 （十九）住院患者平均住院费用（单值指标）
-- 数据源：手工填报；单位：元
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '（十九）住院患者平均住院费用', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '指单位时间内，出院患者平均每次住院的医药费用，也称为患者住院次均费用。', '精神专业质量控制指标（2020版）。', '反映住院患者平均住院费用。',
    '手工填报', NULL, 'full', NULL, NULL,
    '出院患者住院费用即住院收入，是指医院开展住院医疗服务活动取得的收入。', '无', '元', '无', NULL,
    '统计日期', '全院', '（十九）住院患者平均住院费用',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.19"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十九）住院患者平均住院费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
