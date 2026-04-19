-- ===========================================
-- 单病种应上报资源消耗指标注册脚本
-- 指标编码：4.41.2.1（以CSV为准）
-- 指标名称：原发性急性闭角型青光眼（手术治疗）平均住院日
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '单病种应上报资源消耗查询' AND INVALID = 0
    LIMIT 1
);

SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE CATEGORY_NAME LIKE '%青光眼%' AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out","p_disease_code":"PACG"}';

SET @numerator_kpi_name = '原发性急性闭角型青光眼（手术治疗）出院患者占用总床日数';
SET @numerator_category_code = '4.41.2.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, @data_source_id, @data_source_param,
    '原发性急性闭角型青光眼（手术治疗）出院患者占用总床日数', '《河北省三级医院评审标准实施细则（2025年版）》第四章。', '评价病种的时间消耗情况，反映医疗效率',
    '单病种应上报资源消耗查询', NULL, 'full', NULL, NULL, '分子：原发性急性闭角型青光眼（手术治疗）出院患者占用总床日数。分母：同期原发性急性闭角型青光眼（手术治疗）出院总人数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '住院天数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间","住院天数"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

SET @denominator_kpi_name = '同期原发性急性闭角型青光眼（手术治疗）出院总人数';
SET @denominator_category_code = '4.41.2.1.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, @data_source_id, @data_source_param,
    '同期原发性急性闭角型青光眼（手术治疗）出院总人数', '《河北省三级医院评审标准实施细则（2025年版）》第四章。', '评价病种的时间消耗情况，反映医疗效率',
    '单病种应上报资源消耗查询', NULL, 'full', NULL, NULL, '分子：原发性急性闭角型青光眼（手术治疗）出院患者占用总床日数。分母：同期原发性急性闭角型青光眼（手术治疗）出院总人数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '计数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

SET @kpi_name = '原发性急性闭角型青光眼（手术治疗）平均住院日';
SET @category_code = '4.41.2.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'decimal', 2, 'decrease', 'ratio', NULL, @data_source_id, @data_source_param,
    '原发性急性闭角型青光眼（手术治疗）出院患者占用总床日数除以同期原发性急性闭角型青光眼（手术治疗）出院总人数', '《河北省三级医院评审标准实施细则（2025年版）》第四章。', '评价病种的时间消耗情况，反映医疗效率，间接反映综合医疗质量',
    '单病种应上报资源消耗查询', NULL, 'full', NULL, NULL, '分子：原发性急性闭角型青光眼（手术治疗）出院患者占用总床日数。分母：同期原发性急性闭角型青光眼（手术治疗）出院总人数。', '天', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间","住院天数"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
