-- ===========================================
-- 3.21.9 （九）HCV-RNA阳性患者抗病毒治疗率
-- 数据源：手工填报；分子：行抗病毒治疗的HCV-RNA阳性患者人数，分母：同期HCV-RNA阳性患者总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%感染性疾病专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '行抗病毒治疗的HCV-RNA阳性患者人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映HCV-RNA阳性患者抗病毒治疗率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '抗病毒治疗包括复方制剂（索磷布韦/维帕他韦、索磷布韦/维帕他韦/伏西瑞韦、来迪派韦/索磷布韦、艾尔巴韦/格拉瑞韦）或联合用药（依米他韦+索磷布韦、达诺瑞韦+拉维达韦、可洛派韦+索磷布韦）等。', '无', '无', '无', NULL,
    '统计日期', '全院', '行抗病毒治疗的HCV-RNA阳性患者人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.9.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '行抗病毒治疗的HCV-RNA阳性患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期HCV-RNA阳性患者总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映HCV-RNA阳性患者抗病毒治疗率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期HCV-RNA阳性患者总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期HCV-RNA阳性患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.9.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期HCV-RNA阳性患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（九）HCV-RNA阳性患者抗病毒治疗率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '行抗病毒治疗的HCV-RNA阳性患者人数占同期HCV-RNA阳性患者总人数的比例。', '感染性疾病专业医疗质量控制指标（2023版）。', '反映HCV-RNA阳性患者抗病毒治疗情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：行抗病毒治疗的HCV-RNA阳性患者人数。分母：同期HCV-RNA阳性患者总人数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.9"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（九）HCV-RNA阳性患者抗病毒治疗率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
