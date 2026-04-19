-- ===========================================
-- 3.12.9 （九）用药错误报告率
-- 数据源：手工填报；分子：报告给医疗机构管理部门的用药错误人次数，分母：同期用药患者总人次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '报告给医疗机构管理部门的用药错误人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映用药错误报告率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '报告给医院管理部门的发生用药错误的人次数。用药错误指药品在临床使用及管理全过程中出现的、任何可以防范的用药疏失。', '无', '无', '无', NULL,
    '统计日期', '全院', '报告给医疗机构管理部门的用药错误人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.9.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '报告给医疗机构管理部门的用药错误人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期用药患者总人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映用药错误报告率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '调查时间范围内门诊、急诊和住院患者用药人次数总和。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期用药患者总人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.9.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期用药患者总人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（九）用药错误报告率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '报告给医院管理部门的发生用药错误的人次数占同期用药患者总人次数的比例。', '药事管理专业医疗质量控制指标（2020版）。', '反映用药错误报告与管理情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：报告给医疗机构管理部门的用药错误人次数。分母：同期用药患者总人次数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.9"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（九）用药错误报告率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
