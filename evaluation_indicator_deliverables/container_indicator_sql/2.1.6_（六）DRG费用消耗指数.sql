-- ===========================================
-- 2.1.6 （六）DRG费用消耗指数
-- 数据源：DRG医疗服务能力指标明细查询；值字段：DRG费用消耗指数，统计方法：avg
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = 'DRG医疗服务能力指标明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

CALL sp_kpi_item_create(
    '（六）DRG费用消耗指数', @category_id, NULL, 'decimal', 4, 'decrease', 'value', @data_source_id, @data_source_param,
    'DRG费用消耗指数是指治疗同类疾病所花费的费用。', '《2.1 医疗服务能力指标.csv》', '反映医疗机构服务效率；小于1表示医疗费用较低，大于1表示较高。',
    'DRG医疗服务能力指标明细查询', NULL, 'full', NULL, '无',
    '医疗机构各DRG组费用与区域各DRG组平均费用比，按病例数加权。', 'DRG费用消耗指数', '无', NULL, '无',
    '出院日期', '出院科室名称', 'DRG费用消耗指数', NULL, NULL, NULL, NULL, 1.0000, 'avg',
    '["出院科室名称"]', '[]', '["住院号","住院次数","出院日期","DRG编码","DRG费用消耗指数"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.6"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '（六）DRG费用消耗指数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
