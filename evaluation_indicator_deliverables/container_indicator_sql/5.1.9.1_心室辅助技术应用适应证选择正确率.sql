-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.9.1
-- 指标名称：心室辅助技术应用适应证选择正确率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '心室辅助技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '心室辅助技术应用适应证选择正确的例数';
SET @numerator_category_code = '5.1.9.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '心室辅助技术应用适应证选择正确的例数占同期心室辅助装置应用总例数的比例。', '《心室辅助技术临床应用管理规范（2022 版）》《心室辅助技术临床应用质量控制指标（2022 版）》。', '体现医院开展心室辅助技术时严格掌握适应证的程度，是反映医院心室辅助技术医疗质量的重要过程性指标之一。',
    '心室辅助技术数据源', NULL, '分子：是指经过心室辅助技术应用适应证评估后，符合条件并完成心室辅助装置应用的例数。 分母：是指同期完成心室辅助装置应用的总例数。 心室辅助技术应用适应证为心脏功能衰竭 D 期（难治性终末期心衰），应当符合下列 12 项标准中任意 5 项：心排指数＜2.0L/m2 ；最大氧耗量< 14ml/kg ·min；6 分钟步行试验＜150m；NT-proBNP＞5000ng/ml；经心衰预后模型评估预计生存期小于 1 年；经 6 个月正规抗心衰药物治疗无效；肺毛细血管楔压＞18mmHg；大剂量（>15ug/kg.min）或者两种以上静脉心血管活性药物下循环功能难以维持；⑨混合静脉血氧饱和度＜65%；需要依靠 IABP 或者 ECMO 等临时心室辅助下维持循环；近 6 个月内因心脏衰竭急性发作住院超过 2 次。其他治疗手段无法延续生命，或是生活质量存在严重障碍的患者，通过参加治疗能提高生活质量，能够进行长期居家治疗。', '百分比（%）', '病历资料。', NULL,
    '出院日期', '出院科室名称', '是否完成心室辅助技术应用适应证选择正确', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.9.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期心室辅助装置应用总例数';
SET @denominator_category_code = '5.1.9.1.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '心室辅助技术应用适应证选择正确的例数占同期心室辅助装置应用总例数的比例。', '《心室辅助技术临床应用管理规范（2022 版）》《心室辅助技术临床应用质量控制指标（2022 版）》。', '体现医院开展心室辅助技术时严格掌握适应证的程度，是反映医院心室辅助技术医疗质量的重要过程性指标之一。',
    '心室辅助技术数据源', NULL, '分子：是指经过心室辅助技术应用适应证评估后，符合条件并完成心室辅助装置应用的例数。 分母：是指同期完成心室辅助装置应用的总例数。 心室辅助技术应用适应证为心脏功能衰竭 D 期（难治性终末期心衰），应当符合下列 12 项标准中任意 5 项：心排指数＜2.0L/m2 ；最大氧耗量< 14ml/kg ·min；6 分钟步行试验＜150m；NT-proBNP＞5000ng/ml；经心衰预后模型评估预计生存期小于 1 年；经 6 个月正规抗心衰药物治疗无效；肺毛细血管楔压＞18mmHg；大剂量（>15ug/kg.min）或者两种以上静脉心血管活性药物下循环功能难以维持；⑨混合静脉血氧饱和度＜65%；需要依靠 IABP 或者 ECMO 等临时心室辅助下维持循环；近 6 个月内因心脏衰竭急性发作住院超过 2 次。其他治疗手段无法延续生命，或是生活质量存在严重障碍的患者，通过参加治疗能提高生活质量，能够进行长期居家治疗。', '百分比（%）', '病历资料。', NULL,
    '出院日期', '出院科室名称', '是否完成心室辅助技术应用适应证选择正确', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.9.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '心室辅助技术应用适应证选择正确率';
SET @category_code = '5.1.9.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '心室辅助技术应用适应证选择正确的例数占同期心室辅助装置应用总例数的比例。', '《心室辅助技术临床应用管理规范（2022 版）》《心室辅助技术临床应用质量控制指标（2022 版）》。', '体现医院开展心室辅助技术时严格掌握适应证的程度，是反映医院心室辅助技术医疗质量的重要过程性指标之一。',
    '心室辅助技术数据源', NULL, '分子：是指经过心室辅助技术应用适应证评估后，符合条件并完成心室辅助装置应用的例数。 分母：是指同期完成心室辅助装置应用的总例数。 心室辅助技术应用适应证为心脏功能衰竭 D 期（难治性终末期心衰），应当符合下列 12 项标准中任意 5 项：心排指数＜2.0L/m2 ；最大氧耗量< 14ml/kg ·min；6 分钟步行试验＜150m；NT-proBNP＞5000ng/ml；经心衰预后模型评估预计生存期小于 1 年；经 6 个月正规抗心衰药物治疗无效；肺毛细血管楔压＞18mmHg；大剂量（>15ug/kg.min）或者两种以上静脉心血管活性药物下循环功能难以维持；⑨混合静脉血氧饱和度＜65%；需要依靠 IABP 或者 ECMO 等临时心室辅助下维持循环；近 6 个月内因心脏衰竭急性发作住院超过 2 次。其他治疗手段无法延续生命，或是生活质量存在严重障碍的患者，通过参加治疗能提高生活质量，能够进行长期居家治疗。', '百分比（%）', '病历资料。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.9.1"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
