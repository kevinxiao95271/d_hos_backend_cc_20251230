-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.1.9
-- 指标名称：ICU非计划气管插管拔管率
-- 创建日期：2026-02-05
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '重症医学专病表查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%重症医学%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

SET @numerator_kpi_name = 'ICU气管插管患者非计划拔管的例数';
SET @numerator_category_code = '3.1.9.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    'ICU气管插管患者非计划拔管的例数', '《重症医学专业医疗质量控制指标（2021年版）》。', '评价ICU气管插管管理质量',
    '重症医学专病表查询', NULL, '分子：ICU气管插管患者非计划拔管的例数。分母：同一统计周期内ICU患者气管插管拔管总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否ICU气管插管患者非计划拔管', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同一统计周期内ICU患者气管插管拔管总数';
SET @denominator_category_code = '3.1.9.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同一统计周期内ICU患者气管插管拔管总数', '《重症医学专业医疗质量控制指标（2021年版）》。', '评价ICU气管插管管理质量',
    '重症医学专病表查询', NULL, '分子：ICU气管插管患者非计划拔管的例数。分母：同一统计周期内ICU患者气管插管拔管总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期ICU患者气管插管拔管', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = 'ICU非计划气管插管拔管率';
SET @category_code = '3.1.9';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '非计划气管插管拔管例数占同期ICU患者气管插管拔管总数的比例', '《重症医学专业医疗质量控制指标（2021年版）》。', '评价ICU气管插管管理质量',
    '重症医学专病表查询', NULL, '分子：ICU气管插管患者非计划拔管的例数。分母：同一统计周期内ICU患者气管插管拔管总数。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
