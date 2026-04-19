-- ===========================================
-- 3.53.1 （一）急诊科医患比
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '急诊科固定在岗（本院）医师总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》《全国医疗卫生服务体系规划纲要》。', '反映医疗机构急诊科医师资源配置情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：急诊科固定在岗（本院）医师数。分母：急诊科接诊患者总数（万人次）。', '分子：急诊科固定在岗（本院）医师数。分母：急诊科接诊患者总数（万人次）。', '无', '无', NULL,
    '就诊日期', '急诊科', '急诊科固定在岗（本院）医师总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '急诊科固定在岗（本院）医师总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期急诊科接诊患者总数（万人次）', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '《急诊医学专业医疗质量控制指标（2024 年版）》《全国医疗卫生服务体系规划纲要》。', '反映医疗机构急诊科医师资源配置情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：急诊科固定在岗（本院）医师数。分母：急诊科接诊患者总数（万人次）。', '分子：急诊科固定在岗（本院）医师数。分母：急诊科接诊患者总数（万人次）。', '无', '无', NULL,
    '就诊日期', '急诊科', '同期急诊科接诊患者总数（万人次）',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期急诊科接诊患者总数（万人次）' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）急诊科医患比', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '急诊科固定在岗（本院）医师总数占同期急诊科接诊患者总数（万人次）的比例。', '《急诊医学专业医疗质量控制指标（2024 年版）》《全国医疗卫生服务体系规划纲要》。', '反映医疗机构急诊科医师资源配置情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：急诊科固定在岗（本院）医师数。分母：急诊科接诊患者总数（万人次）。', '分子：急诊科固定在岗（本院）医师数。分母：急诊科接诊患者总数（万人次）。', '比值（X∶1）', '无', NULL,
    '就诊日期', '急诊科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）急诊科医患比' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
