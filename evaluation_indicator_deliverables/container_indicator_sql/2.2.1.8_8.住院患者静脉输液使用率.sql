-- ===========================================
-- 2.2.1.8 住院患者静脉输液使用率 + 静脉输液平均每床日使用袋（瓶）数（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- ========== 2.2.1.8.1 住院患者静脉输液使用率 ==========
-- 分子 2.2.1.8.1.1
CALL sp_kpi_item_create(
    '使用静脉输液的住院患者数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, NULL,
    '使用静脉输液的住院患者数。', '《2.2.1 年度安全目标.csv》', '分子：指住院患者使用静脉输液的总例数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院患者使用静脉输液的总例数。分母：指同期出院患者总例数。', '使用静脉输液的住院患者数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.8.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_811_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '使用静脉输液的住院患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.8.1.2
CALL sp_kpi_item_create(
    '同期出院患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, NULL,
    '同期出院患者总数。', '《2.2.1 年度安全目标.csv》', '分母：指同期出院患者总例数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期出院患者总例数。', '同期出院患者总数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.8.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_812_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.8.1
CALL sp_kpi_item_create(
    '住院患者静脉输液使用率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', NULL, NULL,
    '住院患者静脉输液使用率是指使用静脉输液的住院患者数占同期出院患者总数的比例。', '《2.2.1 年度安全目标.csv》', '逐步降低静脉输液治疗比例对于维护医疗安全和患者权益具有重要意义。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院患者使用静脉输液的总例数。分母：指同期出院患者总例数。', '住院患者静脉输液使用率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_811_id, @den_812_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.8.1"}]'), NULL, NULL, NULL, NULL
);

-- ========== 2.2.1.8.2 住院患者静脉输液平均每床日使用袋（瓶）数 ==========
-- 分子 2.2.1.8.2.1
CALL sp_kpi_item_create(
    '住院患者静脉输液总袋（瓶）数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, NULL,
    '住院患者静脉输液总袋（瓶）数。', '《2.2.1 年度安全目标.csv》', '分子：住院患者静脉输液总袋（瓶）数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：住院患者静脉输液总袋（瓶）数；分母：同期住院患者实际开放总床日数。', '住院患者静脉输液总袋（瓶）数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.8.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_821_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院患者静脉输液总袋（瓶）数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.8.2.2
CALL sp_kpi_item_create(
    '同期住院患者实际开放总床日数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, NULL,
    '同期住院患者实际开放总床日数。', '《2.2.1 年度安全目标.csv》', '分母：同期住院患者实际开放总床日数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：同期住院患者实际开放总床日数。', '同期住院患者实际开放总床日数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.8.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_822_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者实际开放总床日数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.8.2（CSV 单位写百分比，实际为袋/床日，按 CSV 用 percent 存储展示为比例亦可，此处用 decimal 表示每床日袋数）
CALL sp_kpi_item_create(
    '住院患者静脉输液平均每床日使用袋（瓶）数', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, NULL,
    '延伸指标：住院患者静脉输液平均每床日使用袋（瓶）数 = 住院患者静脉输液总袋（瓶）数/同期住院患者实际开放总床日数。静脉输液包括静脉滴注和静脉推注。', '《2.2.1 年度安全目标.csv》', '更科学、规范、严谨体现医疗机构静脉输液情况。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：住院患者静脉输液总袋（瓶）数；分母：同期住院患者实际开放总床日数。', '住院患者静脉输液平均每床日使用袋（瓶）数', '袋/床日', NULL, '无',
    NULL, NULL, NULL, @num_821_id, @den_822_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.8.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME IN ('住院患者静脉输液使用率','住院患者静脉输液平均每床日使用袋（瓶）数') AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 2;
