-- ===========================================
-- 2.2.10.32 住院患者危急值当日及时处置率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '当日处置的住院患者危急值项目数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '当日处置的住院患者危急值项目数（以危急值出现当日的病程记录为准）。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '当日处置的危急值项目数以危急值出现当日的病程记录为准，若无记录则视为未处置。', '当日处置的住院患者危急值项目数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.32.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '当日处置的住院患者危急值项目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期临床科室接获住院患者危急值项目数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期临床科室接获住院患者危急值项目数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '本指标只统计住院患者危急值，不包括门急诊。', '同期临床科室接获住院患者危急值项目数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.32.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期临床科室接获住院患者危急值项目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '住院患者危急值当日及时处置率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '当日处置的住院患者危急值项目数占同期临床科室接获住院患者危急值项目数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映危急值规范化管理程度。',
    NULL, NULL, 'full', NULL, '无',
    '本指标只统计住院患者危急值处置情况；当日处置以危急值出现当日的病程记录为准，若无记录则视为未处置。', '住院患者危急值当日及时处置率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.32"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '住院患者危急值当日及时处置率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
