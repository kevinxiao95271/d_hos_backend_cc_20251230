-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.6.2
-- 指标名称：临床TNM分期比例
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '质子和重离子加速器放射治疗技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '进行各临床TNM分期的患者数';
SET @numerator_category_code = '5.1.6.2.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '根据AJCC/UICC临床TNM分期标准，对于接受质子或重离子放射治疗的患者进行分期。临床TNM分期比例是指对实施质子或重离子放射治疗的患者进行各临床TNM分期的患者数占同期质子或重离子放射治疗患者总数的比例。', '《异基因造血干细胞移植技术临床应用管理规范（2022 年版）》《异基因造血干细胞移植技术临床应用质量控制指标（2022 年版）》。', '体现医院对造血干细胞移植术后患者的综合管理水平，是反映医院造血干细胞移植技术医疗质量的重要结果指标之一。',
    '质子和重离子加速器放射治疗技术数据源', NULL, '分子：是指完成异基因造血干细胞移植的患者，在术后100 天内由非复发的原因引起死亡的患者数量。 分母：是指同期出院患者中完成异基因造血干细胞移植术的患者总数。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成临床TNM分期', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.6.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期质子或重离子放射治疗患者总数';
SET @denominator_category_code = '5.1.6.2.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '根据AJCC/UICC临床TNM分期标准，对于接受质子或重离子放射治疗的患者进行分期。临床TNM分期比例是指对实施质子或重离子放射治疗的患者进行各临床TNM分期的患者数占同期质子或重离子放射治疗患者总数的比例。', '《异基因造血干细胞移植技术临床应用管理规范（2022 年版）》《异基因造血干细胞移植技术临床应用质量控制指标（2022 年版）》。', '体现医院对造血干细胞移植术后患者的综合管理水平，是反映医院造血干细胞移植技术医疗质量的重要结果指标之一。',
    '质子和重离子加速器放射治疗技术数据源', NULL, '分子：是指完成异基因造血干细胞移植的患者，在术后100 天内由非复发的原因引起死亡的患者数量。 分母：是指同期出院患者中完成异基因造血干细胞移植术的患者总数。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成临床TNM分期', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.6.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '临床TNM分期比例';
SET @category_code = '5.1.6.2';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '根据AJCC/UICC临床TNM分期标准，对于接受质子或重离子放射治疗的患者进行分期。临床TNM分期比例是指对实施质子或重离子放射治疗的患者进行各临床TNM分期的患者数占同期质子或重离子放射治疗患者总数的比例。', '《异基因造血干细胞移植技术临床应用管理规范（2022 年版）》《异基因造血干细胞移植技术临床应用质量控制指标（2022 年版）》。', '体现医院对造血干细胞移植术后患者的综合管理水平，是反映医院造血干细胞移植技术医疗质量的重要结果指标之一。',
    '质子和重离子加速器放射治疗技术数据源', NULL, '分子：是指完成异基因造血干细胞移植的患者，在术后100 天内由非复发的原因引起死亡的患者数量。 分母：是指同期出院患者中完成异基因造血干细胞移植术的患者总数。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.6.2"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
