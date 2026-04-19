-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.14.7.9（与CSV文件中的编码完全一致）
-- 指标名称：主动脉瓣置换术人工瓣有效瓣膜面积指数大于0.85cm2/m2发生率
-- 创建日期：2026-02-04
-- ===========================================

-- 依赖：请确保数据源"主动脉瓣手术专病表查询"已创建
SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '主动脉瓣手术专病表查询' AND INVALID = 0
    LIMIT 1
);

-- 查询类别ID：根据类别名称"主动脉瓣手术"从数据库查询（使用LIKE模糊匹配）
SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE CATEGORY_NAME LIKE '%主动脉瓣手术%' AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';

-- 创建分子指标（3.14.7.9.1）
SET @numerator_kpi_name = '主动脉瓣置换术中人工主动脉瓣有效瓣膜面积指数大于0.85cm2/m2的患者数';
SET @numerator_category_code = '3.14.7.9.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    '主动脉瓣置换术中人工主动脉瓣有效瓣膜面积指数大于0.85cm2/m2的患者数', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价人工瓣膜大小选择的规范性',
    '主动脉瓣手术专病表查询', NULL, '分子：主动脉瓣置换术中人工主动脉瓣有效瓣膜面积指数大于0.85cm2/m2的患者数。主动脉瓣有效瓣膜面积指数=人工瓣膜有效瓣口面积（cm2）/患者体表面积（m2）。分母：同期行主动脉瓣置换术的患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否人工瓣有效瓣膜面积指数大于0.85cm2m2', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL
);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建分母指标（3.14.7.9.2）
SET @denominator_kpi_name = '同期行主动脉瓣置换术的患者总数';
SET @denominator_category_code = '3.14.7.9.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    '行主动脉瓣置换术的患者总数', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价人工瓣膜大小选择的规范性',
    '主动脉瓣手术专病表查询', NULL, '分子：主动脉瓣置换术中人工主动脉瓣有效瓣膜面积指数大于0.85cm2/m2的患者数。主动脉瓣有效瓣膜面积指数=人工瓣膜有效瓣口面积（cm2）/患者体表面积（m2）。分母：同期行主动脉瓣置换术的患者总数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期行主动脉瓣置换术的患者', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL
);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建比率指标（3.14.7.9）
SET @kpi_name = '主动脉瓣置换术人工瓣有效瓣膜面积指数大于0.85cm2/m2发生率';
SET @category_code = '3.14.7.9';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '主动脉瓣置换术中人工主动脉瓣有效瓣膜面积指数大于0.85cm2/m2的患者数，占同期行主动脉瓣置换术的患者总数的比例', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价人工瓣膜大小选择的规范性',
    '主动脉瓣手术专病表查询', NULL, '分子：主动脉瓣置换术中人工主动脉瓣有效瓣膜面积指数大于0.85cm2/m2的患者数。主动脉瓣有效瓣膜面积指数=人工瓣膜有效瓣口面积（cm2）/患者体表面积（m2）。分母：同期行主动脉瓣置换术的患者总数。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL
);

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
