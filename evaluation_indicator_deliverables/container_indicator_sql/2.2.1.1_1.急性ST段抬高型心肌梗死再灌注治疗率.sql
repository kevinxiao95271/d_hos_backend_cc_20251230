-- ===========================================
-- 2.2.1.1 急性ST段抬高型心肌梗死再灌注治疗率（手工填报，分子+分母+比率）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.1.1.1：发病12小时内给予静脉溶栓或PCI的STEMI患者数
CALL sp_kpi_item_create(
    '发病12小时内给予静脉溶栓或PCI的STEMI患者数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '发病12小时内给予静脉溶栓或PCI的STEMI患者数。', '《2.2.1 年度安全目标.csv》', '分子：指满足分母且首页中手术及操作栏填有静脉溶栓、PCI的操作名称（PCI包括冠脉球囊扩张、支架植入等）和对应的ICD-9-CM-3编码（99.10，00.66，36.04，36.06，36.07，17.55等）的患者总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指满足分母且首页中手术及操作栏填有静脉溶栓、PCI的操作名称和对应的ICD-9-CM-3编码的患者总数。分母：指同期诊断为STEMI的病例（主要诊断符合ICD-10编码为I21.0至I21.3，I21.9）且属于发病在12小时内病例总数。', '发病12小时内给予静脉溶栓或PCI的STEMI患者数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '发病12小时内给予静脉溶栓或PCI的STEMI患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.1.2：同期发病12小时内的STEMI患者总数
CALL sp_kpi_item_create(
    '同期发病12小时内的STEMI患者总数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期发病12小时内的STEMI患者总数。', '《2.2.1 年度安全目标.csv》', '分母：指同期诊断为STEMI的病例（主要诊断符合ICD-10编码为I21.0至I21.3，I21.9）且属于发病在12小时内病例总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期诊断为STEMI的病例（主要诊断符合ICD-10编码为I21.0至I21.3，I21.9）且属于发病在12小时内病例总数。', '同期发病12小时内的STEMI患者总数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期发病12小时内的STEMI患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.1：1.急性ST段抬高型心肌梗死再灌注治疗率
CALL sp_kpi_item_create(
    '1.急性ST段抬高型心肌梗死再灌注治疗率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '急性ST段抬高型心肌梗死再灌注治疗率是指发病12小时内的急性STEMI患者给予经皮冠状动脉介入治疗（PCI）或静脉溶栓治疗的患者数占发病12小时内的STEMI患者总数的比例。', '《2.2.1 年度安全目标.csv》', '提高急性STEMI患者再灌注治疗率对降低致残率及死亡率、改善患者生活质量具有重要意义。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指满足分母且首页中手术及操作栏填有静脉溶栓、PCI的操作名称和对应的ICD-9-CM-3编码的患者总数。分母：指同期诊断为STEMI的病例（主要诊断符合ICD-10编码为I21.0至I21.3，I21.9）且属于发病在12小时内病例总数。', '急性ST段抬高型心肌梗死再灌注治疗率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '1.急性ST段抬高型心肌梗死再灌注治疗率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
