-- ===========================================
-- 3.15.9 （九）超声筛查中胎儿重大致死性畸形的检出率
-- 数据源：手工填报；分子：超声筛查中检出胎儿重大致死性畸形的孕妇人数，分母：同期超声产检的孕妇总人数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%超声诊断专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '单位时间内超声筛查中检出胎儿重大致死性畸形的孕妇人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '超声诊断专业医疗质量控制指标（2022版）。', '反映超声筛查胎儿重大致死性畸形检出率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '胎儿重大致死性畸形包括无脑儿、严重脑膨出、严重的开放性脊柱裂、严重的胸腹壁缺损内脏外翻、单腔心、致死性软骨发育不全。按孕妇人数统计，同一孕妇多次超声按1人次。', '无', '无', '无', NULL,
    '统计日期', '全院', '单位时间内超声筛查中检出胎儿重大致死性畸形的孕妇人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.15.9.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '单位时间内超声筛查中检出胎儿重大致死性畸形的孕妇人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期超声产检的孕妇总人数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '超声诊断专业医疗质量控制指标（2022版）。', '反映超声筛查胎儿重大致死性畸形检出率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期超声产检的孕妇总人数。本指标仅适用于提供产检服务的医疗机构。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期超声产检的孕妇总人数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.15.9.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期超声产检的孕妇总人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（九）超声筛查中胎儿重大致死性畸形的检出率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '单位时间内，在超声筛查中检出胎儿重大致死性畸形的孕妇人数，占同期超声产检的孕妇总人数的比例。', '超声诊断专业医疗质量控制指标（2022版）。', '反映产前超声筛查质量。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：单位时间内超声筛查中检出胎儿重大致死性畸形的孕妇人数。分母：同期超声产检的孕妇总人数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.15.9"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（九）超声筛查中胎儿重大致死性畸形的检出率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
