-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.12.5
-- 指标名称：术后全身系统严重并发症发生率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '自体器官移植技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '术后发生全身系统严重并发症的患者数';
SET @numerator_category_code = '5.1.12.5.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '术后全身系统严重并发症是指自体器官移植术患者，术后发生的心脑血管意外（如心肌梗死、缺血性脑卒中、脑出血等）、肺栓塞、呼吸衰竭、肾衰竭、深静脉血栓、肝功能衰竭等并发症。术后全身系统严重并发症发生率是指术后发生全身系统严重并发症的患者数占同期自体器官移植术患者总数的比例。', '《自体器官移植技术临床应用管理规范（2022 版）》《自体器官移植技术临床应用质量控制指标（2022 版）》。', '反映医疗机构自体器官移植技术水平的重要结果指标之一。',
    '自体器官移植技术数据源', NULL, '分子：是指完成自体器官移植术的患者，在术后发生全身系统严重并发症的患者数，如心脑血管意外、肺栓塞、呼吸衰竭、肾衰竭、深静脉血栓、肝功能衰竭等。 分母：是指同期出院患者中完成自体器官移植术的总例数。', '百分比（%）', '病案首页不良事件报告管理系统。', NULL,
    '出院日期', '出院科室名称', '是否完成术后全身系统严重并发症发生', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.12.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期自体器官移植术总例数';
SET @denominator_category_code = '5.1.12.5.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '术后全身系统严重并发症是指自体器官移植术患者，术后发生的心脑血管意外（如心肌梗死、缺血性脑卒中、脑出血等）、肺栓塞、呼吸衰竭、肾衰竭、深静脉血栓、肝功能衰竭等并发症。术后全身系统严重并发症发生率是指术后发生全身系统严重并发症的患者数占同期自体器官移植术患者总数的比例。', '《自体器官移植技术临床应用管理规范（2022 版）》《自体器官移植技术临床应用质量控制指标（2022 版）》。', '反映医疗机构自体器官移植技术水平的重要结果指标之一。',
    '自体器官移植技术数据源', NULL, '分子：是指完成自体器官移植术的患者，在术后发生全身系统严重并发症的患者数，如心脑血管意外、肺栓塞、呼吸衰竭、肾衰竭、深静脉血栓、肝功能衰竭等。 分母：是指同期出院患者中完成自体器官移植术的总例数。', '百分比（%）', '病案首页不良事件报告管理系统。', NULL,
    '出院日期', '出院科室名称', '是否完成术后全身系统严重并发症发生', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.12.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '术后全身系统严重并发症发生率';
SET @category_code = '5.1.12.5';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '术后全身系统严重并发症是指自体器官移植术患者，术后发生的心脑血管意外（如心肌梗死、缺血性脑卒中、脑出血等）、肺栓塞、呼吸衰竭、肾衰竭、深静脉血栓、肝功能衰竭等并发症。术后全身系统严重并发症发生率是指术后发生全身系统严重并发症的患者数占同期自体器官移植术患者总数的比例。', '《自体器官移植技术临床应用管理规范（2022 版）》《自体器官移植技术临床应用质量控制指标（2022 版）》。', '反映医疗机构自体器官移植技术水平的重要结果指标之一。',
    '自体器官移植技术数据源', NULL, '分子：是指完成自体器官移植术的患者，在术后发生全身系统严重并发症的患者数，如心脑血管意外、肺栓塞、呼吸衰竭、肾衰竭、深静脉血栓、肝功能衰竭等。 分母：是指同期出院患者中完成自体器官移植术的总例数。', '百分比（%）', '病案首页不良事件报告管理系统。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.12.5"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
