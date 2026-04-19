-- ===========================================
-- 3.21.8 （八）丙型肝炎病毒（HCV）抗体阳性患者丙型肝炎病毒核酸（HCV-RNA）检测率
-- 数据源：手工填报；分子：首次检出HCV抗体阳性的患者中行HCV-RNA检测的人数，分母：同期在首次检出HCV抗体阳性的患者总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%感染性疾病专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '首次检出HCV抗体阳性的患者中行HCV-RNA检测的人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映HCV抗体阳性患者HCV-RNA检测率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    'HCV-RNA检测包括定性和/或定量检测。', '无', '无', '无', NULL,
    '统计日期', '全院', '首次检出HCV抗体阳性的患者中行HCV-RNA检测的人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '首次检出HCV抗体阳性的患者中行HCV-RNA检测的人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期在首次检出HCV抗体阳性的患者总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映HCV抗体阳性患者HCV-RNA检测率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期在首次检出HCV抗体阳性的患者总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期在首次检出HCV抗体阳性的患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期在首次检出HCV抗体阳性的患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（八）丙型肝炎病毒（HCV）抗体阳性患者丙型肝炎病毒核酸（HCV-RNA）检测率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '首次检出HCV抗体阳性的患者中行HCV-RNA检测的人数占同期在首次检出HCV抗体阳性的患者总人数的比例。', '感染性疾病专业医疗质量控制指标（2023版）。', '反映HCV抗体阳性患者HCV-RNA检测情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：首次检出HCV抗体阳性的患者中行HCV-RNA检测的人数。分母：同期在首次检出HCV抗体阳性的患者总人数。HCV-RNA检测包括定性和/或定量检测。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（八）丙型肝炎病毒（HCV）抗体阳性患者丙型肝炎病毒核酸（HCV-RNA）检测率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
