-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.14.10.7（与CSV文件中的编码完全一致）
-- 指标名称：行直接PCI的STEMI患者到院至导丝通过靶血管（DTD）平均时间
-- 创建日期：2026-02-04
-- ===========================================

-- 依赖：请确保数据源"冠心病介入治疗专病表查询"已创建
SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '冠心病介入治疗专病表查询' AND INVALID = 0
    LIMIT 1
);

-- 查询类别ID：根据类别名称"冠心病介入治疗"从数据库查询（使用LIKE模糊匹配）
SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE CATEGORY_NAME LIKE '%冠心病介入治疗%' AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';

-- 创建分子指标（3.14.10.7.1）
SET @numerator_kpi_name = 'STEMI患者行直接PCI的DTD时间总和';
SET @numerator_category_code = '3.14.10.7.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    'STEMI患者行直接PCI的DTD时间总和', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价STEMI救治及时性',
    '冠心病介入治疗专病表查询', NULL, '分子：STEMI患者行直接PCI的DTD时间总和。分母：STEMI患者行直接PCI的总例数。', '无', '无', NULL,
    '出院日期', '出院科室名称', 'DTD时间_分钟', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL
);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建分母指标（3.14.10.7.2）
SET @denominator_kpi_name = 'STEMI患者行直接PCI的总例数';
SET @denominator_category_code = '3.14.10.7.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    'STEMI患者行直接PCI的总例数', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价STEMI救治及时性',
    '冠心病介入治疗专病表查询', NULL, '分子：STEMI患者行直接PCI的DTD时间总和。分母：STEMI患者行直接PCI的总例数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否行直接PCI_STEMI', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL
);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建比率指标（3.14.10.7）
SET @kpi_name = '行直接PCI的STEMI患者到院至导丝通过靶血管（DTD）平均时间';
SET @category_code = '3.14.10.7';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    'STEMI患者行直接PCI的DTD时间总和与STEMI患者行直接PCI的总例数的比值', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价STEMI救治及时性',
    '冠心病介入治疗专病表查询', NULL, '分子：STEMI患者行直接PCI的DTD时间总和。分母：STEMI患者行直接PCI的总例数。', '分钟', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
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
