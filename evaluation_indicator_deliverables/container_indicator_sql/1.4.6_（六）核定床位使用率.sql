-- ===========================================
-- 1.4.6 核定床位使用率（数据源版）
-- 指标编码：1.4.6.1、1.4.6.2、1.4.6
-- 数据源：实际占用床日数（按日）、同期编制床位总床日数（按日）
-- 说明：分子同1.4.5.1（实际占用床日数按日），分母为核定床位数按日拆分的编制床位总床日数
-- ===========================================

SET @ds_occupied_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '实际占用床日数（按日）' AND INVALID = 0 LIMIT 1);
SET @ds_approved_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '同期编制床位总床日数（按日）' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%运行指标%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 1.4.6.1 实际占用总床日数（数据源：实际占用床日数按日，与1.4.5.1同源）
CALL sp_kpi_item_create(
    '实际占用总床日数', @category_id, NULL, 'integer', 0, 'target', 'value', NULL, @ds_occupied_id, '{}',
    '按每天24点占床、计入不计出规则统计的实际占用总床日数，来自HIS住院记录按日拆分。', NULL, '核定床位使用率分子',
    '实际占用床日数（按日）', NULL, 'full', NULL, NULL,
    '分子：实际占用总床日数。入院当天计1床日，出院当天不计。', NULL, '无', NULL, NULL,
    '日期', '出院科室名称', '实际占用床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["主键ID","住院号","住院次数","日期","出院科室名称"]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@category_id,0), ',"category_code":"1.4.6.1"}]'), NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实际占用总床日数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.4.6.2 同期编制床位总床日数（数据源：同期编制床位总床日数按日，按核定床位数）
CALL sp_kpi_item_create(
    '同期编制床位总床日数', @category_id, NULL, 'integer', 0, 'target', 'value', NULL, @ds_approved_id, '{}',
    '由床位登记表核定床位数按日历日拆分得到的同期编制床位总床日数。', NULL, '核定床位使用率分母',
    '同期编制床位总床日数（按日）', NULL, 'full', NULL, NULL,
    '分母：编制床位总床日数指年内医院各科每日夜晚24时编制床数的总和，不论该床是否被病人占用，都应计算在内。', NULL, '无', NULL, NULL,
    '日期', '科室名称', '编制床位总床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["日期","科室名称"]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@category_id,0), ',"category_code":"1.4.6.2"}]'), NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期编制床位总床日数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.4.6 （六）核定床位使用率（比率，分子=1.4.6.1，分母=1.4.6.2）
CALL sp_kpi_item_create(
    '（六）核定床位使用率', @category_id, NULL, 'percent', 2, 'target', 'ratio', NULL, NULL, '{}',
    '床位使用率反映每天使用床位与实有床位的比率，即实际占用的总床日数与编制床位的总床日数之比。', NULL, '反映编制床位使用效率',
    NULL, NULL, 'full', NULL, NULL,
    '分子：实际占用总床日数；分母：编制床位总床日数（核定床位数按日拆分）。', NULL, '百分比（%）', NULL, NULL,
    '日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@category_id,0), ',"category_code":"1.4.6"}]'), NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 类型
FROM KPI_ITEM
WHERE KPI_NAME IN ('实际占用总床日数','同期编制床位总床日数','（六）核定床位使用率') AND INVALID = 0
ORDER BY CREATE_TIME DESC LIMIT 3;
