-- ===========================================
-- 3.21.5 （五）感染性腹泻患者病原学诊断阳性率
-- 数据源：手工填报；分子：病原学诊断结果为阳性的感染性腹泻患者例数，分母：同期诊断为感染性腹泻的患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%感染性疾病专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '病原学诊断结果为阳性的感染性腹泻患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映感染性腹泻患者病原学诊断阳性率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '感染性腹泻指各种细菌、病毒、真菌、寄生虫等病原体感染导致的腹泻。病原学诊断包括：血培养、粪便培养、粪便镜检、细菌/病毒/真菌/寄生虫等病原体核酸、抗原、抗体检测。', '无', '无', '无', NULL,
    '统计日期', '全院', '病原学诊断结果为阳性的感染性腹泻患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '病原学诊断结果为阳性的感染性腹泻患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期诊断为感染性腹泻的患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映感染性腹泻患者病原学诊断阳性率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期诊断为感染性腹泻的患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期诊断为感染性腹泻的患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期诊断为感染性腹泻的患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（五）感染性腹泻患者病原学诊断阳性率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '病原学诊断结果为阳性的感染性腹泻患者例数占同期诊断为感染性腹泻的患者总例数的比例。', '感染性疾病专业医疗质量控制指标（2023版）。', '反映感染性腹泻患者病原学诊断情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：病原学诊断结果为阳性的感染性腹泻患者例数。分母：同期诊断为感染性腹泻的患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.5"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（五）感染性腹泻患者病原学诊断阳性率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
