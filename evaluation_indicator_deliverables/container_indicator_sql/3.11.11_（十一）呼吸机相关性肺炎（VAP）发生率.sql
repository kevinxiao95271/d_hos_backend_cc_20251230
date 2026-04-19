-- ===========================================
-- 3.11.11 （十一）呼吸机相关性肺炎（VAP）发生率
-- 数据源：手工填报；单位：千分比（‰）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%护理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '呼吸机相关性肺炎例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映VAP发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内住院患者建立人工气道接受机械通气48h后发生肺炎的例次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '呼吸机相关性肺炎例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.11.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '呼吸机相关性肺炎例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院患者有创机械通气总日数', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映VAP发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内所监测住院患者经人工气道（包括气管插管和气管切开）接呼吸机辅助通气的日数总和。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期住院患者有创机械通气总日数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.11.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者有创机械通气总日数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十一）呼吸机相关性肺炎（VAP）发生率', @category_id, NULL, 'permille', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，呼吸机相关性肺炎例次数与住院患者有创机械通气总日数的千分比。', '护理专业质量控制指标。', '反映呼吸机相关性肺炎发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：呼吸机相关性肺炎例次数。分母：同期住院患者有创机械通气总日数。', '无', '千分比（‰）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.11"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十一）呼吸机相关性肺炎（VAP）发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
