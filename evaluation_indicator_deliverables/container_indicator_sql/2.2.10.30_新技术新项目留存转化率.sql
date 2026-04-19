-- ===========================================
-- 2.2.10.30 新技术新项目留存转化率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '第四年继续开展的新技术新项目种类数_分子', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '分子（A+C+E）：第二年新增并在第三和第四年继续开展+第二年新增并只在第四年继续开展+第三年新增并在第四年继续开展的技术项目种类数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '在四年周期内考核第二年和第三年新技术新项目种类数在第四年的继续开展情况。', '第四年继续开展的新技术新项目种类数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.30.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '第四年继续开展的新技术新项目种类数_分子' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '第二第三年新增新技术新项目种类数_分母', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '分母（A+B+C+D+E+F）：第二年新增的所有技术项目+第三年新增的所有技术项目。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '第二第三年新增新技术新项目种类数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.30.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '第二第三年新增新技术新项目种类数_分母' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '新技术新项目留存转化率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '在四年的评估周期内，医院新增的技术项目在第四年继续开展的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映新技术新项目应用的持续性。',
    NULL, NULL, 'full', NULL, '无',
    '在四年周期内，将以第一年技术项目种类数为基数，定义年度新增的技术、项目种类数为年度技术项目种类数减去第一年技术项目种类数。', '新技术新项目留存转化率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.30"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '新技术新项目留存转化率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
