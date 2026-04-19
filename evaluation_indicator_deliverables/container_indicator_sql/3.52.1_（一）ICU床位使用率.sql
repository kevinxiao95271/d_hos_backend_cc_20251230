-- ===========================================
-- 0352 填报类指标注册脚本
-- 指标编码：3.52.1（一）ICU床位使用率
-- 数据源：重症医学填报数据源（共用）
-- 参数顺序与 sp_kpi_item_create 一致（见 upgrade_multiple_categories.sql，共41参，第8位为 p_indicator_business_type）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '重症医学填报数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%重症医学%2024%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 3.52.1.1
CALL sp_kpi_item_create(
    'ICU实际占用总床日数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, '{}',
    'ICU实际占用总床日数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映医院重症床位资源使用效率',
    '重症医学填报数据源', NULL, 'full', '分子：ICU实际占用总床日数。分母：同期ICU实际开放总床日数。', '无', '无', NULL, '无', '无', '无',
    '统计日期', '科室名称', 'ICU实际占用总床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["主键ID","统计日期","科室名称"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.52.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'ICU实际占用总床日数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.52.1.2
CALL sp_kpi_item_create(
    '同期ICU实际开放总床日数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, '{}',
    '同期ICU实际开放总床日数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映医院重症床位资源使用效率',
    '重症医学填报数据源', NULL, 'full', '分子：ICU实际占用总床日数。分母：同期ICU实际开放总床日数。', '无', '无', NULL, '无', '无', '无',
    '统计日期', '科室名称', '同期ICU实际开放总床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["主键ID","统计日期","科室名称"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.52.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期ICU实际开放总床日数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.52.1
CALL sp_kpi_item_create(
    '（一）ICU床位使用率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, '{}',
    'ICU实际占用总床日数与同期ICU实际开放总床日数之比', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映医院重症床位资源使用效率',
    '重症医学填报数据源', NULL, 'full', '本指标中的ICU包括综合ICU和各专科ICU等所有重症医学救治单元，不含可转化ICU。', NULL, NULL, '百分比（%）', '无', '无', '无',
    '统计日期', '科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["科室名称"]', '[]', '["主键ID","统计日期","科室名称"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.52.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）ICU床位使用率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
