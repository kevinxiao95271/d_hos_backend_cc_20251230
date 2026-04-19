-- ===========================================
-- 单病种应上报资源消耗指标注册脚本
-- 指标编码：4.14.2.2（以CSV为准）
-- 指标名称：垂体腺瘤（初发，手术治疗）次均费用
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '单病种应上报资源消耗查询' AND INVALID = 0
    LIMIT 1
);

SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE CATEGORY_NAME LIKE '%垂体腺瘤%' AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out","p_disease_code":"PITUITARY"}';

SET @numerator_kpi_name = '垂体腺瘤（初发，手术治疗）患者住院费用之和';
SET @numerator_category_code = '4.14.2.2.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param,
    '所有垂体腺瘤（初发，手术治疗）患者住院费用之和', '《河北省三级医院评审标准实施细则（2025年版）》第四章。', '评价病种的费用消耗情况，反映病种医疗成本控制',
    '单病种应上报资源消耗查询', NULL, 'full', NULL, NULL, '分子：所有垂体腺瘤（初发，手术治疗）患者住院费用之和。分母：同期垂体腺瘤（初发，手术治疗）出院总人数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '住院总费用', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间","住院总费用"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

SET @denominator_kpi_name = '同期垂体腺瘤（初发，手术治疗）出院总人数_次均费用';
SET @denominator_category_code = '4.14.2.2.2';
SET @source_kpi_id = (
    SELECT k.ID FROM KPI_ITEM k
    INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.14.1.1.2'
    WHERE k.INVALID = 0 LIMIT 1
);

CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, IF(@source_kpi_id IS NOT NULL, NULL, @data_source_id),
    IF(@source_kpi_id IS NOT NULL, NULL, @data_source_param),
    '同期垂体腺瘤（初发，手术治疗）出院总人数', '《河北省三级医院评审标准实施细则（2025年版）》第四章。', '评价病种的费用消耗情况，反映病种医疗成本控制',
    IF(@source_kpi_id IS NOT NULL, '与指标编码4.14.1.1.2（同期行垂体腺瘤手术的患者总数）同源，采集源于该指标', '单病种应上报资源消耗查询'), NULL, 'full', NULL, NULL, '分子：所有垂体腺瘤（初发，手术治疗）患者住院费用之和。分母：同期垂体腺瘤（初发，手术治疗）出院总人数。（与4.14.1.1.2一致）', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', IF(@source_kpi_id IS NOT NULL, '同期行垂体腺瘤手术的患者总数', '计数'), NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, IF(@source_kpi_id IS NOT NULL, 'datasource', NULL), NULL, @source_kpi_id, NULL, 1
);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

UPDATE KPI_ITEM SET SOURCE_KPI_ID = @source_kpi_id WHERE ID = @denominator_kpi_id AND @source_kpi_id IS NOT NULL;

SET @kpi_name = '垂体腺瘤（初发，手术治疗）次均费用';
SET @category_code = '4.14.2.2';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param,
    '所有垂体腺瘤（初发，手术治疗）患者住院费用之和除以同期垂体腺瘤（初发，手术治疗）出院总人数', '《河北省三级医院评审标准实施细则（2025年版）》第四章。', '评价病种的费用消耗情况，反映病种医疗成本控制，间接反映医疗质量',
    '单病种应上报资源消耗查询', NULL, 'full', NULL, NULL, '分子：所有垂体腺瘤（初发，手术治疗）患者住院费用之和。分母：同期垂体腺瘤（初发，手术治疗）出院总人数。', '元', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间","住院总费用"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
