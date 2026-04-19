-- ===========================================
-- 0352 专病表指标注册脚本
-- 指标编码：3.52.11.1 ICU患者标化病死指数
-- 数据源：重症医学专病表查询
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '重症医学专病表查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%重症医学%2024%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

SET @numerator_kpi_name = 'ICU患者实际病死率';
SET @numerator_category_code = '3.52.11.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'decimal', 4, 'monitor', 'value', NULL, @data_source_id, '{"p_date_type":"out"}',
    'ICU死亡患者数（包括因不可逆疾病而自动出院的患者）占同期ICU收治患者总数的比例', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映ICU整体诊疗水平',
    '重症医学专病表查询', NULL, 'full', '分子：ICU死亡患者数（包括因不可逆疾病而自动出院的患者）占同期ICU收治患者总数的比例。分母：同期ICU收治患者预计病死率的总和占同期ICU收治患者总数的比例。', '无', '无', NULL, '无', '无', '无',
    '出院日期', '出院科室名称', '是否ICU死亡患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间","离院方式"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @denominator_kpi_name = '同期ICU患者预计病死率数';
SET @denominator_category_code = '3.52.11.1.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'decimal', 4, 'monitor', 'value', NULL, @data_source_id, '{"p_date_type":"out"}',
    '同一统计周期内ICU收治患者预计病死率的总和占同期ICU收治患者总数的比例', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映ICU整体诊疗水平',
    '重症医学专病表查询', NULL, 'full', '分子：ICU死亡患者数占同期ICU收治患者总数的比例。分母：同期ICU收治患者预计病死率的总和占同期ICU收治患者总数的比例。', '无', '无', NULL, '无', '无', '无',
    '出院日期', '出院科室名称', 'ICU收治患者预计死亡病死率', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间","R值"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = 'ICU患者标化病死指数';
SET @category_code = '3.52.11.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, @data_source_id, '{"p_date_type":"out"}',
    'ICU患者实际病死率与同期ICU患者预计病死率的比值', '《重症医学专业医疗质量控制指标（2024年版）》。', '反映ICU整体诊疗水平',
    '重症医学专病表查询', NULL, 'full', 'ICU死亡患者包括因不可逆疾病而自动出院的患者，不包括入院时已脑死亡、因器官捐献而收治ICU的患者。', NULL, NULL, '值', '无', '无', '无',
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间","离院方式","R值"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型 FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
