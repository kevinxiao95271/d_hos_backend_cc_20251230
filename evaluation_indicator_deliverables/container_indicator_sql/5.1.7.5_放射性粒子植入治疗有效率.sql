-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.7.5
-- 指标名称：放射性粒子植入治疗有效率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '放射性粒子植入治疗技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '放射性粒子植入治疗有效的患者例数';
SET @numerator_category_code = '5.1.7.5.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '放射性粒子植入治疗有效，是指对放射性粒子植入术后进行疗效评价，按照实体瘤疗效评价新标准（Response Evaluation Criteria in Solid Tumors，RECIST）达到完全缓解、部分缓解、肿瘤稳定状态。放射性粒子植入治疗有效率，是指放射性粒子植入治疗有效的患者例数占同期放射性粒子植入治疗总例数的比例。 实体瘤疗效评价新标准主要包括以下几项： ①完全缓解：所有靶病灶消失，无新病灶出现，且肿瘤标志物正常，至少维持 4 周。 ②部分缓解：靶病灶最大径之和减少≥30% ，至少维持 4 周。 ③肿瘤稳定：靶病灶最大径之和缩小未达到部分缓解，或增大未达到肿瘤进展。 ④肿瘤进展：靶病灶最大径之和至少增加 20% ，或者出现新病灶。', '《放射性粒子植入治疗技术临床应用质量控制指标（2022 版）》《放射性粒子植入治疗技术临床应用管理规范（2022 版）》。', '反映医院开展放射性粒子植入技术的效果，是反映医院放射性粒子植入技术医疗质量的重要结果指标之一。',
    '放射性粒子植入治疗技术数据源', NULL, '分子：是指完成放射性粒子植入技术的患者，经过实体瘤疗效评价新标准评估后，提示治疗有效的患者数量。 分母：是指同期出院患者中完成放射性粒子植入治疗的患者总数。', '百分比（%）', '病历资料、随访记录。', NULL,
    '出院日期', '出院科室名称', '是否完成放射性粒子植入治疗有效', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.7.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期放射性粒子植入治疗总例数';
SET @denominator_category_code = '5.1.7.5.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '放射性粒子植入治疗有效，是指对放射性粒子植入术后进行疗效评价，按照实体瘤疗效评价新标准（Response Evaluation Criteria in Solid Tumors，RECIST）达到完全缓解、部分缓解、肿瘤稳定状态。放射性粒子植入治疗有效率，是指放射性粒子植入治疗有效的患者例数占同期放射性粒子植入治疗总例数的比例。 实体瘤疗效评价新标准主要包括以下几项： ①完全缓解：所有靶病灶消失，无新病灶出现，且肿瘤标志物正常，至少维持 4 周。 ②部分缓解：靶病灶最大径之和减少≥30% ，至少维持 4 周。 ③肿瘤稳定：靶病灶最大径之和缩小未达到部分缓解，或增大未达到肿瘤进展。 ④肿瘤进展：靶病灶最大径之和至少增加 20% ，或者出现新病灶。', '《放射性粒子植入治疗技术临床应用质量控制指标（2022 版）》《放射性粒子植入治疗技术临床应用管理规范（2022 版）》。', '反映医院开展放射性粒子植入技术的效果，是反映医院放射性粒子植入技术医疗质量的重要结果指标之一。',
    '放射性粒子植入治疗技术数据源', NULL, '分子：是指完成放射性粒子植入技术的患者，经过实体瘤疗效评价新标准评估后，提示治疗有效的患者数量。 分母：是指同期出院患者中完成放射性粒子植入治疗的患者总数。', '百分比（%）', '病历资料、随访记录。', NULL,
    '出院日期', '出院科室名称', '是否完成放射性粒子植入治疗有效', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.7.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '放射性粒子植入治疗有效率';
SET @category_code = '5.1.7.5';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '放射性粒子植入治疗有效，是指对放射性粒子植入术后进行疗效评价，按照实体瘤疗效评价新标准（Response Evaluation Criteria in Solid Tumors，RECIST）达到完全缓解、部分缓解、肿瘤稳定状态。放射性粒子植入治疗有效率，是指放射性粒子植入治疗有效的患者例数占同期放射性粒子植入治疗总例数的比例。 实体瘤疗效评价新标准主要包括以下几项： ①完全缓解：所有靶病灶消失，无新病灶出现，且肿瘤标志物正常，至少维持 4 周。 ②部分缓解：靶病灶最大径之和减少≥30% ，至少维持 4 周。 ③肿瘤稳定：靶病灶最大径之和缩小未达到部分缓解，或增大未达到肿瘤进展。 ④肿瘤进展：靶病灶最大径之和至少增加 20% ，或者出现新病灶。', '《放射性粒子植入治疗技术临床应用质量控制指标（2022 版）》《放射性粒子植入治疗技术临床应用管理规范（2022 版）》。', '反映医院开展放射性粒子植入技术的效果，是反映医院放射性粒子植入技术医疗质量的重要结果指标之一。',
    '放射性粒子植入治疗技术数据源', NULL, '分子：是指完成放射性粒子植入技术的患者，经过实体瘤疗效评价新标准评估后，提示治疗有效的患者数量。 分母：是指同期出院患者中完成放射性粒子植入治疗的患者总数。', '百分比（%）', '病历资料、随访记录。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.7.5"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
