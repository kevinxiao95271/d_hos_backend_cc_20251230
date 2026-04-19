-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.7.1
-- 指标名称：植入指征正确率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '放射性粒子植入治疗技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '放射性粒子植入技术应用适应症选择正确的例数';
SET @numerator_category_code = '5.1.7.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '放射性粒子植入治疗技术应用适应证选择正确的例数占同期放射性粒子植入治疗总例数的比例。 应用放射性粒子植入治疗技术应当符合肿瘤临床分期的诊断指标，包括：①局部晚期肿瘤已失去手术机会（前列腺癌除外）；②肿瘤最大径≤7cm；③手术后、放疗后肿瘤复发或转移，肿瘤转移灶数目≤5 个，单个转移灶直径≤5cm；④患者一般身体状况卡氏评分 70 分以上；⑤拟经皮穿刺者有进针路径；⑥肿瘤空腔脏器（食道、胆道、门静脉等）出现恶性梗阻；⑦无严重穿刺禁忌证；⑧患者预计生存期≥3 个月；⑨患者拒绝其他治疗。①-③项指标中至少符合 2 项，且④-⑨项指标中至少符合 3 项即为适应证选择正确。', '《放射性粒子植入治疗技术临床应用质量控制指标（2022版）》《放射性粒子植入治疗技术临床应用管理规范（2022 版）》。', '反映医院开展放射性粒子植入技术时严格掌握适应证的程度，是反映医院放射性粒子植入技术医疗质量的重要过程性指标之一。',
    '放射性粒子植入治疗技术数据源', NULL, '分子：是指经过肿瘤临床分期诊断指标评估后，符合条 件并完成放射性粒子植入的出院患者人数。 分母：是指同期出院患者中完成放射性粒子植入治疗的总人数，统计单位以人数计算。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成植入指征正确', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.7.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期放射性粒子植入治疗总例数';
SET @denominator_category_code = '5.1.7.1.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '放射性粒子植入治疗技术应用适应证选择正确的例数占同期放射性粒子植入治疗总例数的比例。 应用放射性粒子植入治疗技术应当符合肿瘤临床分期的诊断指标，包括：①局部晚期肿瘤已失去手术机会（前列腺癌除外）；②肿瘤最大径≤7cm；③手术后、放疗后肿瘤复发或转移，肿瘤转移灶数目≤5 个，单个转移灶直径≤5cm；④患者一般身体状况卡氏评分 70 分以上；⑤拟经皮穿刺者有进针路径；⑥肿瘤空腔脏器（食道、胆道、门静脉等）出现恶性梗阻；⑦无严重穿刺禁忌证；⑧患者预计生存期≥3 个月；⑨患者拒绝其他治疗。①-③项指标中至少符合 2 项，且④-⑨项指标中至少符合 3 项即为适应证选择正确。', '《放射性粒子植入治疗技术临床应用质量控制指标（2022版）》《放射性粒子植入治疗技术临床应用管理规范（2022 版）》。', '反映医院开展放射性粒子植入技术时严格掌握适应证的程度，是反映医院放射性粒子植入技术医疗质量的重要过程性指标之一。',
    '放射性粒子植入治疗技术数据源', NULL, '分子：是指经过肿瘤临床分期诊断指标评估后，符合条 件并完成放射性粒子植入的出院患者人数。 分母：是指同期出院患者中完成放射性粒子植入治疗的总人数，统计单位以人数计算。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成植入指征正确', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.7.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '植入指征正确率';
SET @category_code = '5.1.7.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '放射性粒子植入治疗技术应用适应证选择正确的例数占同期放射性粒子植入治疗总例数的比例。 应用放射性粒子植入治疗技术应当符合肿瘤临床分期的诊断指标，包括：①局部晚期肿瘤已失去手术机会（前列腺癌除外）；②肿瘤最大径≤7cm；③手术后、放疗后肿瘤复发或转移，肿瘤转移灶数目≤5 个，单个转移灶直径≤5cm；④患者一般身体状况卡氏评分 70 分以上；⑤拟经皮穿刺者有进针路径；⑥肿瘤空腔脏器（食道、胆道、门静脉等）出现恶性梗阻；⑦无严重穿刺禁忌证；⑧患者预计生存期≥3 个月；⑨患者拒绝其他治疗。①-③项指标中至少符合 2 项，且④-⑨项指标中至少符合 3 项即为适应证选择正确。', '《放射性粒子植入治疗技术临床应用质量控制指标（2022版）》《放射性粒子植入治疗技术临床应用管理规范（2022 版）》。', '反映医院开展放射性粒子植入技术时严格掌握适应证的程度，是反映医院放射性粒子植入技术医疗质量的重要过程性指标之一。',
    '放射性粒子植入治疗技术数据源', NULL, '分子：是指经过肿瘤临床分期诊断指标评估后，符合条 件并完成放射性粒子植入的出院患者人数。 分母：是指同期出院患者中完成放射性粒子植入治疗的总人数，统计单位以人数计算。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.7.1"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
