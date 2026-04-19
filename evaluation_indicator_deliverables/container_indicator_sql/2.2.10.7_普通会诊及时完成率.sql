-- ===========================================
-- 2.2.10.7 普通会诊及时完成率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '普通会诊24小时内完成次数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '普通会诊24小时内完成次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '病历中会诊医师电子签章时间即为会诊完成时间。', '普通会诊24小时内完成次数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.7.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '普通会诊24小时内完成次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期普通会诊总次数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期普通会诊总次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期普通会诊总次数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.7.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期普通会诊总次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '普通会诊及时完成率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '普通会诊24小时内完成次数占同期普通会诊总次数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映普通会诊制度执行的规范性。',
    NULL, NULL, 'full', NULL, '无',
    '病历中会诊医师电子签章时间即为会诊完成时间。', '普通会诊及时完成率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.7"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '普通会诊及时完成率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
