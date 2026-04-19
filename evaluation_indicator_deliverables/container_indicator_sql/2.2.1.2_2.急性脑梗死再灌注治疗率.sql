-- ===========================================
-- 2.2.1.2 急性脑梗死再灌注治疗率（手工填报，分子+分母+比率）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.1.2.1
CALL sp_kpi_item_create(
    '发病6小时内静脉溶栓和/或血管内治疗的急性脑梗死患者数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '发病6小时内静脉溶栓和/或血管内治疗的急性脑梗死患者数。', '《2.2.1 年度安全目标.csv》', '分子：指满足分母且首页手术及操作栏填有药物溶栓、取栓或球囊扩张、支架置入等操作名称和对应的ICD-9-CM-3编码（99.10，39.74，00.61至00.65等）病例总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指满足分母且首页手术及操作栏填有药物溶栓、取栓或球囊扩张、支架置入等操作名称和对应的ICD-9-CM-3编码的病例总数。分母：指同期首页主要诊断为急性脑梗死（ICD-10编码为I63），且属于发病6小时之内的病例总数。', '发病6小时内静脉溶栓和/或血管内治疗的急性脑梗死患者数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '发病6小时内静脉溶栓和/或血管内治疗的急性脑梗死患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.2.2
CALL sp_kpi_item_create(
    '同期发病6小时内的急性脑梗死患者总数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期发病6小时内的急性脑梗死患者总数。', '《2.2.1 年度安全目标.csv》', '分母：指同期首页主要诊断为急性脑梗死（ICD-10编码为I63），且属于发病6小时之内的病例总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期首页主要诊断为急性脑梗死（ICD-10编码为I63），且属于发病6小时之内的病例总数。', '同期发病6小时内的急性脑梗死患者总数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期发病6小时内的急性脑梗死患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.2
CALL sp_kpi_item_create(
    '2.急性脑梗死再灌注治疗率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '急性脑梗死再灌注治疗率是指发病6小时内接受静脉溶栓治疗和（或）血管内治疗的急性脑梗死患者占同期发病6小时内的急性脑梗死患者总数的比例。', '《2.2.1 年度安全目标.csv》', '评价急性脑梗死再灌注治疗及时性与规范性。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指满足分母且首页手术及操作栏填有药物溶栓、取栓或球囊扩张、支架置入等操作名称和对应的ICD-9-CM-3编码（99.10，39.74，00.61至00.65等）病例总数。分母：指同期首页主要诊断为急性脑梗死（ICD-10编码为I63），且属于发病6小时之内的病例总数。', '急性脑梗死再灌注治疗率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '2.急性脑梗死再灌注治疗率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
