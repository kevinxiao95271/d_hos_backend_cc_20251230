-- ===========================================
-- 2.2.10.18 实际手术术者与计划手术术者一致率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '实际开展手术术者与计划手术术者一致的手术例数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '实际开展手术术者与计划手术术者一致的手术例数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '反映手术管理的规范性。', '实际开展手术术者与计划手术术者一致的手术例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.18.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实际开展手术术者与计划手术术者一致的手术例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期手术总例数_术者一致分母', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期手术总例数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期手术总例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.18.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期手术总例数_术者一致分母' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '实际手术术者与计划手术术者一致率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '实际开展手术术者与计划手术术者一致的手术例数占同期手术总例数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映手术管理的规范性。',
    NULL, NULL, 'full', NULL, '无',
    '反映手术管理的规范性。', '实际手术术者与计划手术术者一致率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.18"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '实际手术术者与计划手术术者一致率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
