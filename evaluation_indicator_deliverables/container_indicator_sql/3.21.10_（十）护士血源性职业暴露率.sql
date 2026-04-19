-- ===========================================
-- 3.21.10 （十）护士血源性职业暴露率
-- 数据源：手工填报；分子：发生血源性职业暴露护士人数，分母：同期护士总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%感染性疾病专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '发生血源性职业暴露护士人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映护士血源性职业暴露率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '护士血源性职业暴露指护士在职业活动中通过眼、口、鼻及其他黏膜、破损皮肤或非胃肠道接触（针刺、人咬伤、擦伤和割伤等）含血源性病原体的血液或其他潜在传染性物质的状态，主要包含被病原体污染的锐器伤和皮肤、黏膜的直接暴露两类。', '无', '无', '无', NULL,
    '统计日期', '全院', '发生血源性职业暴露护士人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '发生血源性职业暴露护士人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期护士总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映护士血源性职业暴露率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期护士总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期护士总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期护士总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十）护士血源性职业暴露率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '发生血源性职业暴露护士人数占同期护士总数的比例。', '感染性疾病专业医疗质量控制指标（2023版）。', '反映护士血源性职业暴露情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：发生血源性职业暴露护士人数。分母：同期护士总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.10"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十）护士血源性职业暴露率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
