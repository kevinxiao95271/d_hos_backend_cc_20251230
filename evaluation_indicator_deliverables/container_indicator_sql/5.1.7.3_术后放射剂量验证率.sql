-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.7.3
-- 指标名称：术后放射剂量验证率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '放射性粒子植入治疗技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '术后完成放射剂量验证的患者例数';
SET @numerator_category_code = '5.1.7.3.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '术后放射剂量验证，是指放射性粒子植入术后进行影像学检查，并通过放射性粒子植入治疗计划系统完成放射剂量验证。术后放射剂量验证率，是指放射性粒子植入治疗后，完成术后放射剂量验证的患者例数占同期放射性粒子植入治疗总例数的比例。', '《放射性粒子植入治疗技术临床应用质量控制指标（2022版）》《放射性粒子植入治疗技术临床应用管理规范（2022 版）》。', '体现术后对患者病情整体评估情况，是反映医院放射性粒子植入治疗技术医疗质量的重要过程性指标之一。',
    '放射性粒子植入治疗技术数据源', NULL, '分子：是指术后按照操作规范要求实施放射剂量验证的患者数量。 分母：是指同期出院患者中完成放射性粒子植入治疗的患者总数。', '百分比（%）', '放射性粒子植入治疗术后质量验证记录。', NULL,
    '出院日期', '出院科室名称', '是否完成术后放射剂量验证', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.7.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期放射性粒子植入治疗总例数';
SET @denominator_category_code = '5.1.7.3.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '术后放射剂量验证，是指放射性粒子植入术后进行影像学检查，并通过放射性粒子植入治疗计划系统完成放射剂量验证。术后放射剂量验证率，是指放射性粒子植入治疗后，完成术后放射剂量验证的患者例数占同期放射性粒子植入治疗总例数的比例。', '《放射性粒子植入治疗技术临床应用质量控制指标（2022版）》《放射性粒子植入治疗技术临床应用管理规范（2022 版）》。', '体现术后对患者病情整体评估情况，是反映医院放射性粒子植入治疗技术医疗质量的重要过程性指标之一。',
    '放射性粒子植入治疗技术数据源', NULL, '分子：是指术后按照操作规范要求实施放射剂量验证的患者数量。 分母：是指同期出院患者中完成放射性粒子植入治疗的患者总数。', '百分比（%）', '放射性粒子植入治疗术后质量验证记录。', NULL,
    '出院日期', '出院科室名称', '是否完成术后放射剂量验证', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.7.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '术后放射剂量验证率';
SET @category_code = '5.1.7.3';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '术后放射剂量验证，是指放射性粒子植入术后进行影像学检查，并通过放射性粒子植入治疗计划系统完成放射剂量验证。术后放射剂量验证率，是指放射性粒子植入治疗后，完成术后放射剂量验证的患者例数占同期放射性粒子植入治疗总例数的比例。', '《放射性粒子植入治疗技术临床应用质量控制指标（2022版）》《放射性粒子植入治疗技术临床应用管理规范（2022 版）》。', '体现术后对患者病情整体评估情况，是反映医院放射性粒子植入治疗技术医疗质量的重要过程性指标之一。',
    '放射性粒子植入治疗技术数据源', NULL, '分子：是指术后按照操作规范要求实施放射剂量验证的患者数量。 分母：是指同期出院患者中完成放射性粒子植入治疗的患者总数。', '百分比（%）', '放射性粒子植入治疗术后质量验证记录。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.7.3"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
