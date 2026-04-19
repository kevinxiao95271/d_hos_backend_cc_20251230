-- ===========================================
-- 3.53.16 （十六）体外膜肺氧合辅助心肺复苏（ECPR）实施时间（中位数）
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '（十六）体外膜肺氧合辅助心肺复苏（ECPR）实施时间（中位数）', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    'ECPR实施时间指从启动动静脉置管至体外循环开始运行的时间。将ECPR实施时间由长到短排序后取中位数。', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映ECMO辅助心肺复苏的质量和效率。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '分钟', '无', NULL,
    '就诊日期', '急诊科', '（十六）体外膜肺氧合辅助心肺复苏（ECPR）实施时间（中位数）',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.16"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十六）体外膜肺氧合辅助心肺复苏（ECPR）实施时间（中位数）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
