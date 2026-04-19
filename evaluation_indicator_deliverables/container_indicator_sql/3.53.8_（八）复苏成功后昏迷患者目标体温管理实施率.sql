-- ===========================================
-- 3.53.8 （八）复苏成功后昏迷患者目标体温管理实施率
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '实施目标体温管理的复苏成功后昏迷患者例数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映心脏骤停自主循环恢复后管理的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '本指标中目标体温管理是指对复苏成功后仍昏迷的患者实施体温控制，维持体温32℃-36℃至少24小时。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '实施目标体温管理的复苏成功后昏迷患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实施目标体温管理的复苏成功后昏迷患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期复苏成功后昏迷患者总例数', @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映心脏骤停自主循环恢复后管理的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '本指标中目标体温管理是指对复苏成功后仍昏迷的患者实施体温控制，维持体温32℃-36℃至少24小时。', '同上。', '无', '无', NULL,
    '就诊日期', '急诊科', '同期复苏成功后昏迷患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期复苏成功后昏迷患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（八）复苏成功后昏迷患者目标体温管理实施率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, @data_source_param,
    '复苏成功后昏迷患者目标体温管理实施率是指实施目标体温管理的复苏成功后昏迷患者例数占同期复苏成功后昏迷患者总例数的比例。', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映心脏骤停自主循环恢复后管理的规范性。',
    '手工填报', NULL, 'full', NULL, NULL,
    '本指标中目标体温管理是指对复苏成功后仍昏迷的患者实施体温控制，维持体温32℃-36℃至少24小时。', '同上。', '百分比（%）', '无', NULL,
    '就诊日期', '急诊科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（八）复苏成功后昏迷患者目标体温管理实施率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
