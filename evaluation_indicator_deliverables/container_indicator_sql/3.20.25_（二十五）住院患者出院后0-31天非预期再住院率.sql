-- ===========================================
-- 3.20.25 （二十五）住院患者出院后0-31天非预期再住院率
-- 数据源：手工填报；分子：住院患者出院后0-31天非预期再住院患者人数，分母：同期出院患者总人次（除死亡患者外）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '住院患者出院后0-31天非预期再住院患者人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者出院后0-31天非预期再住院率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '指住院患者出院0-31天非预期再住院的患者人数之和。非预期再住院判定：同一医院同一患者，第一次入院是否31天再入院计划为无或缺失，且主要诊断亚目相同（前四位）。排除肿瘤放疗、化疗等特定诊断。', '无', '无', '无', NULL,
    '统计日期', '全院', '住院患者出院后0-31天非预期再住院患者人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.25.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院患者出院后0-31天非预期再住院患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期出院患者总人次（除死亡患者外）', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者出院后0-31天非预期再住院率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '指同期出院患者总人次（除外死亡患者）。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期出院患者总人次（除死亡患者外）',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.25.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总人次（除死亡患者外）' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二十五）住院患者出院后0-31天非预期再住院率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '住院患者出院后0-31天非预期再住院率是指出院后0-31天非预期再住院患者人次占同期出院患者总人次（除死亡患者外）的比例。', '精神专业质量控制指标（2020版）。', '反映住院患者出院后非预期再住院情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：住院患者出院0-31天非预期再住院患者人数。分母：同期出院患者总人次（除外死亡患者）。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.25"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二十五）住院患者出院后0-31天非预期再住院率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
