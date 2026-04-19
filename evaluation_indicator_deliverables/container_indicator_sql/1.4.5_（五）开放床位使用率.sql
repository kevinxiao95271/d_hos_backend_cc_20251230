-- ===========================================
-- 1.4.5 开放床位使用率（数据源版）
-- 指标编码：1.4.5.1、1.4.5.2、1.4.5
-- 数据源：实际占用床日数（按日）、同期实际开放床日数（按日）
-- 说明：若系统中已存在手工填报的 1.4.5.1/1.4.5.2/1.4.5，可先逻辑删除或保留其一；本脚本注册数据源驱动版本
-- ===========================================

SET @ds_occupied_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '实际占用床日数（按日）' AND INVALID = 0 LIMIT 1);
SET @ds_open_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '同期实际开放床日数（按日）' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%运行指标%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 1.4.5.1 实际占用总床日数（数据源：实际占用床日数按日）
CALL sp_kpi_item_create(
    '实际占用总床日数', @category_id, NULL, 'integer', 0, 'target', 'value', NULL, @ds_occupied_id, '{}',
    '按每天24点占床、计入不计出规则统计的实际占用总床日数，来自HIS住院记录按日拆分。', NULL, '反映医院开放床位使用情况',
    '实际占用床日数（按日）', NULL, 'full', NULL, NULL,
    '分子：实际占用总床日数。入院当天计1床日，出院当天不计；当天入院又出院计1床日。', NULL, '无', NULL, NULL,
    '日期', '出院科室名称', '实际占用床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["主键ID","住院号","住院次数","日期","出院科室名称"]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@category_id,0), ',"category_code":"1.4.5.1"}]'), NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实际占用总床日数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.4.5.2 同期实际开放总床日数（数据源：同期实际开放床日数按日）
CALL sp_kpi_item_create(
    '同期实际开放总床日数', @category_id, NULL, 'integer', 0, 'target', 'value', NULL, @ds_open_id, '{}',
    '由医务科床位登记按日历日拆分得到的同期实际开放总床日数。', NULL, '反映医院开放床位资源配置',
    '同期实际开放床日数（按日）', NULL, 'full', NULL, NULL,
    '分母：同期实际开放总床日数，来自床位登记表按日拆分。', NULL, '无', NULL, NULL,
    '日期', '科室名称', '实际开放床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["日期","科室名称"]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@category_id,0), ',"category_code":"1.4.5.2"}]'), NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期实际开放总床日数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.4.5 （五）开放床位使用率（比率，分子=1.4.5.1，分母=1.4.5.2）
CALL sp_kpi_item_create(
    '（五）开放床位使用率', @category_id, NULL, 'percent', 2, 'target', 'ratio', NULL, NULL, '{}',
    '床位使用率反映每天使用床位与实有床位的比率，即实际占用的总床日数与实际开放的总床日数之比。', NULL, '反映医院开放床位使用效率',
    NULL, NULL, 'full', NULL, NULL,
    '分子：实际占用总床日数（HIS按日拆分）；分母：同期实际开放总床日数（床位登记按日拆分）。', NULL, '百分比（%）', NULL, NULL,
    '日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@category_id,0), ',"category_code":"1.4.5"}]'), NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 类型
FROM KPI_ITEM
WHERE KPI_NAME IN ('实际占用总床日数','同期实际开放总床日数','（五）开放床位使用率') AND INVALID = 0
ORDER BY CREATE_TIME DESC LIMIT 3;
