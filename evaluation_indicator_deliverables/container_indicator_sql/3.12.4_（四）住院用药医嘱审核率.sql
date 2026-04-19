-- ===========================================
-- 3.12.4 （四）住院用药医嘱审核率
-- 数据源：手工填报；分子：药品调配前药师审核住院患者用药医嘱条目数，分母：同期住院患者用药医嘱总条目数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '药品调配前药师审核住院患者用药医嘱条目数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映住院用药医嘱审核率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '药品调配前药师审核的住院患者用药医嘱条目数。', '无', '无', '无', NULL,
    '统计日期', '全院', '药品调配前药师审核住院患者用药医嘱条目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '药品调配前药师审核住院患者用药医嘱条目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院患者用药医嘱总条目数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映住院用药医嘱审核率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期住院患者用药医嘱总条目数，均以出院患者用药医嘱条目数计算。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期住院患者用药医嘱总条目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者用药医嘱总条目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）住院用药医嘱审核率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '药品收费前药师审核的处方数占同期处方总数的比例。住院患者用药医嘱条目数均以出院患者用药医嘱条目数计算。', '药事管理专业医疗质量控制指标（2020版）。', '反映住院用药医嘱审核情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：药品调配前药师审核住院患者用药医嘱条目数。分母：同期住院患者用药医嘱总条目数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）住院用药医嘱审核率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
