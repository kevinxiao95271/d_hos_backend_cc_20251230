-- ===========================================
-- 3.56.6 （六）住院患者联合使用重点抗菌药物治疗前病原学送检率
-- 数据源：手工填报；分子：联合使用重点抗菌药物治疗前病原学送检的住院患者人数，分母：同期联合使用重点抗菌药物治疗的住院患者总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医院感染管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '联合使用重点抗菌药物治疗前病原学送检的住院患者人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映联合使用重点抗菌药物治疗前病原学送检率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '联合使用重点抗菌药物治疗前病原学送检的住院患者人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '联合使用重点抗菌药物治疗前病原学送检的住院患者人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.6.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '联合使用重点抗菌药物治疗前病原学送检的住院患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期联合使用重点抗菌药物治疗的住院患者总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映联合使用重点抗菌药物治疗前病原学送检率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期联合使用重点抗菌药物治疗的住院患者总人数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期联合使用重点抗菌药物治疗的住院患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.6.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期联合使用重点抗菌药物治疗的住院患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（六）住院患者联合使用重点抗菌药物治疗前病原学送检率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '联合使用重点抗菌药物治疗前病原学送检的住院患者人数占同期联合使用重点抗菌药物治疗的住院患者总人数的比例。', '《医院感染管理医疗质量控制指标（2024年版）》。', '反映重点抗菌药物治疗前病原学送检情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：联合使用重点抗菌药物治疗前病原学送检的住院患者人数。分母：同期联合使用重点抗菌药物治疗的住院患者总人数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.56.6"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（六）住院患者联合使用重点抗菌药物治疗前病原学送检率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
