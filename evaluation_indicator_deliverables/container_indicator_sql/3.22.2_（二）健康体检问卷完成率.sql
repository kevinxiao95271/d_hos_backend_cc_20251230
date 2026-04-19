-- ===========================================
-- 3.22.2 （二）健康体检问卷完成率
-- 数据源：手工填报；分子：完成健康体检问卷人数，分母：同期健康体检总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%健康体检与管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '完成健康体检问卷人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映健康体检问卷完成率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '健康体检问卷应包括个人基本信息、健康史、生活方式（饮食、吸烟、饮酒、运动锻炼）等内容，参考中华医学会健康管理学分会《健康体检基本项目专家共识》。', '无', '无', '无', NULL,
    '统计日期', '全院', '完成健康体检问卷人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '完成健康体检问卷人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期健康体检总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映健康体检问卷完成率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期健康体检总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期健康体检总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期健康体检总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二）健康体检问卷完成率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '完成健康体检问卷人数占同期健康体检总人数的比例。', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映健康体检问卷完成情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：完成健康体检问卷人数。分母：同期健康体检总人数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二）健康体检问卷完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
