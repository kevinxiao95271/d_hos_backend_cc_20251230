-- ===========================================
-- 2.2.1.10 阴道分娩并发症发生率（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.1.10.1
CALL sp_kpi_item_create(
    '阴道分娩并发症发生人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '阴道分娩并发症发生人数。', '《2.2.1 年度安全目标.csv》', '分子：指住院患者阴道分娩并发症发生总例数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院患者阴道分娩并发症发生总例数。分母：指同期住院患者阴道分娩产妇总人数。', '阴道分娩并发症发生人数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '阴道分娩并发症发生人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.10.2
CALL sp_kpi_item_create(
    '同期阴道分娩产妇总人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '同期阴道分娩产妇总人数。', '《2.2.1 年度安全目标.csv》', '分母：指同期住院患者阴道分娩产妇总人数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期住院患者阴道分娩产妇总人数。', '同期阴道分娩产妇总人数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期阴道分娩产妇总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.10
CALL sp_kpi_item_create(
    '10.阴道分娩并发症发生率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', NULL, NULL,
    '阴道分娩并发症发生率是指阴道分娩并发症发生人数占同期阴道分娩产妇总人数的比例。', '《2.2.1 年度安全目标.csv》', '降低阴道分娩并发症发生率对提升医疗质量，保障产妇和新生儿安全具有重要意义。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院患者阴道分娩并发症发生总例数。分母：指同期住院患者阴道分娩产妇总人数。', '阴道分娩并发症发生率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.10"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '10.阴道分娩并发症发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
