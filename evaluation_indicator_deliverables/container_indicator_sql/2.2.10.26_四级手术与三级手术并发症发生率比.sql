-- ===========================================
-- 2.2.10.26 四级手术与三级手术并发症发生率比（监测比较，手工或由四级率/三级率计算）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '四级手术与三级手术并发症发生率比', @category_id, NULL, 'decimal', 2, 'monitor', 'value', NULL, NULL,
    '四级手术并发症发生率与三级手术并发症发生率的比。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映手术分级管理的合理性。',
    NULL, NULL, 'full', NULL, '无',
    '三、四级手术指本机构手术分级管理目录中的手术级别。手术并发症包括手术后肺栓塞、深静脉血栓、脓毒症、出血或血肿、伤口裂开、呼吸衰竭、生理/代谢紊乱、与手术/操作相关感染、手术过程中异物遗留、手术患者麻醉并发症、肺部感染与肺机能不全、手术意外穿刺伤或撕裂伤、手术后急性肾衰竭等。', '四级手术与三级手术并发症发生率比', '比值', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.26"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称
FROM KPI_ITEM WHERE KPI_NAME = '四级手术与三级手术并发症发生率比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
