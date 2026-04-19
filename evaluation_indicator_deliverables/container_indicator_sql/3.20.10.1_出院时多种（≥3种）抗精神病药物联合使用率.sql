-- ===========================================
-- 3.20.10.1 1.出院时多种（≥3种）抗精神病药物联合使用率
-- 数据源：手工填报；分子：出院时多种（≥3种）及以上抗精神病药物联合使用患者人数，分母：同期出院患者总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '出院时多种（≥3种）及以上抗精神病药物联合使用患者人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映出院时多种抗精神病药物联合使用率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '出院时多种（≥3种）及以上抗精神病药物联合使用患者人数。分母中出院患者指住院时间超过15天以上的出院患者。', '无', '无', '无', NULL,
    '统计日期', '全院', '出院时多种（≥3种）及以上抗精神病药物联合使用患者人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.10.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院时多种（≥3种）及以上抗精神病药物联合使用患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期出院患者总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映出院时多种抗精神病药物联合使用率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期出院患者总人数（住院时间超过15天以上的出院患者）。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期出院患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.10.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '1.出院时多种（≥3种）抗精神病药物联合使用率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '出院时多种（≥3种）及以上抗精神病药物联合使用患者人数占同期出院患者总人数的比例。', '精神专业质量控制指标（2020版）。', '反映出院时多种抗精神病药物联合使用情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：出院时多种（≥3种）及以上抗精神病药物联合使用患者人数。分母：同期出院患者总人数（住院超过15天）。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.10.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '1.出院时多种（≥3种）抗精神病药物联合使用率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
