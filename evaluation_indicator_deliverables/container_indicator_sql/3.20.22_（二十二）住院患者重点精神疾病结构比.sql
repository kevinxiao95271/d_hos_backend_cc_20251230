-- ===========================================
-- 3.20.22 （二十二）住院患者重点精神疾病结构比
-- 数据源：手工填报；分子：出院主要诊断为重点精神疾病的出院患者人数，分母：同期出院患者总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '出院主要诊断为重点精神疾病的出院患者人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者重点精神疾病结构比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '重点疾病包括：阿尔茨海默病性痴呆、使用酒精引起的精神和行为障碍、精神分裂症、双相情感障碍、抑郁发作与复发性抑郁障碍、惊恐障碍（间歇发作性焦虑）、强迫性障碍、严重应激反应与适应障碍、躯体形式障碍、弥漫性（综合性）发育障碍。', '无', '无', '无', NULL,
    '统计日期', '全院', '出院主要诊断为重点精神疾病的出院患者人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.22.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院主要诊断为重点精神疾病的出院患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期出院患者总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者重点精神疾病结构比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期出院患者总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期出院患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.22.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二十二）住院患者重点精神疾病结构比', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '出院主要诊断为重点精神疾病的出院患者人数占同期出院患者总人数的比例。', '精神专业质量控制指标（2020版）。', '反映住院患者重点精神疾病结构。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：出院主要诊断为重点精神疾病的出院患者人数。分母：同期出院患者总人数。重点疾病包括阿尔茨海默病性痴呆、使用酒精引起的精神和行为障碍、精神分裂症、双相情感障碍、抑郁发作与复发性抑郁障碍、惊恐障碍、强迫性障碍、严重应激反应与适应障碍、躯体形式障碍、弥漫性发育障碍。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.22"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二十二）住院患者重点精神疾病结构比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
