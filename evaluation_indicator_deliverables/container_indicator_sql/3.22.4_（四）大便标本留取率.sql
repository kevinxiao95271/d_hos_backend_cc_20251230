-- ===========================================
-- 3.22.4 （四）大便标本留取率
-- 数据源：手工填报；分子：留取大便标本的健康体检人次数，分母：同期开具健康体检大便常规检查项目总人次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%健康体检与管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '留取大便标本的健康体检人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映大便标本留取率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '大便常规是健康体检常规检查的基本项目，可用于感染、炎症、消化道出血等消化道疾病的筛查，也是结直肠癌普查筛检最为简便、经济的手段。', '无', '无', '无', NULL,
    '统计日期', '全院', '留取大便标本的健康体检人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '留取大便标本的健康体检人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期开具健康体检大便常规检查项目总人次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映大便标本留取率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期开具健康体检大便常规检查项目总人次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期开具健康体检大便常规检查项目总人次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期开具健康体检大便常规检查项目总人次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）大便标本留取率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '留取大便标本的健康体检人次数占同期开具健康体检大便常规检查项目总人次数的比例。', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映大便标本留取情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：留取大便标本的健康体检人次数。分母：同期开具健康体检大便常规检查项目总人次数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）大便标本留取率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
