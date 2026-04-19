-- 医疗安全指标 2.3.28 注册脚本（分子+分母+比率）
-- 指标编码：2.3.28 / 2.3.28.1 / 2.3.28.2
-- 指标名称：（二十八）ICU呼吸机相关性肺炎（VAP）发生率
-- 创建日期：2026-02

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '医疗安全指标明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗安全%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out","p_indicator_code":"2.3.28"}';

SET @numerator_kpi_name = 'ICU呼吸机相关性肺炎发生例数';
SET @numerator_category_code = '2.3.28.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    'ICU呼吸机相关性肺炎发生例数', '《2.3 医疗安全指标列表.csv》。', '反映医院围手术期/医疗安全管理质量',
    '医疗安全指标明细查询', NULL, 'full', NULL, '无',
    '分子：ICU呼吸机相关性肺炎发生例数；分母：同期ICU患者有创机械通气总天数。',
    'ICU呼吸机相关性肺炎发生例数', '无', NULL, '无',
    '出院日期', '出院科室名称', '是否发生该并发症', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期ICU患者有创机械通气总天数';
SET @denominator_category_code = '2.3.28.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '同期ICU患者有创机械通气总天数', '《2.3 医疗安全指标列表.csv》。', '反映医院围手术期/医疗安全管理质量',
    '医疗安全指标明细查询', NULL, 'full', NULL, '无',
    '分母：同期ICU患者有创机械通气总天数。',
    '同期ICU患者有创机械通气总天数', '无', NULL, '无',
    '出院日期', '出院科室名称', '分母值', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '（二十八）ICU呼吸机相关性肺炎（VAP）发生率';
SET @category_code = '2.3.28';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'decimal', 4, 'decrease', 'ratio', @data_source_id, @data_source_param,
    'ICU呼吸机相关性肺炎（VAP）发生率是指ICU呼吸机相关性肺炎发生例数占同期ICU患者有创机械通气总天数的比例。', '《2.3 医疗安全指标列表.csv》。', '反映医院围手术期/医疗安全管理质量',
    '医疗安全指标明细查询', NULL, 'full', NULL, '无',
    '分子：ICU呼吸机相关性肺炎发生例数；分母：同期ICU患者有创机械通气总天数。',
    '（二十八）ICU呼吸机相关性肺炎（VAP）发生率', '例/千机械通气日', NULL, '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型 FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
