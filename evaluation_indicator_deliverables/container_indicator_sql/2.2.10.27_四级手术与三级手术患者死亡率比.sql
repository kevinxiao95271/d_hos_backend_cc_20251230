-- ===========================================
-- 2.2.10.27 四级手术与三级手术患者死亡率比（监测比较，手工或由四级率/三级率计算）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '四级手术与三级手术患者死亡率比', @category_id, NULL, 'decimal', 2, 'monitor', 'value', NULL, NULL,
    '四级手术患者死亡率与三级手术患者死亡率的比。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映手术分级管理的合理性。',
    NULL, NULL, 'full', NULL, '无',
    '各级手术患者死亡率为各级手术患者死亡人数占同期各级手术患者人数的比例。', '四级手术与三级手术患者死亡率比', '比值', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.27"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称
FROM KPI_ITEM WHERE KPI_NAME = '四级手术与三级手术患者死亡率比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
