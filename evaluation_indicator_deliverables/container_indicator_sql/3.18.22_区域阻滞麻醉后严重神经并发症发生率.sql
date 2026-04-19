-- ===========================================
-- 3.18.22 区域阻滞麻醉后严重神经并发症发生率
-- 数据源：手工填报；分子：单位时间内区域阻滞麻醉后严重神经并发症发生例数，分母：同期区域阻滞麻醉总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%麻醉专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '单位时间内区域阻滞麻醉后严重神经并发症发生例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映区域阻滞麻醉后严重神经并发症发生率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '区域阻滞（包括椎管内麻醉和外周神经阻滞）麻醉后严重神经并发症指新发的重度头痛、局部感觉异常（麻木或异感）、运动异常（肌无力甚至瘫痪）等，持续超过72小时并排除其他病因者。', '无', '无', '无', NULL,
    '统计日期', '全院', '单位时间内区域阻滞麻醉后严重神经并发症发生例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.22.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '单位时间内区域阻滞麻醉后严重神经并发症发生例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期区域阻滞麻醉总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映区域阻滞麻醉后严重神经并发症发生率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期区域阻滞麻醉总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期区域阻滞麻醉总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.22.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期区域阻滞麻醉总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '区域阻滞麻醉后严重神经并发症发生率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，区域阻滞麻醉后严重神经并发症发生例数占同期区域阻滞麻醉总例数的比例。', '麻醉专业医疗质量控制指标（2022版）。', '反映区域阻滞麻醉后严重神经并发症发生情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：单位时间内区域阻滞麻醉后严重神经并发症发生例数。分母：同期区域阻滞麻醉总例数。', '无', '万分比（‱）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.22"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '区域阻滞麻醉后严重神经并发症发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
