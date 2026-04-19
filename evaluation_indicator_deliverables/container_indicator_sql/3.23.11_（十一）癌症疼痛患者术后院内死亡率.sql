-- ===========================================
-- 3.23.11 （十一）癌症疼痛患者术后院内死亡率
-- 数据源：手工填报；分子：行手术治疗的癌症疼痛患者术后住院期间全因死亡人数，分母：同期行手术治疗的癌症疼痛患者总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%疼痛专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '行手术治疗的癌症疼痛患者术后住院期间全因死亡人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映癌症疼痛患者术后院内死亡率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '反映医疗机构手术治疗癌症疼痛的规范性。', '无', '无', '无', NULL,
    '统计日期', '全院', '行手术治疗的癌症疼痛患者术后住院期间全因死亡人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.11.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '行手术治疗的癌症疼痛患者术后住院期间全因死亡人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期行手术治疗的癌症疼痛患者总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映癌症疼痛患者术后院内死亡率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期行手术治疗的癌症疼痛患者总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期行手术治疗的癌症疼痛患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.11.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期行手术治疗的癌症疼痛患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十一）癌症疼痛患者术后院内死亡率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '行手术治疗的癌症疼痛患者术后住院期间全因死亡人数占同期行手术治疗的癌症疼痛患者总人数的比例。', '疼痛专业医疗质量控制指标（2023版）。', '反映医疗机构手术治疗癌症疼痛的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：行手术治疗的癌症疼痛患者术后住院期间全因死亡人数。分母：同期行手术治疗的癌症疼痛患者总人数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.11"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十一）癌症疼痛患者术后院内死亡率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
