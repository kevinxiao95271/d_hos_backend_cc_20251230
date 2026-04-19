-- ===========================================
-- 2.2.7 （七）ICD低风险病种患者住院死亡率（填报型）
-- 2.2.8 （八）DRGs低风险组患者住院死亡率（填报型）
-- 无数据源，分子/分母手工填报，比率由系统计算；后续可接数据源改为计算型
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%住院质量与安全指标%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- ========== 2.2.7 ==========
-- 分子 2.2.7.1：ICD低风险病种患者死亡人数
CALL sp_kpi_item_create(
    'ICD低风险病种患者死亡人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    'ICD低风险病种出院患者死亡人数之和。', '《三级综合医院评审标准（2022年版）》', 'ICD低风险病种患者住院死亡率反映医疗质量。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指ICD低风险病种出院患者死亡人数之和。分母：指ICD低风险病种出院人数之和。ICD低风险病种是指第一诊断ICD-10（2019 v2.0）在《三级综合医院评审标准（2022年版）》中所列的115个低风险病种。', 'ICD低风险病种患者死亡人数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.7.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_27_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'ICD低风险病种患者死亡人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.7.2：ICD低风险病种出院患者总数
CALL sp_kpi_item_create(
    'ICD低风险病种出院患者总数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    'ICD低风险病种出院人数之和。', '《三级综合医院评审标准（2022年版）》', 'ICD低风险病种患者住院死亡率反映医疗质量。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指ICD低风险病种出院患者死亡人数之和。分母：指ICD低风险病种出院人数之和。', 'ICD低风险病种出院患者总数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.7.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_27_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'ICD低风险病种出院患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.7
CALL sp_kpi_item_create(
    '（七）ICD低风险病种患者住院死亡率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', NULL, NULL,
    'ICD低风险病种患者住院死亡率是指ICD低风险病种患者住院死亡例数占ICD低风险病种出院患者总数的比例。', '《三级综合医院评审标准（2022年版）》', '通过低风险病种死亡率衡量医疗质量与安全。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指ICD低风险病种出院患者死亡人数之和。分母：指ICD低风险病种出院人数之和。ICD低风险病种是指第一诊断ICD-10（2019 v2.0）在《三级综合医院评审标准（2022年版）》中所列的115个低风险病种。', '（七）ICD低风险病种患者住院死亡率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_27_id, @denominator_27_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.7"}]'), NULL, NULL, NULL, NULL
);

-- ========== 2.2.8 ==========
-- 分子 2.2.8.1：DRG低风险组死亡例数
CALL sp_kpi_item_create(
    'DRG低风险组死亡例数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    'DRG低风险组出院患者死亡人数之和。', '《国家三级公立医院绩效监测操作手册（2025版）》及全国医院质量监测系统（HQMS）。', '通过低风险组病例死亡率衡量医院对住院患者所提供服务的安全和质量。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指DRG低风险组出院患者死亡人数之和。分母：指DRG低风险组出院人数之和。低风险组病例：该组患者的死亡率低于负一倍标准差。', 'DRG低风险组死亡例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_28_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'DRG低风险组死亡例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.8.2：DRG低风险组病例数
CALL sp_kpi_item_create(
    'DRG低风险组病例数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    'DRG低风险组出院人数之和。', '《国家三级公立医院绩效监测操作手册（2025版）》及全国医院质量监测系统（HQMS）。', '通过低风险组病例死亡率衡量医院对住院患者所提供服务的安全和质量。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指DRG低风险组出院患者死亡人数之和。分母：指DRG低风险组出院人数之和。', 'DRG低风险组病例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_28_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'DRG低风险组病例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.8
CALL sp_kpi_item_create(
    '（八）DRGs低风险组患者住院死亡率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', NULL, NULL,
    'DRGs低风险组患者住院死亡率是指运用DRGs分组器测算产生低风险组死亡的患者数占低风险组全部患者数量的比例。', '《国家三级公立医院绩效监测操作手册（2025版）》及全国医院质量监测系统（HQMS）。', '通过低风险组病例死亡率衡量医院对住院患者所提供服务的安全和质量，也间接反映医院的救治能力和临床诊疗过程管理水平。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指DRG低风险组出院患者死亡人数之和。分母：指DRG低风险组出院人数之和。利用各DRGs组病例的住院患者病死率对不同DRG组进行死亡风险分级。', '（八）DRGs低风险组患者住院死亡率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_28_id, @denominator_28_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID, KPI_NAME, KPI_TYPE FROM KPI_ITEM WHERE KPI_NAME IN ('（七）ICD低风险病种患者住院死亡率','（八）DRGs低风险组患者住院死亡率') AND INVALID = 0 ORDER BY KPI_NAME, CREATE_TIME DESC;
