-- ===========================================
-- 2.2.10.10 四级手术患者手术当日床旁交接班占比（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '四级手术患者当日进行床旁交接班的患者数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '四级手术患者当日进行床旁交接班的患者数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '手术当日进行床旁交接班应当具备相关纸质或影像记录。', '四级手术患者当日进行床旁交接班的患者数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '四级手术患者当日进行床旁交接班的患者数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期进行四级手术的患者总数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期进行四级手术的患者总数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期进行四级手术的患者总数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期进行四级手术的患者总数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '四级手术患者手术当日床旁交接班占比', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '四级手术患者手术当日进行床旁交接班的患者数量占同期进行四级手术的患者总数量的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映交接班制度落实和管理情况。',
    NULL, NULL, 'full', NULL, '无',
    '四级手术指本机构手术分级管理目录中按四级手术管理的手术/操作；手术当日进行床旁交接班应当具备相关纸质或影像记录。', '四级手术患者手术当日床旁交接班占比', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.10"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '四级手术患者手术当日床旁交接班占比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
