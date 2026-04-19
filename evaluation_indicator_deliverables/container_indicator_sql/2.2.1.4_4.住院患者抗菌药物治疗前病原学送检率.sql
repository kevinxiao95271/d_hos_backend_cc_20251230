-- ===========================================
-- 2.2.1.4 住院患者抗菌药物治疗前病原学送检率（手工填报，分子+分母+比率）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.1.4.1
CALL sp_kpi_item_create(
    '用抗菌药物前病原学检验标本送检病例数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '用抗菌药物前病原学检验标本送检病例数。', '《2.2.1 年度安全目标.csv》', '分子：指住院患者使用抗菌药物前进行病原学检验标本送检的病例总数。检验项目包括：细菌培养、真菌培养；降钙素原检测、白介素-6检测、真菌1-3-β-D葡聚糖检测（G试验）等。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院患者使用抗菌药物前进行病原学检验标本送检的病例总数。分母：指同期住院患者使用抗菌药物治疗病例的总数。', '用抗菌药物前病原学检验标本送检病例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '用抗菌药物前病原学检验标本送检病例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.4.2
CALL sp_kpi_item_create(
    '同期使用抗菌药物治疗病例总数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期使用抗菌药物治疗病例总数。', '《2.2.1 年度安全目标.csv》', '分母：指同期住院患者使用抗菌药物治疗病例的总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期住院患者使用抗菌药物治疗病例的总数。', '同期使用抗菌药物治疗病例总数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期使用抗菌药物治疗病例总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.4
CALL sp_kpi_item_create(
    '4.住院患者抗菌药物治疗前病原学送检率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '住院患者抗菌药物治疗前病原学送检率是指住院患者使用抗菌药物治疗前病原学检验标本送检病例数占同期使用抗菌药物治疗病例总数的比例。', '《2.2.1 年度安全目标.csv》', '提高抗菌药物治疗前病原学送检率，提升无菌性样本送检比例，可提高抗菌药物使用的科学性和规范性，对遏制细菌耐药、提升治疗效果具有重要意义。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院患者使用抗菌药物前进行病原学检验标本送检的病例总数。检验项目包括：细菌培养、真菌培养；降钙素原检测、白介素-6检测、真菌1-3-β-D葡聚糖检测（G试验）等。分母：指同期住院患者使用抗菌药物治疗病例的总数。', '住院患者抗菌药物治疗前病原学送检率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '4.住院患者抗菌药物治疗前病原学送检率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
