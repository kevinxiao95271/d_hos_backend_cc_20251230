-- ===========================================
-- 3.56.3 （三）新生儿千日医院感染例次发病率
-- 数据源：手工填报；分子：新生儿医院感染新发病例例次数，分母：同期新生儿住院患者累计住院天数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医院感染管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '新生儿医院感染新发病例例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映新生儿千日医院感染例次发病率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '新生儿医院感染新发病例例次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '新生儿医院感染新发病例例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '新生儿医院感染新发病例例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期新生儿住院患者累计住院天数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映新生儿千日医院感染例次发病率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期新生儿住院患者累计住院天数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期新生儿住院患者累计住院天数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期新生儿住院患者累计住院天数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（三）新生儿千日医院感染例次发病率', @category_id, NULL, 'permille', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '每1000个新生儿患者住院日中新发生医院感染的频次。', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映新生儿医院感染发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：新生儿医院感染新发病例例次数。分母：同期新生儿住院患者累计住院天数。', '无', '千分比（‰）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1000.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（三）新生儿千日医院感染例次发病率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
