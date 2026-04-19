-- ===========================================
-- 3.3.8 室内质控项目变异系数不合格率（CL-08）
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床检验专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.3.8.1
CALL sp_kpi_item_create(
    '变异系数高于要求的检验项目数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映实验室检验结果的精密度。',
    '手工填报', NULL, 'full', NULL, NULL,
    '变异系数是检验项目检测系统不精密度的表征，代表检测结果的离散程度大小。如有一个变异系数超过规定要求，就判断该项目变异系数不合格。', '无', '无', '无', NULL,
    '标本日期', '检验科', '变异系数高于要求的检验项目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '变异系数高于要求的检验项目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.3.8.2
CALL sp_kpi_item_create(
    '对变异系数有要求的检验项目总数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '无', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映实验室检验结果的精密度。',
    '手工填报', NULL, 'full', NULL, NULL,
    '对室内质控项目变异系数有要求的检验项目总数。', '无', '无', '无', NULL,
    '标本日期', '检验科', '对变异系数有要求的检验项目总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '对变异系数有要求的检验项目总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.3.8
CALL sp_kpi_item_create(
    '室内质控项目变异系数不合格率（CL-08）', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, @data_source_param,
    '室内质控项目变异系数高于要求的检验项目数占同期对室内质控项目变异系数有要求的检验项目总数的比例。', '《临床检验专业医疗质量控制指标（2025 年版）》，本节下同。', '反映实验室检验结果的精密度。',
    '手工填报', NULL, 'full', NULL, NULL,
    '变异系数是检验项目检测系统不精密度的表征，计算公式为标准差除以测量均值。', '无', '无', '无', NULL,
    '标本日期', '检验科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["检验科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '室内质控项目变异系数不合格率（CL-08）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
