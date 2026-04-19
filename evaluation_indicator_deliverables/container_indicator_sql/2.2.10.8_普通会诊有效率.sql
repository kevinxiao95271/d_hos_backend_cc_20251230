-- ===========================================
-- 2.2.10.8 普通会诊有效率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '普通会诊结束后开具相关医嘱的次数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '普通会诊结束后开具相关医嘱的次数（申请普通会诊后24小时内）。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '本指标中普通会诊结束后开具相关医嘱情况统计方法为在申请普通会诊后24小时内开具相关医嘱。', '普通会诊结束后开具相关医嘱的次数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '普通会诊结束后开具相关医嘱的次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期普通会诊患者总次数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期普通会诊患者总次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期普通会诊患者总次数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期普通会诊患者总次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '普通会诊有效率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '普通会诊结束后开具相关医嘱的次数占同期普通会诊总次数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映普通会诊意见的有效性和普通会诊申请的合理性。',
    NULL, NULL, 'full', NULL, '无',
    '本指标中普通会诊结束后开具相关医嘱情况统计方法为在申请普通会诊后24小时内开具相关医嘱。', '普通会诊有效率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '普通会诊有效率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
