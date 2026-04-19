-- ===========================================
-- 2.2.1.15 住院患者围手术期死亡率（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.1.15.1
CALL sp_kpi_item_create(
    '住院患者围手术期死亡人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '住院患者围手术期死亡人数。', '《2.2.1 年度安全目标.csv》', '分子：住院患者围手术期死亡人数。',
    NULL, NULL, 'full', NULL, NULL,
    '本指标重点关注住院患者进行开放手术、介入治疗及内（窥）镜下治疗性操作在手术当日、术后24小时和48小时的死亡情况。分母：同期住院手术患者总人数。', '住院患者围手术期死亡人数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.15.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院患者围手术期死亡人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.15.2
CALL sp_kpi_item_create(
    '同期住院手术患者总人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '同期住院手术患者总人数。', '《2.2.1 年度安全目标.csv》', '分母：同期住院手术患者总人数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：同期住院手术患者总人数。', '同期住院手术患者总人数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.15.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院手术患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.15
CALL sp_kpi_item_create(
    '15.住院患者围手术期死亡率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', NULL, NULL,
    '住院患者围手术期死亡率指住院患者围手术期死亡人数占同期住院手术患者总人数的比例。', '《2.2.1 年度安全目标.csv》', '住院患者围手术期死亡率是行业通用的反映手术质量安全的指标之一。加强住院患者围手术期管理，落实手术相关管理制度，降低住院患者围手术期死亡率，对整体提高医疗质量安全水平具有重要意义。',
    NULL, NULL, 'full', NULL, NULL,
    '本指标重点关注住院患者进行开放手术、介入治疗及内（窥）镜下治疗性操作在手术当日、术后24小时和48小时的死亡情况。', '住院患者围手术期死亡率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.15"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '15.住院患者围手术期死亡率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
