-- Active: 1770261316644@@192.168.1.11@3306@urm
-- ===========================================
-- 2.2.17 医疗机构检查检验结果互认率（手工填报，分子+分母+比率）
-- 创建日期：2026-03
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.17.1：医疗机构予以互认的检查检验结果（报告或影像资料）数量
CALL sp_kpi_item_create(
    '医疗机构予以互认的检查检验结果数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL, NULL,
    '医疗机构予以互认的检查检验结果（报告或影像资料）数量，以份为单位。', '《2025年国家医疗质量安全改进目标》', '分子：指医疗机构予以互认的检查检验结果（报告或影像资料）数量，以份为单位。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指医疗机构予以互认的检查检验结果（报告或影像资料）数量，以份为单位。分母：指该时间段内来医疗机构就诊患者已有的检查检验结果数量。纳入统计的项目范围以本地区互认项目目录为准。', '医疗机构予以互认的检查检验结果数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.17.1"}]'), NULL, NULL, 'manual', NULL, NULL, NULL, 1
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗机构予以互认的检查检验结果数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.17.2：医疗机构就诊患者已有的检查检验结果数量
CALL sp_kpi_item_create(
    '医疗机构就诊患者已有的检查检验结果数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL, NULL,
    '该时间段内来医疗机构就诊患者已有的检查检验结果数量。', '《2025年国家医疗质量安全改进目标》', '分母：指该时间段内来医疗机构就诊患者已有的检查检验结果数量。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指该时间段内来医疗机构就诊患者已有的检查检验结果数量。', '医疗机构就诊患者已有的检查检验结果数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.17.2"}]'), NULL, NULL, 'manual', NULL, NULL, NULL, 1
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗机构就诊患者已有的检查检验结果数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.17
CALL sp_kpi_item_create(
    '17.医疗机构检查检验结果互认率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL, NULL,
    '医疗机构检查检验结果互认率是指在一段时间内，医疗机构予以互认的检查检验结果（报告或影像资料）数量（以份为单位），占该时间段内来医疗机构就诊患者已有的检查检验结果数量的比例。', '《2025年国家医疗质量安全改进目标》', '在不影响诊疗质量安全的前提下，实现不同医疗机构间的检查检验结果互认，有助于提高医疗资源利用率，控制医疗费用，提高诊疗效率，进一步改善人民群众就医体验。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指医疗机构予以互认的检查检验结果（报告或影像资料）数量，以份为单位。分母：指该时间段内来医疗机构就诊患者已有的检查检验结果数量。纳入统计的项目范围以本地区互认项目目录为准。', '医疗机构检查检验结果互认率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.17"}]'), NULL, NULL, 'manual', NULL, NULL, NULL, 1
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '17.医疗机构检查检验结果互认率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
