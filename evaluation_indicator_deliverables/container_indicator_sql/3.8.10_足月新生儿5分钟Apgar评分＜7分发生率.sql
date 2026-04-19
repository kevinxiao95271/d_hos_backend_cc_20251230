-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.8.10
-- 指标名称：足月新生儿5分钟Apgar评分＜7分发生率
-- 创建日期：2026-02-05
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '产科专病表查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%产科%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

SET @numerator_kpi_name = '足月新生儿5分钟人数Apgar评分＜7分';
SET @numerator_category_code = '3.8.10.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '足月新生儿5分钟人数Apgar评分＜7分', '《产科专业医疗质量控制指标（2021年版）》。', '评价新生儿Apgar评分情况',
    '产科专病表查询', NULL, '分子：足月新生儿5分钟人数Apgar评分＜7分。分母：同期足月活产儿总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否5分钟Apgar评分小于7分', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期足月活产儿总数';
SET @denominator_category_code = '3.8.10.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期足月活产儿总数', '《产科专业医疗质量控制指标（2021年版）》。', '评价新生儿Apgar评分情况',
    '产科专病表查询', NULL, '分子：足月新生儿5分钟人数Apgar评分＜7分。分母：同期足月活产儿总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期分娩产妇', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '足月新生儿5分钟Apgar评分＜7分发生率';
SET @category_code = '3.8.10';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '单位时间内，足月新生儿（分娩孕周≥37周）出生后5分钟Apgar评分＜7分人数占同期内足月活产儿总数的比例', '《产科专业医疗质量控制指标（2021年版）》。', '评价新生儿Apgar评分情况',
    '产科专病表查询', NULL, '分子：足月新生儿5分钟人数Apgar评分＜7分。分母：同期足月活产儿总数。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
