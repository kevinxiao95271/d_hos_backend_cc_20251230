-- ===========================================
-- 专病表接口指标注册脚本
-- 指标编码：3.14.10.2（与CSV文件中的编码完全一致）
-- 指标名称：冠脉介入治疗临床成功率
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

-- 创建分子指标（3.14.10.2.1）
SET @numerator_kpi_name = '冠脉介入治疗临床成功的例数';
SET @numerator_category_code = '3.14.10.2.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '冠脉介入治疗临床成功的例数', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价手术诊疗质量情况',
    '冠心病介入治疗专病表查询', NULL, '分子：冠脉介入治疗临床成功的例数。冠脉介入治疗临床成功是指符合术后即刻冠状动脉造影成功标准，且24小时内无死亡。分母：同期接受冠脉介入治疗的总例数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否冠脉介入治疗临床成功', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL
);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建分母指标（3.14.10.2.2）
SET @denominator_kpi_name = '同期接受冠脉介入治疗的总例数';
SET @denominator_category_code = '3.14.10.2.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期接受冠脉介入治疗的总例数', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价手术诊疗质量情况',
    '冠心病介入治疗专病表查询', NULL, '分子：冠脉介入治疗临床成功的例数。冠脉介入治疗临床成功是指符合术后即刻冠状动脉造影成功标准，且24小时内无死亡。分母：同期接受冠脉介入治疗的总例数。', '无', '无', NULL,
    '出院日期', '出院科室名称', '是否同期接受冠脉介入治疗', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL
);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 创建比率指标（3.14.10.2）
SET @kpi_name = '冠脉介入治疗临床成功率';
SET @category_code = '3.14.10.2';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '冠脉介入治疗临床成功的例数，占同期接受冠脉介入治疗的总例数的比例', '《心血管系统疾病相关专业医疗质量控制指标（2021年版）》。', '评价手术诊疗质量情况',
    '冠心病介入治疗专病表查询', NULL, '分子：冠脉介入治疗临床成功的例数。冠脉介入治疗临床成功是指符合术后即刻冠状动脉造影成功标准，且24小时内无死亡。分母：同期接受冠脉介入治疗的总例数。', '百分比（%）', '无', NULL,
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
