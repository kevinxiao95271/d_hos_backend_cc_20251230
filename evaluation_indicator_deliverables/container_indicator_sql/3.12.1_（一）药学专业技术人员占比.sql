-- ===========================================
-- 3.12.1 （一）药学专业技术人员占比
-- 数据源：手工填报；分子：药学专业技术人员数，分母：同期医疗机构卫生专业技术人员总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '药学专业技术人员数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映药学专业技术人员占比分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '药学专业技术人员是指按照有关规定取得药学专业任职资格的由医疗机构聘任的在职人员。', '无', '无', '无', NULL,
    '统计日期', '全院', '药学专业技术人员数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '药学专业技术人员数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期医疗机构卫生专业技术人员总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映药学专业技术人员占比分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '卫生专业技术人员是指由医疗机构聘任的在职卫生专业技术人员，不含后勤等辅助部门的人员。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期医疗机构卫生专业技术人员总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期医疗机构卫生专业技术人员总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）药学专业技术人员占比', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '药学专业人员数占同期医疗机构卫生专业技术人员总数的比例。', '药事管理专业医疗质量控制指标（2020版）。', '反映药学人员配置。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：药学专业技术人员数。分母：同期医疗机构卫生专业技术人员总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）药学专业技术人员占比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
