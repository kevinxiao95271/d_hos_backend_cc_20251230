-- ===========================================
-- 3.53.7.1 院前心脏骤停复苏成功率
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '复苏成功的院前心脏骤停患者人数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映心脏骤停急诊救治能力和质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '1.复苏成功指胸外按压停止后自主循环（或ECMO支持下循环）维持20min及以上。同一患者单次就诊期间行多次心肺复苏术，有一次成功即视为成功。2.院前心脏骤停是指心脏骤停首次发生于其他地点。3.抢救过程中患者家属（或委托人）要求不再进行心肺复苏者，不纳入统计。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '复苏成功的院前心脏骤停患者人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.7.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '复苏成功的院前心脏骤停患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期行CPR的院前心脏骤停患者总人数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映心脏骤停急诊救治能力和质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '1.复苏成功指胸外按压停止后自主循环（或ECMO支持下循环）维持20min及以上。2.院前心脏骤停是指心脏骤停首次发生于其他地点。3.抢救过程中患者家属（或委托人）要求不再进行心肺复苏者，不纳入统计。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '同期行CPR的院前心脏骤停患者总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.7.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期行CPR的院前心脏骤停患者总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '院前心脏骤停复苏成功率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '院前心脏骤停复苏成功率是指复苏成功的院前心脏骤停患者人数占同期行CPR的院前心脏骤停患者总人数的比例。', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映心脏骤停急诊救治能力和质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '1.复苏成功指胸外按压停止后自主循环（或ECMO支持下循环）维持20min及以上。2.院前心脏骤停是指心脏骤停首次发生于其他地点。3.抢救过程中患者家属（或委托人）要求不再进行心肺复苏者，不纳入统计。', '同上。', '百分比（%）', '无', NULL,
    '就诊日期', '急诊科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.7.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '院前心脏骤停复苏成功率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
