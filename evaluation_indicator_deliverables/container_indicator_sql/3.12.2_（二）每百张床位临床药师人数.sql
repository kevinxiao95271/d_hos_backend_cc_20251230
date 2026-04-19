-- ===========================================
-- 3.12.2 （二）每百张床位临床药师人数
-- 数据源：手工填报；分子：临床药师人数，分母：同期实际开放床位数（每100张床位）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '临床药师人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映每百张床位临床药师人数分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '临床药师是指经过临床药学专业培训，直接参与临床药物治疗管理的药学专业技术人员。', '无', '无', '无', NULL,
    '统计日期', '全院', '临床药师人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '临床药师人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期实际开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映每百张床位临床药师人数分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '实际开放床位数即实有床位数，指统计周期内固定实有床位（非编制床位）。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期实际开放床位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期实际开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二）每百张床位临床药师人数', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '每100张实际开放床位临床药师人数。', '药事管理专业医疗质量控制指标（2020版）。', '反映临床药师配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：临床药师人数。分母：同期实际开放床位数（指标值=分子/分母×100，即每百张床位人数）。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二）每百张床位临床药师人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
