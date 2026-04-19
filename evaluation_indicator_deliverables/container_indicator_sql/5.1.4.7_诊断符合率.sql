-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.4.7
-- 指标名称：诊断符合率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '同种异体角膜移植技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '诊断符合的例数';
SET @numerator_category_code = '5.1.4.7.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '诊断符合是指同种异体角膜移植患者的术后诊断（包括病理诊断）与入院诊断符合。诊断符合率是指诊断符合的例数占同期同种异体角膜移植总例数的比例。', '《同种异体角膜移植技术临床应用管理规范（2022 版）》 《同种异体角膜移植技术临床应用质量控制指标（2022 版）》。', '反映医院同种异体角膜移植患者入院诊断的准确性。',
    '同种异体角膜移植技术数据源', NULL, '分子：是指在完成同种异体角膜移植术的患者中，术后诊断（含病理诊断）与术前诊断符合的患者例数。 分母：是指同期出院患者中完成同种异体角膜移植的总例数。', '百分比（%）', '病历资料。', NULL,
    '出院日期', '出院科室名称', '是否完成诊断符合', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.4.7.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期同种异体角膜移植总例数';
SET @denominator_category_code = '5.1.4.7.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '诊断符合是指同种异体角膜移植患者的术后诊断（包括病理诊断）与入院诊断符合。诊断符合率是指诊断符合的例数占同期同种异体角膜移植总例数的比例。', '《同种异体角膜移植技术临床应用管理规范（2022 版）》 《同种异体角膜移植技术临床应用质量控制指标（2022 版）》。', '反映医院同种异体角膜移植患者入院诊断的准确性。',
    '同种异体角膜移植技术数据源', NULL, '分子：是指在完成同种异体角膜移植术的患者中，术后诊断（含病理诊断）与术前诊断符合的患者例数。 分母：是指同期出院患者中完成同种异体角膜移植的总例数。', '百分比（%）', '病历资料。', NULL,
    '出院日期', '出院科室名称', '是否完成诊断符合', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.4.7.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '诊断符合率';
SET @category_code = '5.1.4.7';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '诊断符合是指同种异体角膜移植患者的术后诊断（包括病理诊断）与入院诊断符合。诊断符合率是指诊断符合的例数占同期同种异体角膜移植总例数的比例。', '《同种异体角膜移植技术临床应用管理规范（2022 版）》 《同种异体角膜移植技术临床应用质量控制指标（2022 版）》。', '反映医院同种异体角膜移植患者入院诊断的准确性。',
    '同种异体角膜移植技术数据源', NULL, '分子：是指在完成同种异体角膜移植术的患者中，术后诊断（含病理诊断）与术前诊断符合的患者例数。 分母：是指同期出院患者中完成同种异体角膜移植的总例数。', '百分比（%）', '病历资料。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.4.7"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
