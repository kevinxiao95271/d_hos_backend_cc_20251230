-- ===========================================
-- 2.2.10.3 上级医师查房记录规范率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '住院患者病历中上级医师查房记录规范完整的病例数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '住院患者病历中上级医师查房记录规范、完整的病例数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '反映三级查房制度落实情况、查房记录的规范性和查房质量。', '住院患者病历中上级医师查房记录规范完整的病例数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院患者病历中上级医师查房记录规范完整的病例数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院患者病例总数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期住院患者病例总数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期住院患者病例总数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院患者病例总数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '上级医师查房记录规范率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '住院患者病历中上级医师查房记录规范、完整的病例数量占同期住院患者病例总数量的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映三级查房制度落实情况、查房记录的规范性和查房质量。',
    NULL, NULL, 'full', NULL, '无',
    '反映三级查房制度落实情况、查房记录的规范性和查房质量。', '上级医师查房记录规范率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '上级医师查房记录规范率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
