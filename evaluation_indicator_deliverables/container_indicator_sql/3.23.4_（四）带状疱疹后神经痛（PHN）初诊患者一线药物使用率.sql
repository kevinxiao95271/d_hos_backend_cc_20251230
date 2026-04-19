-- ===========================================
-- 3.23.4 （四）带状疱疹后神经痛（PHN）初诊患者一线药物使用率
-- 数据源：手工填报；分子：使用一线药物进行治疗的PHN初诊患者数，分母：同期PHN初诊患者总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%疼痛专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '使用一线药物进行治疗的PHN初诊患者数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映PHN初诊患者一线药物使用率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    'PHN一线治疗药物指按《周围神经病理性疼痛诊疗中国专家共识》《带状疱疹相关性疼痛全程管理专家共识》等推荐作为PHN治疗首选的药物，如钙离子通道调节剂、钠离子通道阻断剂和抗抑郁药等。初诊指患者在医疗机构首次被诊断为带状疱疹后神经痛。', '无', '无', '无', NULL,
    '统计日期', '全院', '使用一线药物进行治疗的PHN初诊患者数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.4.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '使用一线药物进行治疗的PHN初诊患者数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期PHN初诊患者总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '疼痛专业医疗质量控制指标（2023版）。', '反映PHN初诊患者一线药物使用率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期PHN初诊患者总数。PHN指急性带状疱疹皮疹愈合30天后仍遗留有累及区域疼痛，诊断编码B02.2。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期PHN初诊患者总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.4.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期PHN初诊患者总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（四）带状疱疹后神经痛（PHN）初诊患者一线药物使用率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '使用一线药物进行治疗的PHN初诊患者数占同期PHN初诊患者总数的比例。', '疼痛专业医疗质量控制指标（2023版）。', '反映PHN初诊患者一线药物使用情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：使用一线药物进行治疗的PHN初诊患者数。分母：同期PHN初诊患者总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.23.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）带状疱疹后神经痛（PHN）初诊患者一线药物使用率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
