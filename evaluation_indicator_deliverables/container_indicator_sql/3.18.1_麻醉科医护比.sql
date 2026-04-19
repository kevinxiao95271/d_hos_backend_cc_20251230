-- ===========================================
-- 3.18.1 麻醉科医护比
-- 数据源：手工填报；分子：麻醉科护士总数，分母：麻醉科医师总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%麻醉专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '麻醉科护士总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映麻醉科医护比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '麻醉科护士指专职配合麻醉医师开展麻醉宣教、心理护理、物品准备、信息核对、体位摆放、管路护理、仪器设备管理等护理工作的护士。', '无', '无', '无', NULL,
    '统计日期', '全院', '麻醉科护士总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '麻醉科护士总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '麻醉科医师总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '麻醉专业医疗质量控制指标（2022版）。', '反映麻醉科医护比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '麻醉科医师总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '麻醉科医师总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '麻醉科医师总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '麻醉科医护比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '麻醉科护士人数与麻醉科医师人数之比。', '麻醉专业医疗质量控制指标（2022版）。', '反映麻醉科护士与医师配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：麻醉科护士总数。分母：麻醉科医师总数。配合开展围手术期工作的麻醉科护士与麻醉科医师的比例原则上不低于0.5:1。', '无', 'X:1', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.18.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '麻醉科医护比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
