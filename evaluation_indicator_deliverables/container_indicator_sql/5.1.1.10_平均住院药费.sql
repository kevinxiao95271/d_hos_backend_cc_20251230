-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.1.10
-- 指标名称：平均住院药费
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '异基因造血干细胞移植技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '出院时异基因造血干细胞移植的患者住院总费用';
SET @numerator_category_code = '5.1.1.10.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    '实施异基因造血干细胞移植治疗的患者出院时住院药品总费用与同期异基因造血干细胞移植治疗患者出院人数之比。', '《异基因造血干细胞移植技术临床应用管理规范（2022年版）》《异基因造血干细胞移植技术临床应用质量控制指标（2022 年版）》。', '体现医院造血干细胞移植技术的社会经济学效益，是反映医院造血干细胞移植技术医疗质量的重要结果指标之一。',
    '异基因造血干细胞移植技术数据源', NULL, '分子：是指实施异基因造血干细胞移植治疗的患者出院时住院药品总费用。 分母：是指同期出院患者中完成异基因造血干细胞移植治疗的患者总人数。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成平均住院药费', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.1.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期异基因造血干细胞移植治疗患者出院人数';
SET @denominator_category_code = '5.1.1.10.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    '实施异基因造血干细胞移植治疗的患者出院时住院药品总费用与同期异基因造血干细胞移植治疗患者出院人数之比。', '《异基因造血干细胞移植技术临床应用管理规范（2022年版）》《异基因造血干细胞移植技术临床应用质量控制指标（2022 年版）》。', '体现医院造血干细胞移植技术的社会经济学效益，是反映医院造血干细胞移植技术医疗质量的重要结果指标之一。',
    '异基因造血干细胞移植技术数据源', NULL, '分子：是指实施异基因造血干细胞移植治疗的患者出院时住院药品总费用。 分母：是指同期出院患者中完成异基因造血干细胞移植治疗的患者总人数。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成平均住院药费', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.1.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '平均住院药费';
SET @category_code = '5.1.1.10';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '实施异基因造血干细胞移植治疗的患者出院时住院药品总费用与同期异基因造血干细胞移植治疗患者出院人数之比。', '《异基因造血干细胞移植技术临床应用管理规范（2022年版）》《异基因造血干细胞移植技术临床应用质量控制指标（2022 年版）》。', '体现医院造血干细胞移植技术的社会经济学效益，是反映医院造血干细胞移植技术医疗质量的重要结果指标之一。',
    '异基因造血干细胞移植技术数据源', NULL, '分子：是指实施异基因造血干细胞移植治疗的患者出院时住院药品总费用。 分母：是指同期出院患者中完成异基因造血干细胞移植治疗的患者总人数。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.1.10"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
