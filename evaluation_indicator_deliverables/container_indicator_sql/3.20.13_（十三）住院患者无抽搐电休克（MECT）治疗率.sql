-- ===========================================
-- 3.20.13 （十三）住院患者无抽搐电休克（MECT）治疗率
-- 数据源：手工填报；分子：出院患者住院期间接受无抽搐电休克治疗人数，分母：同期出院患者总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '出院患者住院期间接受无抽搐电休克治疗人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者MECT治疗率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '患者单次住院期间接受多次无抽搐电休克治疗，按一次统计。', '无', '无', '无', NULL,
    '统计日期', '全院', '出院患者住院期间接受无抽搐电休克治疗人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.13.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院患者住院期间接受无抽搐电休克治疗人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期出院患者总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '精神专业质量控制指标（2020版）。', '反映住院患者MECT治疗率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期出院患者总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期出院患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.13.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十三）住院患者无抽搐电休克（MECT）治疗率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '出院患者住院期间接受无抽搐电休克治疗人数占同期出院患者总人数的比例。', '精神专业质量控制指标（2020版）。', '反映住院患者MECT治疗情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：出院患者住院期间接受无抽搐电休克治疗人数。分母：同期出院患者总人数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.20.13"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十三）住院患者无抽搐电休克（MECT）治疗率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
