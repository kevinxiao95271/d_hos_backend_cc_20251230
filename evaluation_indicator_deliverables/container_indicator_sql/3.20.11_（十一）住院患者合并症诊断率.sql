-- ===========================================
-- 3.20.11 （十一）住院患者合并症诊断率
-- 数据源：手工填报；分子：诊断合并症的出院患者数，分母：同期出院患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '诊断合并症的出院患者数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者合并症诊断率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '合并症的诊断以患者病案首页中的出院诊断为依据。', '无', '无', '无', NULL,
    '统计日期', '全院', '诊断合并症的出院患者数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.11.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '诊断合并症的出院患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期出院患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者合并症诊断率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期出院患者总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期出院患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.11.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十一）住院患者合并症诊断率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '诊断合并症的出院患者人数占同期出院患者总人数的比例。', '精神专业质量控制指标（2020版）。', '反映住院患者合并症诊断情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：诊断合并症的出院患者数。分母：同期出院患者总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.11"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十一）住院患者合并症诊断率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
