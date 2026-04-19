-- ===========================================
-- 3.13.10 （十）细菌培养检查记录符合率
-- 数据源：手工填报；分子：细菌培养检查的医嘱、报告单、病程记录相对应的住院患者病历数，分母：同期开展细菌培养检查的住院患者病历总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%病案管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '细菌培养检查的医嘱、报告单、病程记录相对应的住院患者病历数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映细菌培养检查记录符合率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '细菌培养检查相关医嘱、报告单完整，培养结果及分析在病程记录中有相应记录。', '无', '无', '无', NULL,
    '统计日期', '全院', '细菌培养检查的医嘱、报告单、病程记录相对应的住院患者病历数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.10.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '细菌培养检查的医嘱、报告单、病程记录相对应的住院患者病历数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期开展细菌培养检查的住院患者病历总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映细菌培养检查记录符合率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期开展细菌培养检查的住院患者病历总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期开展细菌培养检查的住院患者病历总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.10.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期开展细菌培养检查的住院患者病历总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十）细菌培养检查记录符合率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，细菌培养检查的医嘱、报告单、病程记录相对应的住院患者病历数占同期开展细菌培养检查的住院患者病历总数的比例。', '病案管理质量控制指标（2021版）。', '反映细菌培养检查记录完整性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：细菌培养检查的医嘱、报告单、病程记录相对应的住院患者病历数。分母：同期开展细菌培养检查的住院患者病历总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.10"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十）细菌培养检查记录符合率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
