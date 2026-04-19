-- ===========================================
-- 2.1.7 （七）出院人次数（同期出院口径统一使用MR数据源）
-- 数据源：病案首页明细查询；值字段：出院人次数，统计方法：sum
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '病案首页明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out"}';

CALL sp_kpi_item_create(
    '（七）出院人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '出院患者人次数是指出院人数，即考核年度内所有住院后出院的人数，包括医嘱离院、医嘱转其他医疗机构、非医嘱离院、死亡及其他人数，不含家庭病床撤床人数。', '《2.1 医疗服务能力指标.csv》', '反映医疗机构出院规模；同期出院人数类分母统一使用本数据源口径。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '年度出院患者人次数。', '出院人次数', '人次', NULL, '无',
    '出院日期', '出院科室名称', '出院人次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.7"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '（七）出院人次数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
