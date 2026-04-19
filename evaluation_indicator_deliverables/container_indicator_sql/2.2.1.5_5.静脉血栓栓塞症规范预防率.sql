-- ===========================================
-- 2.2.1.5 静脉血栓栓塞症规范预防率（VTE风险评估率 + 采取VTE恰当预防措施比率）（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- ========== 2.2.1.5.1 VTE风险评估率 ==========
-- 分子 2.2.1.5.1.1
CALL sp_kpi_item_create(
    '接受VTE风险评估的出院患者人次', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '接受VTE风险评估的出院患者人次。', '《2.2.1 年度安全目标.csv》', '分子：指出院患者中接受VTE风险评估的人次总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指出院患者中接受VTE风险评估的人次总数。分母：指同期出院患者总人次数。', '接受VTE风险评估的出院患者人次', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.5.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_511_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '接受VTE风险评估的出院患者人次' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.5.1.2
CALL sp_kpi_item_create(
    '同期出院患者人次', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期出院患者人次。', '《2.2.1 年度安全目标.csv》', '分母：指同期出院患者总人次数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期出院患者总人次数。', '同期出院患者人次', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.5.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_512_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者人次' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.5.1 VTE风险评估率
CALL sp_kpi_item_create(
    'VTE风险评估率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    'VTE风险评估率是指接受VTE风险评估的出院患者人次与同期出院患者人次的比例。', '《2.2.1 年度安全目标.csv》', '提高VTE规范预防率，实现VTE的早期干预，可有效降低VTE的发生率、致残率及致死率。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指出院患者中接受VTE风险评估的人次总数。分母：指同期出院患者总人次数。采取VTE规范预防措施是指患者住院期间接受VTE风险与出血风险评估，并根据评估情况按照有关临床指南规范给予预防措施（包括药物预防、机械预防等）。', 'VTE风险评估率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_511_id, @den_512_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.5.1"}]'), NULL, NULL, NULL, NULL
);

-- ========== 2.2.1.5.2 采取VTE恰当预防措施比率 ==========
-- 分子 2.2.1.5.2.1
CALL sp_kpi_item_create(
    '采取VTE恰当预防措施的出院患者人次', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '采取VTE恰当预防措施的出院患者人次。', '《2.2.1 年度安全目标.csv》', '分子：指出院患者中采取VTE恰当预防措施的人次总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指出院患者中采取VTE恰当预防措施的人次总数。分母：指出院患者中VTE风险评估为高危和/或中危的人次总数。', '采取VTE恰当预防措施的出院患者人次', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.5.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_521_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '采取VTE恰当预防措施的出院患者人次' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.5.2.2
CALL sp_kpi_item_create(
    'VTE风险评估为高危和/或中危的出院患者人次', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    'VTE风险评估为高危和/或中危的出院患者人次。', '《2.2.1 年度安全目标.csv》', '分母：指出院患者中VTE风险评估为高危和/或中危的人次总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指出院患者中VTE风险评估为高危和/或中危的人次总数。', 'VTE风险评估为高危和/或中危的出院患者人次', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.5.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_522_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'VTE风险评估为高危和/或中危的出院患者人次' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.5.2 采取VTE恰当预防措施比率
CALL sp_kpi_item_create(
    '采取VTE恰当预防措施比率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '采取VTE恰当预防措施比率是指实施VTE规范预防措施的出院患者人次与同期VTE风险评估为高危和/或中危出院患者人次的比例。', '《2.2.1 年度安全目标.csv》', '提高VTE规范预防率，实现VTE的早期干预，可有效降低VTE的发生率、致残率及致死率。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指出院患者中采取VTE恰当预防措施的人次总数。分母：指出院患者中VTE风险评估为高危和/或中危的人次总数。采取VTE规范预防措施是指患者住院期间接受VTE风险与出血风险评估，并根据评估情况按照有关临床指南规范给予预防措施（包括药物预防、机械预防等）。', '采取VTE恰当预防措施比率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_521_id, @den_522_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.5.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME IN ('VTE风险评估率','采取VTE恰当预防措施比率') AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 2;
