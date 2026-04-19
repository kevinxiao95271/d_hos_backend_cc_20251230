-- ===========================================
-- 2.2.1.16 关键诊疗行为相关记录完整率（手工填报，总项无分子分母）
-- 指标详见《病案管理质量控制指标(2021年版)》中(八)至(十八)项指标，本期仅建总项。
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 2.2.1.16 关键诊疗行为相关记录完整率（填报类，无分子分母，子项见病案管理质量控制指标(八)至(十八)）
CALL sp_kpi_item_create(
    '16.关键诊疗行为相关记录完整率', @category_id, NULL, 'percent', 2, 'increase', 'value', NULL, NULL,
    '关键诊疗行为相关记录完整是指在接受治疗的出院患者病历中，对该诊疗行为相关的医嘱、病程记录、查房记录、讨论记录、知情同意书、安全核查表、评估或访视记录等内容符合《医疗质量安全核心制度要点》《病历书写基本规范》等文件要求。指标详见《病案管理质量控制指标(2021年版)》中(八)至(十八)项指标。', '《2.2.1 年度安全目标.csv》。《病案管理质量控制指标(2021年版)》。《2024年国家医疗质量安全改进目标》。', '提高医疗机构关键诊疗行为相关记录的完整性与一致性，有助于规范诊疗流程，保障诊疗各个环节落实，为还原医疗过程、改进医疗质量安全奠定良好的基础。',
    NULL, NULL, 'full', NULL, NULL,
    '指标详见《病案管理质量控制指标(2021年版)》中(八)至(十八)项指标。', '关键诊疗行为相关记录完整率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.16"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '16.关键诊疗行为相关记录完整率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
