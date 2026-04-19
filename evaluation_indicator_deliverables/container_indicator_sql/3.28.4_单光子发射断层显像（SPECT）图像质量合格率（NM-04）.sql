-- ===========================================
-- 3.28.4 单光子发射断层显像（SPECT）图像质量合格率（NM-04）
-- 数据源：手工填报
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%核医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.28.4.1
CALL sp_kpi_item_create(
    'SPECT 图像质量评价为合格的例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映核医学 SPECT 检查图像质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '本指标中图像质量评价的合格是指符合以下条件：（1） 显像范围和体位正确；（2）无图像伪影（在扫描或信息 处理过程中产生的某些异常影像，与病变本身无关）；（3）图像灰度适中，病变和正常组织能较好地区分和识别。以上评价标准参考中华医学会核医学分会颁布的《SPECT 和 SPECT/CT 仪临床使用评价指标》。', '本指标中图像质量评价的合格是指符合以下条件：（1） 显像范围和体位正确；（2）无图像伪影（在扫描或信息 处理过程中产生的某些异常影像，与病变本身无关）；（3）图像灰度适中，病变和正常组织能较好地区分和识别。以上评价标准参考中华医学会核医学分会颁布的《SPECT 和 SPECT/CT 仪临床使用评价指标》。', '无', '无', NULL,
    '检查日期', '核医学科', 'SPECT 图像质量评价为合格的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'SPECT 图像质量评价为合格的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.28.4.2
CALL sp_kpi_item_create(
    'SPECT 图像质量评价总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映核医学 SPECT 检查图像质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '本指标中图像质量评价的合格是指符合以下条件：（1） 显像范围和体位正确；（2）无图像伪影（在扫描或信息 处理过程中产生的某些异常影像，与病变本身无关）；（3）图像灰度适中，病变和正常组织能较好地区分和识别。以上评价标准参考中华医学会核医学分会颁布的《SPECT 和 SPECT/CT 仪临床使用评价指标》。', '本指标中图像质量评价的合格是指符合以下条件：（1） 显像范围和体位正确；（2）无图像伪影（在扫描或信息 处理过程中产生的某些异常影像，与病变本身无关）；（3）图像灰度适中，病变和正常组织能较好地区分和识别。以上评价标准参考中华医学会核医学分会颁布的《SPECT 和 SPECT/CT 仪临床使用评价指标》。', '无', '无', NULL,
    '检查日期', '核医学科', 'SPECT 图像质量评价总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'SPECT 图像质量评价总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.28.4
CALL sp_kpi_item_create(
    '单光子发射断层显像（SPECT）图像质量合格率（NM-04）', @category_id, NULL, 'integer', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    'SPECT 图像质量评价为合格的例数占同期 SPECT 图像质量评价总例数的比例。', '无', '反映核医学 SPECT 检查图像质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '本指标中图像质量评价的合格是指符合以下条件：（1） 显像范围和体位正确；（2）无图像伪影（在扫描或信息 处理过程中产生的某些异常影像，与病变本身无关）；（3）图像灰度适中，病变和正常组织能较好地区分和识别。以上评价标准参考中华医学会核医学分会颁布的《SPECT 和 SPECT/CT 仪临床使用评价指标》。', '本指标中图像质量评价的合格是指符合以下条件：（1） 显像范围和体位正确；（2）无图像伪影（在扫描或信息 处理过程中产生的某些异常影像，与病变本身无关）；（3）图像灰度适中，病变和正常组织能较好地区分和识别。以上评价标准参考中华医学会核医学分会颁布的《SPECT 和 SPECT/CT 仪临床使用评价指标》。', '无', '无', NULL,
    '检查日期', '核医学科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '单光子发射断层显像（SPECT）图像质量合格率（NM-04）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
