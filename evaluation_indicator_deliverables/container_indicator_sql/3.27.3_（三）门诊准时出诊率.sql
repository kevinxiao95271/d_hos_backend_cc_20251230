-- ===========================================
-- 3.27.3 （三）门诊准时出诊率
-- 数据源：手工填报；分子：医务人员准时出诊的门诊单元数，分母：同期出诊门诊单元总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%门诊管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '医务人员准时出诊的门诊单元数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '门诊管理医疗质量控制指标（2024版）。', '反映门诊准时出诊率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '出诊单元指医务人员一次出诊时所在的半个工作日。', '无', '无', '无', NULL,
    '统计日期', '全院', '医务人员准时出诊的门诊单元数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医务人员准时出诊的门诊单元数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期出诊门诊单元总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '门诊管理医疗质量控制指标（2024版）。', '反映门诊准时出诊率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期出诊门诊单元总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期出诊门诊单元总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出诊门诊单元总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（三）门诊准时出诊率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '医务人员准时出诊的门诊单元数占同期出诊门诊单元总数的比例。', '门诊管理医疗质量控制指标（2024版）。', '反映门诊准时出诊情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：医务人员准时出诊的门诊单元数。分母：同期出诊门诊单元总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.27.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（三）门诊准时出诊率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
