-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.7.20
-- 指标名称：住院CAP患者接受机械通气的比例
-- 创建日期：2026-02-05
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '成人社区获得性肺炎专病表查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%呼吸医学%' OR CATEGORY_NAME LIKE '%社区获得性肺炎%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

SET @numerator_kpi_name = '使用机械通气治疗的CAP人数';
SET @numerator_category_code = '3.7.20.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    '使用机械通气治疗的CAP人数', '《呼吸系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价CAP患者机械通气使用情况',
    '成人社区获得性肺炎专病表查询', NULL, '分子：使用机械通气治疗的CAP人数。分母：同期住院CAP患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否使用机械通气治疗的CAP患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期住院CAP患者总数';
SET @denominator_category_code = '3.7.20.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期住院CAP患者总数', '《呼吸系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价CAP患者机械通气使用情况',
    '成人社区获得性肺炎专病表查询', NULL, '分子：使用机械通气治疗的CAP人数。分母：同期住院CAP患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期住院CAP患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '住院CAP患者接受机械通气的比例';
SET @category_code = '3.7.20';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '单位时间内，住院期间接受机械通气（包括无创/有创机械通气）的CAP患者数与住院CAP患者总数的比例', '《呼吸系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价CAP患者机械通气使用情况',
    '成人社区获得性肺炎专病表查询', NULL, '分子：使用机械通气治疗的CAP人数。分母：同期住院CAP患者总数。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
