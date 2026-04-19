-- ===========================================
-- 3.11.5 （五）护士离职率
-- 数据源：手工填报；分子：护士离职人数，分母：（期初医疗机构执业护士总人数+期末医疗机构执业护士总人数）/2
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%护理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '护士离职人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映护士离职率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内医疗机构中所有在护理岗位工作的执业护士自愿离职的人数总和。', '无', '无', '无', NULL,
    '统计日期', '全院', '护士离职人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '护士离职人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（期初医疗机构执业护士总人数+期末医疗机构执业护士总人数）/2', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '护理专业质量控制指标。', '反映护士离职率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '统计周期内医疗机构执业护士总人数，即统计周期初与统计周期末执业护士人数之和除以2。', '无', '无', '无', NULL,
    '统计日期', '全院', '（期初医疗机构执业护士总人数+期末医疗机构执业护士总人数）/2',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '（期初医疗机构执业护士总人数+期末医疗机构执业护士总人数）/2' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（五）护士离职率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，某医疗机构护士离职人数与执业护士总人数的比例。', '护理专业质量控制指标。', '反映护理队伍稳定性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：护士离职人数。分母：（期初医疗机构执业护士总人数+期末医疗机构执业护士总人数）/2。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.11.5"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（五）护士离职率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
