-- ===========================================
-- 3.12.3.1 1.门诊处方审核率
-- 数据源：手工填报；分子：药品收费前药师审核门诊处方人次数，分母：同期门诊处方总人次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '药品收费前药师审核门诊处方人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映门诊处方审核率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '药品收费前药师审核的处方数，包括纸质处方、电子处方。', '无', '无', '无', NULL,
    '统计日期', '全院', '药品收费前药师审核门诊处方人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.3.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '药品收费前药师审核门诊处方人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期门诊处方总人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映门诊处方审核率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期门诊处方总人次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期门诊处方总人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.3.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期门诊处方总人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '1.门诊处方审核率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '药品收费前药师审核的处方数占同期处方总数的比例。', '药事管理专业医疗质量控制指标（2020版）。', '反映门诊处方审核情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：药品收费前药师审核门诊处方人次数。分母：同期门诊处方总人次数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.3.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '1.门诊处方审核率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
