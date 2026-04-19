-- ===========================================
-- 3.24.1 （一）整形美容手术1类切口围手术期预防性抗生素使用率
-- 数据源：手工填报；分子：整形美容手术I类切口围手术期预防性抗生素使用患者例数，分母：同期整形美容手术I类切口患者总例数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%整形美容专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '整形美容手术I类切口围手术期预防性抗生素使用患者例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '整形美容专业医疗质量控制指标（2023版）。', '反映整形美容手术I类切口围手术期预防性抗生素使用率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    'I类切口手术包括：重睑术、睑袋成形术、脂肪抽吸术、吸脂填充术、面部提拉术、假体隆乳术、乳房再造术、体表良恶性肿瘤切除术、瘢痕修整术、毛发移植术。抗菌药物使用方式包括口服、肌肉注射、静脉滴注、静脉注射等全身给药。', '无', '无', '无', NULL,
    '统计日期', '全院', '整形美容手术I类切口围手术期预防性抗生素使用患者例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.24.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '整形美容手术I类切口围手术期预防性抗生素使用患者例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期整形美容手术I类切口患者总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '整形美容专业医疗质量控制指标（2023版）。', '反映整形美容手术I类切口围手术期预防性抗生素使用率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期整形美容手术I类切口患者总例数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期整形美容手术I类切口患者总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.24.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期整形美容手术I类切口患者总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）整形美容手术1类切口围手术期预防性抗生素使用率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '整形美容手术I类切口围手术期预防性抗生素使用患者例数占同期整形美容手术I类切口患者总例数的比例。', '整形美容专业医疗质量控制指标（2023版）。', '反映整形美容手术I类切口围手术期预防性抗生素使用情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：整形美容手术I类切口围手术期预防性抗生素使用患者例数。分母：同期整形美容手术I类切口患者总例数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.24.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）整形美容手术1类切口围手术期预防性抗生素使用率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
