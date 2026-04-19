-- ===========================================
-- 3.13.1 （一）住院病案管理人员月均负担出院患者病历数
-- 数据源：手工填报；分子：出院患者病历总数，分母：同期住院病案管理人员实际工作总月数；单位：例次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%病案管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '出院患者病历总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映住院病案管理人员月均负担出院患者病历数分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '出院患者病历总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '出院患者病历总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院患者病历总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期住院病案管理人员实际工作总月数', @category_id, NULL, 'decimal', 2, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映住院病案管理人员月均负担出院患者病历数分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '每名工作人员实际工作月数的总和。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期住院病案管理人员实际工作总月数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期住院病案管理人员实际工作总月数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）住院病案管理人员月均负担出院患者病历数', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，每名住院病案管理人员每月平均负担的出院患者病历数。', '病案管理质量控制指标（2021版）。', '反映住院病案管理人员工作负荷。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：出院患者病历总数。分母：同期住院病案管理人员实际工作总月数。', '无', '例次数', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）住院病案管理人员月均负担出院患者病历数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
