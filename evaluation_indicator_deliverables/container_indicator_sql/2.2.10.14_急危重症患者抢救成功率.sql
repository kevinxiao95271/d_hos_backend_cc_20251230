-- ===========================================
-- 2.2.10.14 急危重症患者抢救成功率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '急危重症患者抢救成功的例次数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '急危重症患者抢救成功的例次数（存活超过24小时或存活至下一次抢救开始）。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '抢救成功指急危重患者经抢救后存活超过24小时或存活至下一次抢救开始。', '急危重症患者抢救成功的例次数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.14.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '急危重症患者抢救成功的例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期急危重症患者抢救的总例次数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期急危重症患者抢救的总例次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期急危重症患者抢救的总例次数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.14.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期急危重症患者抢救的总例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '急危重症患者抢救成功率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '急危重症患者抢救成功的例次数占同期急危重症患者抢救的总例次数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映急危重症患者救治质量。',
    NULL, NULL, 'full', NULL, '无',
    '抢救成功指急危重患者经抢救后存活超过24小时或存活至下一次抢救开始。', '急危重症患者抢救成功率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.14"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '急危重症患者抢救成功率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
