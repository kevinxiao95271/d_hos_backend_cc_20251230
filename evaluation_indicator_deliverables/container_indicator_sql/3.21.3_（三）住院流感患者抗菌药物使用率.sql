-- ===========================================
-- 3.21.3 （三）住院流感患者抗菌药物使用率
-- 数据源：手工填报；分子：住院期间使用抗菌药物治疗的流感患者例数，分母：同期住院流感患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%感染性疾病专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '住院期间使用抗菌药物治疗的流感患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映住院流感患者抗菌药物使用率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '反映医疗机构流感住院患者抗菌药物使用及管理情况。', '无', '无', '无', NULL,
    '统计日期', '全院', '住院期间使用抗菌药物治疗的流感患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院期间使用抗菌药物治疗的流感患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院流感患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映住院流感患者抗菌药物使用率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期住院流感患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期住院流感患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院流感患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（三）住院流感患者抗菌药物使用率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '住院流感患者使用抗菌药物治疗例数占同期住院流感患者总例数的比例。', '感染性疾病专业医疗质量控制指标（2023版）。', '反映住院流感患者抗菌药物使用及管理情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：住院期间使用抗菌药物治疗的流感患者例数。分母：同期住院流感患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（三）住院流感患者抗菌药物使用率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
