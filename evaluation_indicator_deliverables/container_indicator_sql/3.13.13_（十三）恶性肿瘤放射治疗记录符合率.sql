-- ===========================================
-- 3.13.13 （十三）恶性肿瘤放射治疗记录符合率
-- 数据源：手工填报；分子：恶性肿瘤放射治疗医嘱（治疗单）、病程记录相对应的住院患者病历数，分母：同期开展恶性肿瘤放射治疗的住院患者病历总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%病案管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '恶性肿瘤放射治疗医嘱（治疗单）、病程记录相对应的住院患者病历数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映恶性肿瘤放射治疗记录符合率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '放射治疗医嘱（治疗单）完整，治疗情况在病程记录中有相应记录。', '无', '无', '无', NULL,
    '统计日期', '全院', '恶性肿瘤放射治疗医嘱（治疗单）、病程记录相对应的住院患者病历数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.13.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '恶性肿瘤放射治疗医嘱（治疗单）、病程记录相对应的住院患者病历数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期开展恶性肿瘤放射治疗的住院患者病历总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映恶性肿瘤放射治疗记录符合率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期开展恶性肿瘤放射治疗的住院患者病历总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期开展恶性肿瘤放射治疗的住院患者病历总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.13.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期开展恶性肿瘤放射治疗的住院患者病历总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十三）恶性肿瘤放射治疗记录符合率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，恶性肿瘤放射治疗医嘱（治疗单）、病程记录相对应的住院患者病历数占同期接受恶性肿瘤放射治疗的住院患者病历总数的比例。', '病案管理质量控制指标（2021版）。', '反映恶性肿瘤放射治疗记录完整性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：恶性肿瘤放射治疗医嘱（治疗单）、病程记录相对应的住院患者病历数。分母：同期开展恶性肿瘤放射治疗的住院患者病历总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.13"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十三）恶性肿瘤放射治疗记录符合率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
