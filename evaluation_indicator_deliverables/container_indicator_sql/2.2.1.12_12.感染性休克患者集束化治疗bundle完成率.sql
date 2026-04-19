-- ===========================================
-- 2.2.1.12 感染性休克患者集束化治疗(bundle)完成率（1小时/3小时/6小时）（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- ========== 2.2.1.12.1 感染性休克患者1小时 bundle 完成率 ==========
-- 分子 2.2.1.12.1.1
CALL sp_kpi_item_create(
    '入ICU诊断为感染性休克并完成1小时bundle的患者数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '入ICU诊断为感染性休克并完成1小时bundle的患者数。', '《2.2.1 年度安全目标.csv》', '分子：入ICU诊断为感染性休克并完成1小时bundle的患者数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：入ICU诊断为感染性休克并完成1小时bundle的患者数。分母：同期入ICU诊断为感染性休克患者总数。', '入ICU诊断为感染性休克并完成1小时bundle的患者数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.12.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_1211_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '入ICU诊断为感染性休克并完成1小时bundle的患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.12.1.2
CALL sp_kpi_item_create(
    '同期入ICU诊断为感染性休克患者总数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期入ICU诊断为感染性休克患者总数。', '《2.2.1 年度安全目标.csv》', '分母：同期入ICU诊断为感染性休克患者总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：同期入ICU诊断为感染性休克患者总数。', '同期入ICU诊断为感染性休克患者总数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.12.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_1212_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期入ICU诊断为感染性休克患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.12.1
CALL sp_kpi_item_create(
    '感染性休克患者1小时bundle完成率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '感染性休克患者1小时bundle完成率 = 入ICU诊断为感染性休克并完成1小时bundle的患者数/同期入ICU诊断为感染性休克患者总数×100%。', '《2.2.1 年度安全目标.csv》', '反映感染性休克集束化治疗落实率。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：入ICU诊断为感染性休克并完成1小时bundle的患者数。分母：同期入ICU诊断为感染性休克患者总数。', '感染性休克患者1小时bundle完成率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_1211_id, @den_1212_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.12.1"}]'), NULL, NULL, NULL, NULL
);

-- ========== 2.2.1.12.2 感染性休克患者3小时 bundle 完成率 ==========
-- 分子 2.2.1.12.2.1
CALL sp_kpi_item_create(
    '入ICU诊断为感染性休克并完成3小时bundle的患者数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '入ICU诊断为感染性休克并完成3小时bundle的患者数。', '《2.2.1 年度安全目标.csv》', '分子：入ICU诊断为感染性休克并完成3小时bundle的患者数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：入ICU诊断为感染性休克并完成3小时bundle的患者数。分母：同期入ICU诊断为感染性休克患者总数。', '入ICU诊断为感染性休克并完成3小时bundle的患者数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.12.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_1221_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '入ICU诊断为感染性休克并完成3小时bundle的患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.12.2.2 与 12.1.2 同概念，新建一条
CALL sp_kpi_item_create(
    '同期入ICU诊断为感染性休克患者总数_3小时', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期入ICU诊断为感染性休克患者总数（用于3小时bundle率分母）。', '《2.2.1 年度安全目标.csv》', '分母：同期入ICU诊断为感染性休克患者总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：同期入ICU诊断为感染性休克患者总数。', '同期入ICU诊断为感染性休克患者总数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.12.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_1222_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期入ICU诊断为感染性休克患者总数_3小时' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.12.2
CALL sp_kpi_item_create(
    '感染性休克患者3小时bundle完成率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '感染性休克患者3小时bundle完成率 = 入ICU诊断为感染性休克并完成3小时bundle的患者数/同期入ICU诊断为感染性休克患者总数×100%。', '《2.2.1 年度安全目标.csv》', '反映感染性休克集束化治疗落实率。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：入ICU诊断为感染性休克并完成3小时bundle的患者数。分母：同期入ICU诊断为感染性休克患者总数。', '感染性休克患者3小时bundle完成率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_1221_id, @den_1222_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.12.2"}]'), NULL, NULL, NULL, NULL
);

-- ========== 2.2.1.12.3 感染性休克患者6小时 bundle 完成率 ==========
-- 分子 2.2.1.12.3.1
CALL sp_kpi_item_create(
    '入ICU诊断为感染性休克并完成6小时bundle的患者数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '入ICU诊断为感染性休克并完成6小时bundle的患者数。', '《2.2.1 年度安全目标.csv》', '分子：入ICU诊断为感染性休克并完成6小时bundle的患者数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：入ICU诊断为感染性休克并完成6小时bundle的患者数。分母：同期入ICU诊断为感染性休克患者总数。', '入ICU诊断为感染性休克并完成6小时bundle的患者数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.12.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_1231_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '入ICU诊断为感染性休克并完成6小时bundle的患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.12.3.2
CALL sp_kpi_item_create(
    '同期入ICU诊断为感染性休克患者总数_6小时', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期入ICU诊断为感染性休克患者总数（用于6小时bundle率分母）。', '《2.2.1 年度安全目标.csv》', '分母：同期入ICU诊断为感染性休克患者总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：同期入ICU诊断为感染性休克患者总数。', '同期入ICU诊断为感染性休克患者总数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.12.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_1232_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期入ICU诊断为感染性休克患者总数_6小时' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.12.3
CALL sp_kpi_item_create(
    '感染性休克患者6小时bundle完成率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '感染性休克患者6小时bundle完成率 = 入ICU诊断为感染性休克并完成6小时bundle的患者数/同期入ICU诊断为感染性休克患者总数×100%。', '《2.2.1 年度安全目标.csv》', '反映感染性休克集束化治疗落实率。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：入ICU诊断为感染性休克并完成6小时bundle的患者数。分母：同期入ICU诊断为感染性休克患者总数。', '感染性休克患者6小时bundle完成率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_1231_id, @den_1232_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.12.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME LIKE '感染性休克患者%bundle完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 3;
