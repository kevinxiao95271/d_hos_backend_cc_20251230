-- ===========================================
-- 3.6.9 （九）手术患者自体输血率
-- 数据源：手工填报；分子：手术患者自体输血总单位数，分母：同期手术患者异体输血单位数+自体输血单位数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床用血%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '手术患者自体输血总单位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映手术患者自体输血率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '手术患者自体输血总单位数，仅统计红细胞成分及全血用量。', '无', '无', '无', NULL,
    '统计日期', '输血科', '手术患者自体输血总单位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.9.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '手术患者自体输血总单位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期手术患者异体输血单位数+自体输血单位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《临床用血质量控制指标（2019版）》。', '反映手术患者自体输血率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期手术患者异体输血单位数与自体输血单位数之和，仅统计红细胞成分及全血用量。', '无', '无', '无', NULL,
    '统计日期', '输血科', '同期手术患者异体输血单位数+自体输血单位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.9.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期手术患者异体输血单位数+自体输血单位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（九）手术患者自体输血率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间手术患者住院期间自体输血量占手术患者异体输血量和自体输血量之和的百分比，仅统计红细胞成分及全血用量。', '《临床用血质量控制指标（2019版）》。', '反映手术患者自体输血开展情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：手术患者自体输血总单位数。分母：同期手术患者异体输血单位数+自体输血单位数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '输血科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["输血科"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.6.9"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（九）手术患者自体输血率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
