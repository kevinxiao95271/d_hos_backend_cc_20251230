-- ===========================================
-- 2.2.10.35 术中自体血回输率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '术中使用自体血回输的患者数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '术中使用自体血回输的患者数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '反映临床用血管理情况。', '术中使用自体血回输的患者数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.35.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '术中使用自体血回输的患者数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期术中进行输血患者总数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期术中进行输血患者总数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期术中进行输血患者总数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.35.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期术中进行输血患者总数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '术中自体血回输率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '术中使用自体血回输的患者数量占同期术中进行输血患者总数量的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映临床用血管理情况。',
    NULL, NULL, 'full', NULL, '无',
    '反映临床用血管理情况。', '术中自体血回输率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.35"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '术中自体血回输率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
