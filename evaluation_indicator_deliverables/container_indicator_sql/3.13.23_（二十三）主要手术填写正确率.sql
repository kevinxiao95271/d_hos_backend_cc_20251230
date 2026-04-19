-- ===========================================
-- 3.13.23 （二十三）主要手术填写正确率
-- 数据源：手工填报；分子：病案首页中主要手术填写正确的出院患者病历数，分母：同期出院手术患者病历总数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%病案管理%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '病案首页中主要手术填写正确的出院患者病历数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映主要手术填写正确率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '主要手术操作填写符合《卫生部关于修订住院病案首页的通知》《住院病案首页数据填写质量规范（暂行）》相关要求。', '无', '无', '无', NULL,
    '统计日期', '全院', '病案首页中主要手术填写正确的出院患者病历数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.23.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '病案首页中主要手术填写正确的出院患者病历数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期出院手术患者病历总数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '病案管理质量控制指标（2021版）。', '反映主要手术填写正确率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期出院手术患者病历总数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期出院手术患者病历总数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.23.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院手术患者病历总数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（二十三）主要手术填写正确率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，病案首页中主要手术填写正确的出院患者病历数占同期出院手术患者病历总数的比例。', '病案管理质量控制指标（2021版）。', '反映病案首页主要手术填写质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：病案首页中主要手术填写正确的出院患者病历数。分母：同期出院手术患者病历总数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.13.23"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（二十三）主要手术填写正确率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
