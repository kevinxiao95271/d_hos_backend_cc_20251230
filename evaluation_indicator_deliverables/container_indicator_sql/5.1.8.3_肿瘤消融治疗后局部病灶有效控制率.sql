-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.8.3
-- 指标名称：肿瘤消融治疗后局部病灶有效控制率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '肿瘤消融治疗技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '肿瘤消融治疗后局部病灶有效控制的例次数';
SET @numerator_category_code = '5.1.8.3.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '肿瘤消融治疗后局部病灶有效控制的例次数占同期肿瘤消融治疗总例次数的比例。', '《肿瘤消融治疗技术临床应用管理规范（2022 版）》《肿瘤消融治疗技术临床应用质量控制指标（2022 版）》。', '反映肿瘤消融治疗后局部病灶的控制情况。',
    '肿瘤消融治疗技术数据源', NULL, '分子：是指患者在完成肿瘤消融治疗后一个月内，经增强影像学检查与治疗前影像学资料进行对照，证实肿瘤完全消融的例次数。 分母：是指同期进行肿瘤消融治疗的总例次数。 肿瘤局部病灶有效控制是指肿瘤消融治疗后 1 个月内，增强影像学检 查证实肿瘤完全消融。', '百分比（%）', '病历资料、随访记录。', NULL,
    '出院日期', '出院科室名称', '是否完成肿瘤消融治疗后局部病灶有效控制', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.8.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期肿瘤消融治疗总例次数';
SET @denominator_category_code = '5.1.8.3.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '肿瘤消融治疗后局部病灶有效控制的例次数占同期肿瘤消融治疗总例次数的比例。', '《肿瘤消融治疗技术临床应用管理规范（2022 版）》《肿瘤消融治疗技术临床应用质量控制指标（2022 版）》。', '反映肿瘤消融治疗后局部病灶的控制情况。',
    '肿瘤消融治疗技术数据源', NULL, '分子：是指患者在完成肿瘤消融治疗后一个月内，经增强影像学检查与治疗前影像学资料进行对照，证实肿瘤完全消融的例次数。 分母：是指同期进行肿瘤消融治疗的总例次数。 肿瘤局部病灶有效控制是指肿瘤消融治疗后 1 个月内，增强影像学检 查证实肿瘤完全消融。', '百分比（%）', '病历资料、随访记录。', NULL,
    '出院日期', '出院科室名称', '是否完成肿瘤消融治疗后局部病灶有效控制', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.8.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '肿瘤消融治疗后局部病灶有效控制率';
SET @category_code = '5.1.8.3';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '肿瘤消融治疗后局部病灶有效控制的例次数占同期肿瘤消融治疗总例次数的比例。', '《肿瘤消融治疗技术临床应用管理规范（2022 版）》《肿瘤消融治疗技术临床应用质量控制指标（2022 版）》。', '反映肿瘤消融治疗后局部病灶的控制情况。',
    '肿瘤消融治疗技术数据源', NULL, '分子：是指患者在完成肿瘤消融治疗后一个月内，经增强影像学检查与治疗前影像学资料进行对照，证实肿瘤完全消融的例次数。 分母：是指同期进行肿瘤消融治疗的总例次数。 肿瘤局部病灶有效控制是指肿瘤消融治疗后 1 个月内，增强影像学检 查证实肿瘤完全消融。', '百分比（%）', '病历资料、随访记录。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.8.3"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
