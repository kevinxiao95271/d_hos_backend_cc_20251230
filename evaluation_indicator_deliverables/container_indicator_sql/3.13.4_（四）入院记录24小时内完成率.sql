-- ===========================================
-- 3.13.4 （四）入院记录24小时内完成率
-- 数据源：手工填报；分子：入院记录在患者入院24小时内完成的住院患者病历数，分母：同期住院患者病历总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%病案管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '入院记录在患者入院24小时内完成的住院患者病历数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映入院记录24小时内完成率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '入院记录在患者入院24小时内完成的住院患者病历数。', '无', '无', '无', NULL,
    '统计日期', '全院', '入院记录在患者入院24小时内完成的住院患者病历数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '入院记录在患者入院24小时内完成的住院患者病历数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院患者病历总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映入院记录24小时内完成率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期住院患者病历总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期住院患者病历总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者病历总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）入院记录24小时内完成率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，入院记录在患者入院24小时内完成的住院患者病历数占同期住院患者病历总数的比例。', '病案管理质量控制指标（2021版）。', '反映入院记录书写及时性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：入院记录在患者入院24小时内完成的住院患者病历数。分母：同期住院患者病历总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）入院记录24小时内完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
