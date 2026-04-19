-- ===========================================
-- 3.12.11.3 3.住院患者特殊使用级抗菌药物使用量占比
-- 数据源：手工填报；分子：住院患者特殊使用级抗菌药物使用量（累计DDD数），分母：同期住院患者抗菌药物使用量（累计DDD数）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '住院患者特殊使用级抗菌药物使用量（累计DDD数）', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映特殊使用级抗菌药物使用量占比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '住院患者特殊使用级抗菌药物使用量（累计DDD数）。按2015版《抗菌药物临床应用指导原则》特殊使用级管理。', '无', '无', '无', NULL,
    '统计日期', '全院', '住院患者特殊使用级抗菌药物使用量（累计DDD数）',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.11.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院患者特殊使用级抗菌药物使用量（累计DDD数）' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院患者抗菌药物使用量（累计DDD数）', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映特殊使用级抗菌药物使用量占比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期住院患者抗菌药物使用量（累计DDD数）。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期住院患者抗菌药物使用量（累计DDD数）',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.11.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者抗菌药物使用量（累计DDD数）' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '3.住院患者特殊使用级抗菌药物使用量占比', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '住院患者特殊使用级抗菌药物使用量占同期住院患者抗菌药物使用量的比例。', '药事管理专业医疗质量控制指标（2020版）。', '反映特殊使用级抗菌药物使用占比。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：住院患者特殊使用级抗菌药物使用量（累计DDD数）。分母：同期住院患者抗菌药物使用量（累计DDD数）。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.11.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '3.住院患者特殊使用级抗菌药物使用量占比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
