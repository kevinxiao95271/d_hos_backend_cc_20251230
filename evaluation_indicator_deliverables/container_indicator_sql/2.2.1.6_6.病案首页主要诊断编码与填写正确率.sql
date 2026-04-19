-- ===========================================
-- 2.2.1.6 病案首页主要诊断编码正确率 + 主要诊断填写正确率（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- ========== 2.2.1.6.1 病案首页主要诊断编码正确率 ==========
-- 分子 2.2.1.6.1.1
CALL sp_kpi_item_create(
    '病案首页中主要诊断编码正确的出院患者病案数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '病案首页中主要诊断编码正确的出院患者病案数。', '《2.2.1 年度安全目标.csv》', '分子：指出院病案总数中主要诊断编码正确病案总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指出院病案总数中主要诊断编码正确病案总数。分母：指同期出院病案总份数。', '病案首页中主要诊断编码正确的出院患者病案数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.6.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_611_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '病案首页中主要诊断编码正确的出院患者病案数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.6.1.2
CALL sp_kpi_item_create(
    '同期出院患者病案总份数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期出院患者病案总份数。', '《2.2.1 年度安全目标.csv》', '分母：指同期出院病案总份数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期出院病案总份数。', '同期出院患者病案总份数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.6.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_612_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者病案总份数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.6.1 病案首页主要诊断编码正确率
CALL sp_kpi_item_create(
    '病案首页主要诊断编码正确率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '主要诊断编码正确率是指病案首页中主要诊断编码正确的出院患者病案数占同期出院患者病案总数的比例。', '《2.2.1 年度安全目标.csv》', '提高病案首页主要诊断编码正确率，是提升病案首页质量的重要内容，对正确统计医疗机构及地区疾病谱、支撑DRGs分组、评价医疗质量安全水平和技术能力等工作具有非常重要的基础性支撑作用。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指出院病案总数中主要诊断编码正确病案总数。分母：指同期出院病案总份数。', '病案首页主要诊断编码正确率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_611_id, @den_612_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.6.1"}]'), NULL, NULL, NULL, NULL
);

-- ========== 2.2.1.6.2 病案首页主要诊断填写正确率 ==========
-- 分子 2.2.1.6.2.1（分母 2.2.1.6.2.2 与 2.2.1.6.1.2 同名，需新建一条独立 KPI 以区分编码）
CALL sp_kpi_item_create(
    '病案首页中主要诊断填写正确的出院患者病案数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '病案首页中主要诊断填写正确的出院患者病案数。', '《2.2.1 年度安全目标.csv》', '分子：指出院病案总数中主要诊断填写正确病案总数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指出院病案总数中主要诊断填写正确病案总数。分母：指同期出院病案总份数。', '病案首页中主要诊断填写正确的出院患者病案数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.6.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_621_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '病案首页中主要诊断填写正确的出院患者病案数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.6.2.2 与 6.1.2 概念相同均为「同期出院患者病案总份数」，复用同一条 KPI 会与 6.1 共用分母；CSV 要求两条独立指标，故 6.2 分母单独建一条（名称相同、编码 2.2.1.6.2.2）
CALL sp_kpi_item_create(
    '同期出院患者病案总份数_主要诊断填写', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期出院患者病案总份数（用于主要诊断填写正确率分母）。', '《2.2.1 年度安全目标.csv》', '分母：指同期出院病案总份数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期出院病案总份数。', '同期出院患者病案总份数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.6.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_622_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者病案总份数_主要诊断填写' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.6.2 病案首页主要诊断填写正确率
CALL sp_kpi_item_create(
    '病案首页主要诊断填写正确率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '主要诊断填写正确率是指病案首页中主要诊断填写正确的出院患者病案数占同期出院患者病案总数的比例。', '《2.2.1 年度安全目标.csv》', '提高病案首页主要诊断填写正确率，是提升病案首页质量的重要内容。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指出院病案总数中主要诊断填写正确病案总数。分母：指同期出院病案总份数。', '病案首页主要诊断填写正确率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_621_id, @den_622_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.6.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME IN ('病案首页主要诊断编码正确率','病案首页主要诊断填写正确率') AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 2;
