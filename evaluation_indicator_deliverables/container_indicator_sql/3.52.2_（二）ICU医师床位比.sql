-- ===========================================
-- 0352 填报类指标注册脚本
-- 指标编码：3.52.2（二）ICU医师床位比
-- 数据源：重症医学填报数据源（共用）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '重症医学填报数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%重症医学%2024%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 3.52.2.1
CALL sp_kpi_item_create(
    'ICU医师总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, '{}',
    'ICU医师总数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映医院ICU人力资源配置',
    '重症医学填报数据源', NULL, 'full', '分子：ICU医师总数。分母：ICU实际开放床位数。', '无', '无', NULL, '无', '无', '无',
    '统计日期', '科室名称', 'ICU医师总数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["主键ID","统计日期","科室名称"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.52.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'ICU医师总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.52.2.2
CALL sp_kpi_item_create(
    'ICU实际开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, '{}',
    'ICU实际开放床位数', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映医院ICU人力资源配置',
    '重症医学填报数据源', NULL, 'full', '分子：ICU医师总数。分母：ICU实际开放床位数。', '无', '无', NULL, '无', '无', '无',
    '统计日期', '科室名称', 'ICU实际开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["主键ID","统计日期","科室名称"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.52.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'ICU实际开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.52.2
CALL sp_kpi_item_create(
    '（二）ICU医师床位比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, @data_source_id, '{}',
    'ICU医师总数与ICU实际开放床位数之比', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映医院ICU人力资源配置',
    '重症医学填报数据源', NULL, 'full', '本指标中ICU医师是指主要执业机构为本机构，全职从事ICU工作的执业医师。', NULL, NULL, '比值', '无', '无', '无',
    '统计日期', '科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["科室名称"]', '[]', '["主键ID","统计日期","科室名称"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.52.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二）ICU医师床位比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
