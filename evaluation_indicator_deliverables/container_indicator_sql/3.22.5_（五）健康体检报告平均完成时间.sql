-- ===========================================
-- 3.22.5 （五）健康体检报告平均完成时间
-- 数据源：手工填报；单位：天；分子：健康体检报告完成时间总和，分母：同期健康体检报告总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%健康体检与管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '健康体检报告完成时间总和', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映健康体检报告平均完成时间分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '健康体检报告完成时间指受检者体检项目全部检查完成后到出具体检报告的时间(天)。', '无', '无', '无', NULL,
    '统计日期', '全院', '健康体检报告完成时间总和',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '健康体检报告完成时间总和' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期健康体检报告总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映健康体检报告平均完成时间分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期健康体检报告总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期健康体检报告总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期健康体检报告总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（五）健康体检报告平均完成时间', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '健康体检报告完成时间总和与同期健康体检报告总数的比值。', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映健康体检报告平均完成时间。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：健康体检报告完成时间总和。分母：同期健康体检报告总数。报告完成时间指受检者体检项目全部检查完成后到出具体检报告的时间(天)。', '无', '天', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.5"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（五）健康体检报告平均完成时间' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
