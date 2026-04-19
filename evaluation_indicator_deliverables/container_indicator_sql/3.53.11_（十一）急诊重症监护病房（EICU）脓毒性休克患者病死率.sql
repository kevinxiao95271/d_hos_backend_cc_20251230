-- ===========================================
-- 3.53.11 （十一）急诊重症监护病房（EICU）脓毒性休克患者病死率
-- 数据源：手工填报（时间/部门：就诊日期、急诊科）
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    'EICU脓毒性休克患者死亡人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映EICU脓毒性休克救治质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '1.本指标适用于已设置EICU的急诊科。统计范围包括：患者收住EICU、出院或死亡诊断含脓毒性休克/感染性休克的患者。2.分子为发生在EICU的脓毒性休克患者死亡，包括直接死亡原因为脓毒性休克和/或脓毒性休克并发症，以及因合并疾病加重死亡的脓毒性休克病例。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', 'EICU脓毒性休克患者死亡人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.11.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = 'EICU脓毒性休克患者死亡人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期EICU脓毒性休克患者总人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映EICU脓毒性休克救治质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '1.本指标适用于已设置EICU的急诊科。统计范围包括：患者收住EICU、出院或死亡诊断含脓毒性休克/感染性休克的患者。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '同期EICU脓毒性休克患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.11.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期EICU脓毒性休克患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（十一）急诊重症监护病房（EICU）脓毒性休克患者病死率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, @data_source_param,
    '急诊重症监护病房（EICU）脓毒性休克患者病死率是指EICU脓毒性休克患者死亡人数占同期EICU脓毒性休克患者总人数的比例。', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映EICU脓毒性休克救治质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '1.本指标适用于已设置EICU的急诊科。统计范围包括：患者收住EICU、出院或死亡诊断含脓毒性休克/感染性休克的患者。2.分子为发生在EICU的脓毒性休克患者死亡。', '同上。', '百分比（%）', '无', NULL,
    '就诊日期', '急诊科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.11"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（十一）急诊重症监护病房（EICU）脓毒性休克患者病死率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
