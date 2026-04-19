-- ===========================================
-- 3.11.10.1 1.导尿管相关尿路感染（CAUTI）发生率
-- 数据源：手工填报；单位：千分比（‰）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%护理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '留置导尿管患者中尿路感染例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映CAUTI发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内住院患者留置导尿管期间或拔除导尿管48h内发生的泌尿系统感染例次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '留置导尿管患者中尿路感染例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.10.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '留置导尿管患者中尿路感染例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期患者导尿管留置总日数', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映CAUTI发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内住院患者留置导尿管的日数总和。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期患者导尿管留置总日数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.10.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期患者导尿管留置总日数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '1.导尿管相关尿路感染（CAUTI）发生率', @category_id, NULL, 'permille', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，留置导尿管患者中尿路感染例次数与患者导尿管留置总日数的千分比。', '护理专业质量控制指标。', '反映导尿管相关尿路感染发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：留置导尿管患者中尿路感染例次数。分母：同期患者导尿管留置总日数。', '无', '千分比（‰）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.10.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '1.导尿管相关尿路感染（CAUTI）发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
