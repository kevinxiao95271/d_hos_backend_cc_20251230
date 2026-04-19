-- ===========================================
-- 3.25.4 （四）轻中度自发性脑出血患者紧急降压有效率
-- 数据源：手工填报；分子：行紧急降压治疗后有效缓解的轻中度自发性脑出血患者例数，分母：同期行紧急降压治疗的轻中度自发性脑出血患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%脑损伤评价%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '行紧急降压治疗后有效缓解的轻中度自发性脑出血患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', 'continuous_monitor', @data_source_id, @data_source_param,
    '无', '脑损伤评价医疗质量控制指标（2024版）。', '反映轻中度自发性脑出血患者紧急降压有效率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '轻中度指GCS评分≥5分。紧急降压指收缩压150～220mmHg者在脑出血发生后2小时内开始连续静脉用药。有效缓解指降压治疗1小时内收缩压降至140mmHg目标并住院期间维持在130～150mmHg。', '无', '无', '无', NULL,
    '统计日期', '全院', '行紧急降压治疗后有效缓解的轻中度自发性脑出血患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '行紧急降压治疗后有效缓解的轻中度自发性脑出血患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期行紧急降压治疗的轻中度自发性脑出血患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', 'continuous_monitor', @data_source_id, @data_source_param,
    '无', '脑损伤评价医疗质量控制指标（2024版）。', '反映轻中度自发性脑出血患者紧急降压有效率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期行紧急降压治疗的轻中度自发性脑出血患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期行紧急降压治疗的轻中度自发性脑出血患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期行紧急降压治疗的轻中度自发性脑出血患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）轻中度自发性脑出血患者紧急降压有效率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', 'continuous_monitor', @data_source_id, @data_source_param,
    '行紧急降压治疗后有效缓解的轻中度自发性脑出血患者例数占同期行紧急降压治疗的轻中度自发性脑出血患者总例数的比例。', '脑损伤评价医疗质量控制指标（2024版）。', '反映轻中度自发性脑出血患者紧急降压治疗有效率。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：行紧急降压治疗后有效缓解的轻中度自发性脑出血患者例数。分母：同期行紧急降压治疗的轻中度自发性脑出血患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.25.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）轻中度自发性脑出血患者紧急降压有效率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
