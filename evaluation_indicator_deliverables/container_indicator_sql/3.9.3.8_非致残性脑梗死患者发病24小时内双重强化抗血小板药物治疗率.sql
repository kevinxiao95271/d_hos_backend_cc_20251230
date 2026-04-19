-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.9.3.8（与CSV文件中的编码完全一致）
-- 指标名称：非致残性脑梗死患者发病24小时内双重强化抗血小板药物治疗率
-- 创建日期：2026-02-05
-- ===========================================

-- 依赖：请确保数据源"脑梗死专病表查询"已创建
SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '脑梗死专病表查询' AND INVALID = 0
    LIMIT 1
);

-- 查询类别ID：根据类别名称"脑梗死"从数据库查询（使用LIKE模糊匹配）
SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE CATEGORY_NAME LIKE '%脑梗死%' AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';

-- 创建分子指标（3.9.3.8.1）
SET @numerator_kpi_name = '发病24小时内给予阿司匹林和氯吡格雷强化抗血小板药物治疗的非致残性脑梗死患者';
SET @numerator_category_code = '3.9.3.8.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '发病24小时内给予阿司匹林和氯吡格雷强化抗血小板药物治疗的非致残性脑梗死患者', '《神经系统疾病医疗质量控制指标（2020 年版）》《中国脑血管病临床管理指南（2019 年版）》。 2.发病 24 小时内脑梗死患者急诊就诊 30 分钟内完成头颅CT 影像学检查率', '反映医疗机构收住院脑梗死患者病情评估开展情况。',
    '脑梗死专病表查询', NULL, '《中国脑血管病临床管理指南2019》中，“4.2双联抗血小板治疗”，推荐意见：对于未接受静脉溶栓治疗的轻型卒中及高危TIA患者，在发病24h内启动双重抗血小板治疗[阿司匹林100mg/d，联合氯吡格雷75mg/d（首日负荷剂量为300mg）]，并持续21d，后可改成单药氯吡格雷75mg/d，能显著降低90d的卒中复发（Ⅰ类推荐，A级证据）。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否发病24小时内给予阿司匹林和氯吡格雷强化抗血小板药物治疗的非致残性脑梗死患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建分母指标（3.9.3.8.2）
SET @denominator_kpi_name = '同期住院非致残性脑梗死患者总数';
SET @denominator_category_code = '3.9.3.8.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期住院非致残性脑梗死患者总数', '《神经系统疾病医疗质量控制指标（2020 年版）》《中国脑血管病临床管理指南（2019 年版）》。 2.发病 24 小时内脑梗死患者急诊就诊 30 分钟内完成头颅CT 影像学检查率', '反映医疗机构收住院脑梗死患者病情评估开展情况。',
    '脑梗死专病表查询', NULL, '《中国脑血管病临床管理指南2019》中，“4.2双联抗血小板治疗”，推荐意见：对于未接受静脉溶栓治疗的轻型卒中及高危TIA患者，在发病24h内启动双重抗血小板治疗[阿司匹林100mg/d，联合氯吡格雷75mg/d（首日负荷剂量为300mg）]，并持续21d，后可改成单药氯吡格雷75mg/d，能显著降低90d的卒中复发（Ⅰ类推荐，A级证据）。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期非致残性脑梗死患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建比率指标（3.9.3.8）
SET @kpi_name = '非致残性脑梗死患者发病24小时内双重强化抗血小板药物治疗率';
SET @category_code = '3.9.3.8';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '单位时间内，发病24小时内给予阿司匹林和氯吡格雷强化抗血小板药物治疗的非致残性脑梗死（NIHSS≤3分）患者数，占同期住院非致残性脑梗死患者总数的比例。', '《神经系统疾病医疗质量控制指标（2020 年版）》《中国脑血管病临床管理指南（2019 年版）》。 2.发病 24 小时内脑梗死患者急诊就诊 30 分钟内完成头颅CT 影像学检查率', '反映医疗机构收住院脑梗死患者病情评估开展情况。',
    '脑梗死专病表查询', NULL, '《中国脑血管病临床管理指南2019》中，“4.2双联抗血小板治疗”，推荐意见：对于未接受静脉溶栓治疗的轻型卒中及高危TIA患者，在发病24h内启动双重抗血小板治疗[阿司匹林100mg/d，联合氯吡格雷75mg/d（首日负荷剂量为300mg）]，并持续21d，后可改成单药氯吡格雷75mg/d，能显著降低90d的卒中复发（Ⅰ类推荐，A级证据）。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL);

SELECT
    k.ID AS 指标ID,
    k.KPI_NAME AS 指标名称,
    k.KPI_TYPE AS 指标类型,
    k.NUMERATOR_KPI_ID AS 分子指标ID,
    k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k
WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0
ORDER BY k.CREATE_TIME DESC
LIMIT 1;
