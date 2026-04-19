-- ===========================================
-- 2.2.1.3 肿瘤治疗前临床TNM分期评估率（手工填报，分子+分母+比率）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.1.3.1
CALL sp_kpi_item_create(
    '住院肿瘤患者治疗前完成临床TNM分期评估例数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '住院肿瘤患者治疗前完成临床TNM分期评估例数。', '《2.2.1 年度安全目标.csv》', '分子：指住院肿瘤患者进行临床TNM分期评估病例总数。周期性化疗患者按1人次计算。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院肿瘤患者进行临床TNM分期评估病例总数。周期性化疗患者按1人次计算。分母：指同期住院肿瘤患者病例总数（周期性化疗患者按1人计算）。', '住院肿瘤患者治疗前完成临床TNM分期评估例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院肿瘤患者治疗前完成临床TNM分期评估例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.3.2
CALL sp_kpi_item_create(
    '同期住院肿瘤患者人次', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期住院肿瘤患者人次。', '《2.2.1 年度安全目标.csv》', '分母：指同期住院肿瘤患者病例总数（周期性化疗患者按1人计算）。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期住院肿瘤患者病例总数（周期性化疗患者按1人计算）。', '同期住院肿瘤患者人次', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院肿瘤患者人次' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.3
CALL sp_kpi_item_create(
    '3.肿瘤治疗前临床TNM分期评估率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '肿瘤治疗前临床TNM分期评估率是指肿瘤治疗前开展临床TNM分期评估病例数占同期住院肿瘤患者人次的比例（重点关注肺癌、胃癌、肝癌、结直肠癌、乳腺癌5个病种）。', '《2.2.1 年度安全目标.csv》', '反映肿瘤治疗前临床分期规范性。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院肿瘤患者进行临床TNM分期评估病例总数。周期性化疗患者按1人次计算。分母：指同期住院肿瘤患者病例总数（周期性化疗患者按1人计算）。', '肿瘤治疗前临床TNM分期评估率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '3.肿瘤治疗前临床TNM分期评估率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
