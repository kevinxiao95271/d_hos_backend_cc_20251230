-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.9.1.1（与CSV文件中的编码完全一致）
-- 指标名称：癫痫发作频率记录率
-- 创建日期：2026-02-05
-- ===========================================

-- 依赖：请确保数据源"癫痫专病表查询"已创建
SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '癫痫专病表查询' AND INVALID = 0
    LIMIT 1
);

-- 查询类别ID：根据类别名称"癫痫"从数据库查询（使用LIKE模糊匹配）
SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE CATEGORY_NAME LIKE '%癫痫%' AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';

-- 创建分子指标（3.9.1.1.1）
SET @numerator_kpi_name = '各种发作类型的发作频率均得到记录的住院癫痫患者数';
SET @numerator_category_code = '3.9.1.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '各种发作类型的发作频率均得到记录的住院癫痫患者数', '《神经系统疾病医疗质量控制指标（2020 年版）》。 2.抗癫痫药物规范服用率', '治疗癫痫的主要目标是减少发作频率。准确记录各种发作类型的发作频率是抗癫痫治疗的依据和基础，也与健康相关生活质量的改善密切相关，是反映癫痫治疗效果的重要过程指标之一。',
    '癫痫专病表查询', NULL, '癫痫指至少2次间隔>24小时的非诱发性（或反射性）痫性发作，或确诊某种癫痫综合征。参考国际抗癫痫联盟（ILAE）发布的《ILAE官方报告：癫痫实用定义》。 癫痫的发作分类包括：局灶性发作、全面性发作、不明起始部位发作、未能分类发作。参考ILAE发布的《癫痫发作类型的操作分类：国际抗癫痫联盟意见书》。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否各种发作类型的发作频率均得到记录的癫痫', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建分母指标（3.9.1.1.2）
SET @denominator_kpi_name = '同期住院癫痫患者总数';
SET @denominator_category_code = '3.9.1.1.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期住院癫痫患者总数', '《神经系统疾病医疗质量控制指标（2020 年版）》。 2.抗癫痫药物规范服用率', '治疗癫痫的主要目标是减少发作频率。准确记录各种发作类型的发作频率是抗癫痫治疗的依据和基础，也与健康相关生活质量的改善密切相关，是反映癫痫治疗效果的重要过程指标之一。',
    '癫痫专病表查询', NULL, '癫痫指至少2次间隔>24小时的非诱发性（或反射性）痫性发作，或确诊某种癫痫综合征。参考国际抗癫痫联盟（ILAE）发布的《ILAE官方报告：癫痫实用定义》。 癫痫的发作分类包括：局灶性发作、全面性发作、不明起始部位发作、未能分类发作。参考ILAE发布的《癫痫发作类型的操作分类：国际抗癫痫联盟意见书》。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期癫痫患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建比率指标（3.9.1.1）
SET @kpi_name = '癫痫发作频率记录率';
SET @category_code = '3.9.1.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '单位时间内，住院癫痫患者中各种发作类型的发作频率均得到记录的人数占同期住院癫痫患者总数的比例。', '《神经系统疾病医疗质量控制指标（2020 年版）》。 2.抗癫痫药物规范服用率', '治疗癫痫的主要目标是减少发作频率。准确记录各种发作类型的发作频率是抗癫痫治疗的依据和基础，也与健康相关生活质量的改善密切相关，是反映癫痫治疗效果的重要过程指标之一。',
    '癫痫专病表查询', NULL, '癫痫指至少2次间隔>24小时的非诱发性（或反射性）痫性发作，或确诊某种癫痫综合征。参考国际抗癫痫联盟（ILAE）发布的《ILAE官方报告：癫痫实用定义》。 癫痫的发作分类包括：局灶性发作、全面性发作、不明起始部位发作、未能分类发作。参考ILAE发布的《癫痫发作类型的操作分类：国际抗癫痫联盟意见书》。', '百分比（%）', '无', NULL,
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
