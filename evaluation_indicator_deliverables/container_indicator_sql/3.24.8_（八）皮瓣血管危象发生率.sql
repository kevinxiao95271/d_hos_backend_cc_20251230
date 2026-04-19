-- ===========================================
-- 3.24.8 （八）皮瓣血管危象发生率
-- 数据源：手工填报；分子：行皮瓣移植术后发生皮瓣血管危象的患者例数，分母：同期行皮瓣移植术的患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%整形美容专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '行皮瓣移植术后发生皮瓣血管危象的患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '整形美容专业医疗质量控制指标（2023版）。', '反映皮瓣血管危象发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '反映皮瓣移植手术质量。皮瓣血管危象指术后出现动脉痉挛、堵塞或静脉堵塞。', '无', '无', '无', NULL,
    '统计日期', '全院', '行皮瓣移植术后发生皮瓣血管危象的患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.24.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '行皮瓣移植术后发生皮瓣血管危象的患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期行皮瓣移植术的患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '整形美容专业医疗质量控制指标（2023版）。', '反映皮瓣血管危象发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期行皮瓣移植术的患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期行皮瓣移植术的患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.24.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期行皮瓣移植术的患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（八）皮瓣血管危象发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '行皮瓣移植术后发生皮瓣血管危象的患者例数占同期行皮瓣移植术的患者总例数的比例。', '整形美容专业医疗质量控制指标（2023版）。', '反映皮瓣移植手术质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：行皮瓣移植术后发生皮瓣血管危象的患者例数。分母：同期行皮瓣移植术的患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.24.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（八）皮瓣血管危象发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
