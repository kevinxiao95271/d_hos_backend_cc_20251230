-- ===========================================
-- 3.17.10 营养门诊投诉发生率
-- 数据源：手工填报；分子：营养门诊诊疗投诉发生人次数，分母：同期营养门诊诊疗总人次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床营养专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '营养门诊诊疗投诉发生人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '临床营养专业医疗质量控制指标（2022版）。', '反映营养门诊投诉发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '营养门诊诊疗过程中投诉发生人次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '营养门诊诊疗投诉发生人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '营养门诊诊疗投诉发生人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期营养门诊诊疗总人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '临床营养专业医疗质量控制指标（2022版）。', '反映营养门诊投诉发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期营养门诊诊疗总人次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期营养门诊诊疗总人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期营养门诊诊疗总人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '营养门诊投诉发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '营养门诊诊疗过程中投诉发生人次数占同期营养门诊诊疗总人次数的比例。', '临床营养专业医疗质量控制指标（2022版）。', '反映营养门诊服务质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：营养门诊诊疗投诉发生人次数。分母：同期营养门诊诊疗总人次数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.17.10"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '营养门诊投诉发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
