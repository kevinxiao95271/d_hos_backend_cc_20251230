-- ===========================================
-- 3.12.6.2 点评出院患者医嘱比例
-- 数据源：手工填报；分子：点评医嘱数，分母：医嘱总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '点评医嘱数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映点评出院患者医嘱比例分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '出院患者住院医嘱点评数按点评的人数（即病历份数）统计，同一患者同一次住院期间多个医嘱的处方点评按1人统计。', '无', '无', '无', NULL,
    '统计日期', '全院', '点评医嘱数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.6.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '点评医嘱数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '医嘱总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映点评出院患者医嘱比例分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期出院人数，不包括出院患者在住院期间未使用药物者。', '无', '无', '无', NULL,
    '统计日期', '全院', '医嘱总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.6.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医嘱总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '点评出院患者医嘱比例', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '分别考核年度点评处方占处方总数的比例和点评出院患者住院医嘱占医嘱总数的比例。', '药事管理专业医疗质量控制指标（2020版）。', '反映出院患者医嘱点评覆盖情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：点评医嘱数。分母：医嘱总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.6.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '点评出院患者医嘱比例' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
