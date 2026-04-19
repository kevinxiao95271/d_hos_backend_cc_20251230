-- ===========================================
-- 3.22.1 （一）高级职称医师签署报告率
-- 数据源：手工填报；分子：高级职称医师签署健康体检报告主检结论的例数，分母：同期健康体检报告总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%健康体检与管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '高级职称医师签署健康体检报告主检结论的例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映高级职称医师签署报告率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '高级职称医师指具有副主任医师以上专业技术职务任职资格的内科或外科执业医师。', '无', '无', '无', NULL,
    '统计日期', '全院', '高级职称医师签署健康体检报告主检结论的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '高级职称医师签署健康体检报告主检结论的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期健康体检报告总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映高级职称医师签署报告率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期健康体检报告总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期健康体检报告总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期健康体检报告总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）高级职称医师签署报告率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '高级职称医师签署健康体检报告主检结论的例数占同期健康体检报告总数的比例。', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映高级职称医师签署报告情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：高级职称医师签署健康体检报告主检结论的例数。分母：同期健康体检报告总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）高级职称医师签署报告率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
