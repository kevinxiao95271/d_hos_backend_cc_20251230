-- ===========================================
-- 3.28.6 淋巴瘤患者 18F-FDG PET/CT 多维尔评分率（NM-06）
-- 数据源：手工填报
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%核医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.28.6.1
CALL sp_kpi_item_create(
    '对淋巴瘤患者 18F-FDGPET/CT 进行多维尔（Deauville）评分的例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映核医学 PET/CT 报告的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '多维尔评分规则可参照《淋巴瘤 18F-FDGPET/CT 及PET/MR 显像临床应用指南(2021 版)》。', '多维尔评分规则可参照《淋巴瘤 18F-FDGPET/CT 及PET/MR 显像临床应用指南(2021 版)》。', '无', '无', NULL,
    '检查日期', '核医学科', '对淋巴瘤患者 18F-FDGPET/CT 进行多维尔（Deauville）评分的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.6.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '对淋巴瘤患者 18F-FDGPET/CT 进行多维尔（Deauville）评分的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.28.6.2
CALL sp_kpi_item_create(
    '行 18F-FDGPET/CT 淋巴瘤患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映核医学 PET/CT 报告的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '多维尔评分规则可参照《淋巴瘤 18F-FDGPET/CT 及PET/MR 显像临床应用指南(2021 版)》。', '多维尔评分规则可参照《淋巴瘤 18F-FDGPET/CT 及PET/MR 显像临床应用指南(2021 版)》。', '无', '无', NULL,
    '检查日期', '核医学科', '行 18F-FDGPET/CT 淋巴瘤患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.6.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '行 18F-FDGPET/CT 淋巴瘤患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.28.6
CALL sp_kpi_item_create(
    '淋巴瘤患者 18F-FDG PET/CT 多维尔评分率（NM-06）', @category_id, NULL, 'integer', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '对淋巴瘤患者 18F-FDGPET/CT 进行多维尔（Deauville）评分的例数占同期行 18F-FDGPET/CT 淋巴瘤患者总例数的比例。', '无', '反映核医学 PET/CT 报告的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '多维尔评分规则可参照《淋巴瘤 18F-FDGPET/CT 及PET/MR 显像临床应用指南(2021 版)》。', '多维尔评分规则可参照《淋巴瘤 18F-FDGPET/CT 及PET/MR 显像临床应用指南(2021 版)》。', '无', '无', NULL,
    '检查日期', '核医学科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.6"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '淋巴瘤患者 18F-FDG PET/CT 多维尔评分率（NM-06）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
