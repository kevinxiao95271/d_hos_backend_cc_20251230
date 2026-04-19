-- ===========================================
-- 3.20.16 （十六）门诊人次数（单值指标）
-- 数据源：手工填报；单位：人次
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '（十六）门诊人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '门诊患者人次数是指门诊就诊人数，仅门诊挂号数统计，不包括健康体检者。', '精神专业质量控制指标（2020版）。', '反映精神科门诊服务量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '门诊人次数指门诊就诊人数，仅门诊挂号数统计，不包括健康体检者。', '无', '人次', '无', NULL,
    '统计日期', '全院', '（十六）门诊人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.16"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十六）门诊人次数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
