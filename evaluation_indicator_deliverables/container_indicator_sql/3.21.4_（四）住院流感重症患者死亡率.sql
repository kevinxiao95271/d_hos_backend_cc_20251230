-- ===========================================
-- 3.21.4 （四）住院流感重症患者死亡率
-- 数据源：手工填报；分子：住院流感重症患者死亡数，分母：同期住院流感重症患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%感染性疾病专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '住院流感重症患者死亡数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映住院流感重症患者死亡率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '住院流感重症患者死亡数。', '无', '无', '无', NULL,
    '统计日期', '全院', '住院流感重症患者死亡数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院流感重症患者死亡数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院流感重症患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映住院流感重症患者死亡率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期住院流感重症患者总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期住院流感重症患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院流感重症患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）住院流感重症患者死亡率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '住院流感重症死亡患者数占同期住院流感重症患者总数的比例。', '感染性疾病专业医疗质量控制指标（2023版）。', '反映住院流感重症患者死亡情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：住院流感重症患者死亡数。分母：同期住院流感重症患者总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）住院流感重症患者死亡率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
