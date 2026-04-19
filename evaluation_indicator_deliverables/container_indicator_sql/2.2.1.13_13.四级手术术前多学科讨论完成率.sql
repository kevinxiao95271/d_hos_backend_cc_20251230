-- ===========================================
-- 2.2.1.13 四级手术术前多学科讨论完成率（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.1.13.1
CALL sp_kpi_item_create(
    '四级手术术前多学科讨论完成例数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '住院患者进行四级手术术前多学科讨论完成人次。', '《2.2.1 年度安全目标.csv》', '分子：住院患者进行四级手术术前多学科讨论完成人次。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：住院患者进行四级手术术前多学科讨论完成人次。分母：指同期住院四级手术患者总人次。', '四级手术术前多学科讨论完成例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.13.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '四级手术术前多学科讨论完成例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.13.2
CALL sp_kpi_item_create(
    '同期四级手术总例数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期住院四级手术患者总人次。', '《2.2.1 年度安全目标.csv》', '分母：指同期住院四级手术患者总人次。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期住院四级手术患者总人次。', '同期四级手术总例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.13.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期四级手术总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.13
CALL sp_kpi_item_create(
    '13.四级手术术前多学科讨论完成率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '四级手术术前多学科讨论完成率是指住院患者四级手术术前多学科讨论完成人次占同期住院四级手术患者人次的比例。', '《2.2.1 年度安全目标.csv》', '四级手术术前进行多学科讨论有助于汇聚各专业的技术力量，综合评估患者的风险/获益比，制定全面的诊疗计划及手术风险防范处置最佳方案，从而最大程度降低手术风险和并发症发生，保障手术质量和医疗安全。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：住院患者进行四级手术术前多学科讨论完成人次。分母：指同期住院四级手术患者总人次。', '四级手术术前多学科讨论完成率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.13"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '13.四级手术术前多学科讨论完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
