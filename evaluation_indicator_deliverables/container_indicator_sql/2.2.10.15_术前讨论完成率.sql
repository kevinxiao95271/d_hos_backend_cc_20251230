-- ===========================================
-- 2.2.10.15 术前讨论完成率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '完成术前讨论的手术例数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '完成术前讨论的手术例数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '除以抢救生命为目的的急诊手术外，术前讨论完成时间晚于手术医嘱开具时间和手术同意书签署时间的病例视为未完成术前讨论。', '完成术前讨论的手术例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.15.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '完成术前讨论的手术例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期手术总例数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期手术总例数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期手术总例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.15.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期手术总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '术前讨论完成率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '完成术前讨论的手术例数占同期手术总例数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映术前讨论完成情况。',
    NULL, NULL, 'full', NULL, '无',
    '除以抢救生命为目的的急诊手术外，术前讨论完成时间晚于手术医嘱开具时间和手术同意书签署时间的病例视为未完成术前讨论。', '术前讨论完成率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.15"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '术前讨论完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
