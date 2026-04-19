-- ===========================================
-- 3.21.7 （七）感染性腹泻患者口服补液盐（ORS）使用率
-- 数据源：手工填报；分子：使用口服补液盐（ORS）治疗的感染性腹泻患者例数，分母：同期行补液治疗的感染性腹泻患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%感染性疾病专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '使用口服补液盐（ORS）治疗的感染性腹泻患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映感染性腹泻患者ORS使用率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '根据WHO腹泻指南推荐，儿童腹泻患者和有轻中度脱水的成人腹泻患者优先使用口服补液，首选ORS。', '无', '无', '无', NULL,
    '统计日期', '全院', '使用口服补液盐（ORS）治疗的感染性腹泻患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.7.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '使用口服补液盐（ORS）治疗的感染性腹泻患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期行补液治疗的感染性腹泻患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '感染性疾病专业医疗质量控制指标（2023版）。', '反映感染性腹泻患者ORS使用率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期行补液治疗的感染性腹泻患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期行补液治疗的感染性腹泻患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.7.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期行补液治疗的感染性腹泻患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（七）感染性腹泻患者口服补液盐（ORS）使用率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '使用口服补液盐（ORS）治疗的感染性腹泻患者例数占同期行补液治疗的感染性腹泻患者总例数的比例。', '感染性疾病专业医疗质量控制指标（2023版）。', '反映感染性腹泻患者ORS使用情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：使用口服补液盐（ORS）治疗的感染性腹泻患者例数。分母：同期行补液治疗的感染性腹泻患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.21.7"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（七）感染性腹泻患者口服补液盐（ORS）使用率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
