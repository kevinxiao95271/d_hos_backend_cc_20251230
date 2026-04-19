-- ===========================================
-- 1.4.7.1 出院患者平均住院日（数据源版）
-- 指标编码：1.4.7.1.1、1.4.7.1.2、1.4.7.1
-- 数据源：出院患者占用总床日数（分子）、病案首页明细查询（分母）
-- 说明：若已有手工填报的1.4.7.1.x，可保留其一或逻辑删除后执行本脚本
-- ===========================================

SET @ds_bed_days_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '出院患者占用总床日数' AND INVALID = 0 LIMIT 1);
SET @ds_mr_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '病案首页明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%运行指标%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 1.4.7.1.1 出院患者占用总床日数（数据源：出院患者占用总床日数）
CALL sp_kpi_item_create(
    '出院患者占用总床日数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, @ds_bed_days_id, '{}',
    '考核年度所有出院人数的住院床日之和，含正常分娩、未产出院、检查无病出院、未治出院及人工流产或绝育术后正常出院者的住院床日数。', NULL, '出院患者平均住院日分子',
    '出院患者占用总床日数', NULL, 'full', NULL, NULL,
    '分子：出院患者占用总床日数，来自HIS+MR按出院日期筛选、计入不计出按人次汇总。', NULL, '无', NULL, NULL,
    '出院日期', '出院科室名称', '出院患者占用总床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["主键ID","住院号","住院次数","出院日期","出院科室名称"]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@category_id,0), ',"category_code":"1.4.7.1.1"}]'), NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院患者占用总床日数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.4.7.1.2 同期出院患者人数（数据源：病案首页明细查询）
CALL sp_kpi_item_create(
    '同期出院患者人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, @ds_mr_id, '{"p_date_type":"out"}',
    '同期出院人数，考核年度内所有住院后出院的人数，含医嘱离院、转其他机构、非医嘱离院、死亡等。', NULL, '出院患者平均住院日分母',
    '病案首页明细查询', NULL, 'full', NULL, NULL,
    '分母：同期出院患者人数，来自病案首页按出院日期统计。', NULL, '无', NULL, NULL,
    '出院日期', '出院科室名称', '出院人次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期","出院科室名称"]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@category_id,0), ',"category_code":"1.4.7.1.2"}]'), NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.4.7.1 出院患者平均住院日（比率）
CALL sp_kpi_item_create(
    '1.出院患者平均住院日', @category_id, NULL, 'decimal', 2, 'decrease', 'ratio', NULL, NULL, '{}',
    '出院患者平均住院日是指年度医院平均每个出院患者占用的住院床日数。', NULL, '反映医疗资源利用与运行效率',
    NULL, NULL, 'full', NULL, NULL,
    '分子：出院患者占用总床日数；分母：同期出院患者人数。', NULL, '天', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@category_id,0), ',"category_code":"1.4.7.1"}]'), NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 类型
FROM KPI_ITEM
WHERE KPI_NAME IN ('出院患者占用总床日数','同期出院患者人数','1.出院患者平均住院日') AND INVALID = 0
ORDER BY CREATE_TIME DESC LIMIT 3;
