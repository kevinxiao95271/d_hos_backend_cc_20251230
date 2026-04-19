-- ===========================================
-- 2.2.10.13 高额异常费用患者进行疑难病例讨论的占比（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '对产生高额异常费用患者进行疑难病例讨论的数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '对产生高额异常费用患者进行疑难病例讨论的数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '高额异常费用患者是指一个住院周期内产生的医疗费用在20万元以上的患者。', '对产生高额异常费用患者进行疑难病例讨论的数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.13.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '对产生高额异常费用患者进行疑难病例讨论的数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期高额异常费用患者数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期高额异常费用患者数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '高额异常费用患者是指一个住院周期内产生的医疗费用在20万元以上的患者。', '同期高额异常费用患者数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.13.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期高额异常费用患者数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '高额异常费用患者进行疑难病例讨论的占比', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '对产生高额异常费用患者进行疑难病例讨论的数量占同期高额异常费用患者数量的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映疑难病例讨论制度落实和管理情况。',
    NULL, NULL, 'full', NULL, '无',
    '高额异常费用患者是指一个住院周期内产生的医疗费用在20万元以上的患者（各地可根据本辖区实际情况划定费用额度）。', '高额异常费用患者进行疑难病例讨论的占比', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.13"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '高额异常费用患者进行疑难病例讨论的占比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
