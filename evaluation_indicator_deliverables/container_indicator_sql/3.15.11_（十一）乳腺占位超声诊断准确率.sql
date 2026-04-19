-- ===========================================
-- 3.15.11 （十一）乳腺占位超声诊断准确率
-- 数据源：手工填报；分子：乳腺超声诊断为乳腺癌或非乳腺癌与病理检验结果相一致的例数，分母：同期行超声诊断为乳腺占位并送病理检验总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%超声诊断专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '单位时间内乳腺超声诊断为乳腺癌或非乳腺癌与病理检验结果相一致的例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '超声诊断专业医疗质量控制指标（2022版）。', '反映乳腺占位超声诊断准确率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '采用BI-RADS分类，真阳性及真阴性参照ACR BI-RADS Ultrasound 2013。以最终病理诊断为参考标准。', '无', '无', '无', NULL,
    '统计日期', '全院', '单位时间内乳腺超声诊断为乳腺癌或非乳腺癌与病理检验结果相一致的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.15.11.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '单位时间内乳腺超声诊断为乳腺癌或非乳腺癌与病理检验结果相一致的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期行超声诊断为乳腺占位并送病理检验总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '超声诊断专业医疗质量控制指标（2022版）。', '反映乳腺占位超声诊断准确率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期进行乳腺超声检查并通过穿刺或切除活检获得明确病理诊断结果的病例。排除超声无法定性或未定性、无病理或病理不明确的病例。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期行超声诊断为乳腺占位并送病理检验总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.15.11.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期行超声诊断为乳腺占位并送病理检验总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十一）乳腺占位超声诊断准确率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，乳腺超声诊断为乳腺癌或非乳腺癌与病理检验结果相一致的例数，占同期行超声诊断为乳腺占位并送病理检验总例数的比例。', '超声诊断专业医疗质量控制指标（2022版）。', '反映乳腺占位超声诊断与病理一致性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：单位时间内乳腺超声诊断为乳腺癌或非乳腺癌与病理检验结果相一致的例数。分母：同期行超声诊断为乳腺占位并送病理检验总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.15.11"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十一）乳腺占位超声诊断准确率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
