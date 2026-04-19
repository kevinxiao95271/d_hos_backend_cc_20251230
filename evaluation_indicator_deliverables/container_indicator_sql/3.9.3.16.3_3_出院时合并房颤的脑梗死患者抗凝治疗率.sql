-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.9.3.16.3（与CSV文件中的编码完全一致）
-- 指标名称：（3）出院时合并房颤的脑梗死患者抗凝治疗率
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

-- 创建分子指标（None）
SET @numerator_kpi_name = 'None';
SET @numerator_category_code = 'None';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    'None', '', '',
    '脑梗死专病表查询', NULL, '《中国脑血管病临床管理指南2019》中，“9.1血压管理”，如患者住院期间神经功能稳定，但血压＞140/90mmHg，启动或重新启动降压治疗是安全的，除伴有禁忌证外，长期控制血压是合理的（Ⅱa类推荐，B级证据）。“9.3糖代谢异常管理”，对糖尿病或糖尿病前期患者进行生活方式和（或）药物干预能减少缺血性卒中或TIA事件，推荐糖化血红蛋白值治疗目标为≤7%（Ⅰ类推荐，B级证据）。“8.2.3病因管理”，推荐意见：伴有心房颤动的缺血性卒中或TIA患者，应根据缺血的严重程度和出血转化的风险，选择抗凝时机。建议出现神经功能症状14 d内给予抗凝治疗预防卒中复发，对于出血风险高的患者，应适当延长抗凝时机（Ⅱa类推荐，B级证据）。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建分母指标（None）
SET @denominator_kpi_name = 'None';
SET @denominator_category_code = 'None';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    'None', '', '',
    '脑梗死专病表查询', NULL, '《中国脑血管病临床管理指南2019》中，“9.1血压管理”，如患者住院期间神经功能稳定，但血压＞140/90mmHg，启动或重新启动降压治疗是安全的，除伴有禁忌证外，长期控制血压是合理的（Ⅱa类推荐，B级证据）。“9.3糖代谢异常管理”，对糖尿病或糖尿病前期患者进行生活方式和（或）药物干预能减少缺血性卒中或TIA事件，推荐糖化血红蛋白值治疗目标为≤7%（Ⅰ类推荐，B级证据）。“8.2.3病因管理”，推荐意见：伴有心房颤动的缺血性卒中或TIA患者，应根据缺血的严重程度和出血转化的风险，选择抗凝时机。建议出现神经功能症状14 d内给予抗凝治疗预防卒中复发，对于出血风险高的患者，应适当延长抗凝时机（Ⅱa类推荐，B级证据）。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建比率指标（3.9.3.16.3）
SET @kpi_name = '（3）出院时合并房颤的脑梗死患者抗凝治疗率';
SET @category_code = '3.9.3.16.3';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '单位时间内，出院时给予抗凝药物治疗的合并房颤的脑梗死患者数占同期合并房颤的住院脑梗死患者总数的比例。', '', '',
    '脑梗死专病表查询', NULL, '《中国脑血管病临床管理指南2019》中，“9.1血压管理”，如患者住院期间神经功能稳定，但血压＞140/90mmHg，启动或重新启动降压治疗是安全的，除伴有禁忌证外，长期控制血压是合理的（Ⅱa类推荐，B级证据）。“9.3糖代谢异常管理”，对糖尿病或糖尿病前期患者进行生活方式和（或）药物干预能减少缺血性卒中或TIA事件，推荐糖化血红蛋白值治疗目标为≤7%（Ⅰ类推荐，B级证据）。“8.2.3病因管理”，推荐意见：伴有心房颤动的缺血性卒中或TIA患者，应根据缺血的严重程度和出血转化的风险，选择抗凝时机。建议出现神经功能症状14 d内给予抗凝治疗预防卒中复发，对于出血风险高的患者，应适当延长抗凝时机（Ⅱa类推荐，B级证据）。', '百分比（%）', '无', NULL,
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
