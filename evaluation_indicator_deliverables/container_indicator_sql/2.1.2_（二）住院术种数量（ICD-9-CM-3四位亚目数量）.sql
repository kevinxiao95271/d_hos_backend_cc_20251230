-- ===========================================
-- 2.1.2 （二）住院术种数量（ICD-9-CM-3四位亚目数量）
-- 数据源：医疗服务能力病案明细查询；值字段：主要手术ICD9四位亚目，统计方法：distinct_count
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '医疗服务能力病案明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

CALL sp_kpi_item_create(
    '（二）住院术种数量（ICD-9-CM-3四位亚目数量）', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '医院住院术种数量（ICD-9-CM-3四位亚目数量）。', '《2.1 医疗服务能力指标.csv》', '主要反映医疗机构手术服务范围。',
    '医疗服务能力病案明细查询', NULL, 'full', NULL, '无',
    '根据ICD-9-CM-3四位亚目，从病案首页中统计主要手术种类。', '住院术种数量（ICD-9-CM-3四位亚目）', '个', NULL, '无',
    '出院日期', '出院科室名称', '主要手术ICD9四位亚目', NULL, NULL, NULL, NULL, 1.0000, 'distinct_count',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '（二）住院术种数量（ICD-9-CM-3四位亚目数量）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
