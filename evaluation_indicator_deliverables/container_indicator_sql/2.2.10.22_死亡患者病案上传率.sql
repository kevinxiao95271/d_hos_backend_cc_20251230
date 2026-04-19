-- ===========================================
-- 2.2.10.22 死亡患者病案上传率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '按要求完整上传本机构死亡患者病案的数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '按要求完整上传本机构死亡患者病案的数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '应上传死亡患者病案是指根据HQMS每月反馈各医疗机构须上传的死亡患者病案清单中的所有病案信息。', '按要求完整上传本机构死亡患者病案的数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.22.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '按要求完整上传本机构死亡患者病案的数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期应上传死亡患者病案总数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期应上传死亡患者病案总数量（HQMS反馈清单）。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '应上传死亡患者病案是指根据HQMS每月反馈各医疗机构须上传的死亡患者病案清单中的所有病案信息。', '同期应上传死亡患者病案总数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.22.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期应上传死亡患者病案总数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '死亡患者病案上传率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '按要求完整上传本机构死亡患者病案的数量占同期应上传死亡患者病案总数量的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映开展死亡病案上报工作的落实和管理情况。',
    NULL, NULL, 'full', NULL, '无',
    '应上传死亡患者病案是指根据HQMS每月反馈各医疗机构须上传的死亡患者病案清单中的所有病案信息。', '死亡患者病案上传率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.22"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '死亡患者病案上传率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
