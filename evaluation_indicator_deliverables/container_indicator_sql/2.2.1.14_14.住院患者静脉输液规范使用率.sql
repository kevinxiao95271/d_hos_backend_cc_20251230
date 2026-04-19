-- ===========================================
-- 2.2.1.14 住院患者静脉输液规范使用率（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.1.14.1
CALL sp_kpi_item_create(
    '规范使用静脉输液的住院患者数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '规范使用静脉输液的住院患者数。', '《2.2.1 年度安全目标.csv》', '分子：指规范使用静脉输液的住院患者数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指规范使用静脉输液的住院患者数。分母：指同期使用静脉输液的住院患者总数。', '规范使用静脉输液的住院患者数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.14.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '规范使用静脉输液的住院患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.14.2
CALL sp_kpi_item_create(
    '同期使用静脉输液的住院患者总数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期使用静脉输液的住院患者总数。', '《2.2.1 年度安全目标.csv》', '分母：指同期使用静脉输液的住院患者总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期使用静脉输液的住院患者总数。', '同期使用静脉输液的住院患者总数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.14.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期使用静脉输液的住院患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.14
CALL sp_kpi_item_create(
    '14.住院患者静脉输液规范使用率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '住院患者静脉输液规范使用率是指规范使用静脉输液的住院患者数占同期使用静脉输液的住院患者总数的比例。', '《2.2.1 年度安全目标.csv》', '针对住院患者静脉输液使用情况探索质量改进长效机制，从多个维度综合评价，采取综合措施予以干预，以维护医疗安全和患者权益。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指规范使用静脉输液的住院患者数。分母：指同期使用静脉输液的住院患者总数。', '住院患者静脉输液规范使用率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.14"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '14.住院患者静脉输液规范使用率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
