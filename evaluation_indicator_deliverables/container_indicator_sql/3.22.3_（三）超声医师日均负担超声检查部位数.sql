-- ===========================================
-- 3.22.3 （三）超声医师日均负担超声检查部位数
-- 数据源：手工填报；单位：个；分子：超声检查部位总数，分母：同期超声医师岗位数×实际工作日
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%健康体检与管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '超声检查部位总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映超声医师日均负担超声检查部位数分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '超声检查部位包括：甲状腺、乳腺、腹部(肝胆胰脾)、泌尿系(双肾、输尿管、膀胱、前列腺(男性))、子宫及附件(女性)、颈动脉、心脏等。', '无', '无', '无', NULL,
    '统计日期', '全院', '超声检查部位总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '超声检查部位总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期超声医师岗位数×实际工作日', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映超声医师日均负担超声检查部位数分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期超声医师岗位数×实际工作日。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期超声医师岗位数×实际工作日',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.3.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期超声医师岗位数×实际工作日' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（三）超声医师日均负担超声检查部位数', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '超声医师日均负担超声检查部位数。', '健康体检与管理专业医疗质量控制指标（2023版）。', '反映超声医师日均工作量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：超声检查部位总数。分母：同期超声医师岗位数×实际工作日。', '无', '个', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.22.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（三）超声医师日均负担超声检查部位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
