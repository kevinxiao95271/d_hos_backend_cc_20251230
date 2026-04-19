-- ===========================================
-- 3.6.1 （一）每千单位用血输血专业技术人员数
-- 数据源：手工填报；分子：输血科（血库）专职专业技术人员数，分母：医疗机构年度用血总单位数/1000
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床用血%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '输血科（血库）专职专业技术人员数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映每千单位用血输血专业技术人员数分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '输血科（血库）专职专业技术人员数指参与输血科日常工作人员，包括夜班人员。', '无', '无', '无', NULL,
    '统计日期', '输血科', '输血科（血库）专职专业技术人员数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '输血科（血库）专职专业技术人员数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '医疗机构年度用血总单位数/1000', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映每千单位用血输血专业技术人员数分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '医疗机构年度用血总单位数指全血、红细胞成分和血浆的总单位数，不含回收式自体输血量；填报可为年度用血总单位数/1000。', '无', '无', '无', NULL,
    '统计日期', '输血科', '医疗机构年度用血总单位数/1000',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗机构年度用血总单位数/1000' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）每千单位用血输血专业技术人员数', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '输血科（血库）专职专业技术人员数与医疗机构年度每千单位用血数之比。', '《临床用血质量控制指标（2019版）》。', '反映临床用血服务能力及输血专业技术人员配备。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：输血科（血库）专职专业技术人员数。分母：医疗机构年度用血总单位数/1000。', '无', '名', '无', NULL,
    '统计日期', '输血科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）每千单位用血输血专业技术人员数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
