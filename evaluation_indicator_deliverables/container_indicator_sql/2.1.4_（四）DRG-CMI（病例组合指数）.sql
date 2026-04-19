-- ===========================================
-- 2.1.4 （四）DRG-CMI（病例组合指数）
-- 数据源：DRG医疗服务能力指标明细查询；值字段：CMI值，统计方法：avg
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = 'DRG医疗服务能力指标明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

CALL sp_kpi_item_create(
    '（四）DRG-CMI（病例组合指数）', @category_id, NULL, 'decimal', 4, 'increase', 'value', @data_source_id, @data_source_param,
    'CMI值（病例组合指数）是指医疗机构收治患者总权重与同期出院患者例数之比。', '《2.1 医疗服务能力指标.csv》', '反映年度医院疾病收治难度。',
    'DRG医疗服务能力指标明细查询', NULL, 'full', NULL, '无',
    '病例组合指数（CMI）= Σ（医疗机构某DRG组权重×该医疗机构该DRG的病例数）/ 该医疗机构全体病例数。', 'DRG-CMI', '无', NULL, '无',
    '出院日期', '出院科室名称', 'CMI值', NULL, NULL, NULL, NULL, 1.0000, 'avg',
    '["出院科室名称"]', '[]', '["住院号","住院次数","出院日期","DRG编码","CMI值"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '（四）DRG-CMI（病例组合指数）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
