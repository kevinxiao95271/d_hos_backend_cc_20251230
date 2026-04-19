-- ===========================================
-- 3.6.8 （八）三、四级手术台均用血量
-- 数据源：手工填报；分子：三级和四级手术用血总单位数，分母：同期三级和四级手术总台数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床用血%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '三级和四级手术用血总单位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映三、四级手术台均用血量分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '三级和四级手术用血总单位数，仅统计红细胞成分及全血用量。', '无', '无', '无', NULL,
    '统计日期', '输血科', '三级和四级手术用血总单位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '三级和四级手术用血总单位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期三级和四级手术总台数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映三、四级手术台均用血量分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期三级和四级手术总台数。', '无', '无', '无', NULL,
    '统计日期', '输血科', '同期三级和四级手术总台数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期三级和四级手术总台数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（八）三、四级手术台均用血量', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间三级和四级手术台均用血量，仅统计红细胞成分及全血用量。', '《临床用血质量控制指标（2019版）》。', '反映三、四级手术用血情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：三级和四级手术用血总单位数。分母：同期三级和四级手术总台数。', '无', 'U', '无', NULL,
    '统计日期', '输血科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（八）三、四级手术台均用血量' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
