-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.1.3
-- 指标名称：重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '异基因造血干细胞移植技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '异基因造血干细胞移植术后发生重度（Ⅲ-Ⅳ度）急性移植物抗宿主病患者例次数';
SET @numerator_category_code = '5.1.1.3.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    '急性移植物抗宿主病（aGVHD），是指造血干细胞移植术后100天内，由于移植物抗宿主反应而引起的免疫性疾病，主要表现为皮疹、腹泻和黄疸，是异基因造血干细胞移植的主要并发症和主要死亡原因。重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生率，是指异基因造血干细胞移植术后发生重度（Ⅲ-Ⅳ度）急性移植物抗宿主病患者例次数占同期异基因造血干细胞移植患者总例次数的比例。', '', '',
    '异基因造血干细胞移植技术数据源', NULL, '急性移植物抗宿主病（aGVHD），是指造血干细胞移植术后100天内，由于移植物抗宿主反应而引起的免疫性疾病，主要表现为皮疹、腹泻和黄疸，是异基因造血干细胞移植的主要并发症和主要死亡原因。重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生率，是指异基因造血干细胞移植术后发生重度（Ⅲ-Ⅳ度）急性移植物抗宿主病患者例次数占同期异基因造血干细胞移植患者总例次数的比例。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', '是否完成重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.1.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期异基因造血干细胞移植患者总例次数';
SET @denominator_category_code = '5.1.1.3.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, '{"p_date_type":"out"}',
    '急性移植物抗宿主病（aGVHD），是指造血干细胞移植术后100天内，由于移植物抗宿主反应而引起的免疫性疾病，主要表现为皮疹、腹泻和黄疸，是异基因造血干细胞移植的主要并发症和主要死亡原因。重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生率，是指异基因造血干细胞移植术后发生重度（Ⅲ-Ⅳ度）急性移植物抗宿主病患者例次数占同期异基因造血干细胞移植患者总例次数的比例。', '', '',
    '异基因造血干细胞移植技术数据源', NULL, '急性移植物抗宿主病（aGVHD），是指造血干细胞移植术后100天内，由于移植物抗宿主反应而引起的免疫性疾病，主要表现为皮疹、腹泻和黄疸，是异基因造血干细胞移植的主要并发症和主要死亡原因。重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生率，是指异基因造血干细胞移植术后发生重度（Ⅲ-Ⅳ度）急性移植物抗宿主病患者例次数占同期异基因造血干细胞移植患者总例次数的比例。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', '是否完成重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.1.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生率';
SET @category_code = '5.1.1.3';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '急性移植物抗宿主病（aGVHD），是指造血干细胞移植术后100天内，由于移植物抗宿主反应而引起的免疫性疾病，主要表现为皮疹、腹泻和黄疸，是异基因造血干细胞移植的主要并发症和主要死亡原因。重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生率，是指异基因造血干细胞移植术后发生重度（Ⅲ-Ⅳ度）急性移植物抗宿主病患者例次数占同期异基因造血干细胞移植患者总例次数的比例。', '', '',
    '异基因造血干细胞移植技术数据源', NULL, '急性移植物抗宿主病（aGVHD），是指造血干细胞移植术后100天内，由于移植物抗宿主反应而引起的免疫性疾病，主要表现为皮疹、腹泻和黄疸，是异基因造血干细胞移植的主要并发症和主要死亡原因。重度（Ⅲ-Ⅳ度）急性移植物抗宿主病发生率，是指异基因造血干细胞移植术后发生重度（Ⅲ-Ⅳ度）急性移植物抗宿主病患者例次数占同期异基因造血干细胞移植患者总例次数的比例。', '百分比（%）', '无', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.1.3"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
