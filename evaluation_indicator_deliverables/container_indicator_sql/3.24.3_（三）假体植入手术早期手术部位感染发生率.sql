-- ===========================================
-- 3.24.3 （三）假体植入手术早期手术部位感染发生率
-- 数据源：手工填报；分子：行假体植入手术后30天内发生手术部位感染的患者例数，分母：同期行假体植入手术的患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%整形美容专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '行假体植入手术后30天内发生手术部位感染的患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '整形美容专业医疗质量控制指标（2023版）。', '反映假体植入手术早期手术部位感染发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '患者住院、随访、复诊中发现的手术部位感染均纳入统计。假体植入手术包括：乳腺癌术后扩张器乳房再造术、乳腺癌术后假体乳房再造术、假体隆乳术、假体隆鼻术、假体隆鼻基底术、假体隆颏术、具有金属植入体的骨性轮廓重塑术。', '无', '无', '无', NULL,
    '统计日期', '全院', '行假体植入手术后30天内发生手术部位感染的患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.24.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '行假体植入手术后30天内发生手术部位感染的患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期行假体植入手术的患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '整形美容专业医疗质量控制指标（2023版）。', '反映假体植入手术早期手术部位感染发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期行假体植入手术的患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期行假体植入手术的患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.24.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期行假体植入手术的患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（三）假体植入手术早期手术部位感染发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '行假体植入手术后30天内发生手术部位感染的患者例数占同期行假体植入手术的患者总例数的比例。', '整形美容专业医疗质量控制指标（2023版）。', '反映整形美容假体植入手术质量安全情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：行假体植入手术后30天内发生手术部位感染的患者例数。分母：同期行假体植入手术的患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.24.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（三）假体植入手术早期手术部位感染发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
