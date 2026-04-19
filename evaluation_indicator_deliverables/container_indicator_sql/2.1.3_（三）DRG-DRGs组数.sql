-- ===========================================
-- 2.1.3 （三）DRG-DRGs组数
-- 数据源：DRG医疗服务能力指标明细查询；值字段：DRG组数，统计方法：distinct_count（按DRG编码）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = 'DRG医疗服务能力指标明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

CALL sp_kpi_item_create(
    '（三）DRG-DRGs组数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    'DRG-DRGs组数是指医疗机构收治病例的DRG组数总和。', '《2.1 医疗服务能力指标.csv》', '反映医疗机构提供医疗服务的范围。',
    'DRG医疗服务能力指标明细查询', NULL, 'full', NULL, '无',
    '医院病例数经过DRG分组器的运算可以分入k个DRG，即是该医院的DRG组数量。', 'DRG-DRGs组数', '组', NULL, '无',
    '出院日期', '出院科室名称', 'DRG编码', NULL, NULL, NULL, NULL, 1.0000, 'distinct_count',
    '["出院科室名称"]', '[]', '["住院号","住院次数","出院日期","DRG编码","DRG名称"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '（三）DRG-DRGs组数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
