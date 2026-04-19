-- ===========================================
-- 2.2.5 （五）住院患者出院后0-31天非预期再住院率
-- 数据源：住院患者出院后0-31天非预期再住院明细查询
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '住院患者出院后0-31天非预期再住院明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%住院质量与安全指标%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.5.1：住院患者出院后0-31天内非预期再住院患者人数
CALL sp_kpi_item_create(
    '住院患者出院后0-31天内非预期再住院患者人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '住院患者出院0-31天非预期再住院的患者人数之和。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '重返类指标，反映医院医疗质量。',
    '住院患者出院后0-31天非预期再住院明细查询', NULL, 'full', NULL, NULL,
    '分子：指住院患者出院0-31天非预期再住院的患者人数之和。分母：指同期出院患者总人次（除外死亡患者）。非预期再住院判定：同一医院、同一患者，第一次入院“是否31天再入院计划”为无或缺失；主要诊断亚目相同（前四位，不含小数点）。排除Z51.0、Z51.1、Z51.2、Z51.8。', '住院患者出院后0-31天内非预期再住院患者人数', '无', NULL, NULL,
    '出院日期', '出院科室名称', '住院患者出院后0_31天内非预期再住院患者人数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '住院患者出院后0-31天内非预期再住院患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.5.2：同期出院患者总人次（除死亡患者外）
CALL sp_kpi_item_create(
    '同期出院患者总人次（除死亡患者外）', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期出院患者总人次（除外死亡患者）。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '重返类指标，反映医院医疗质量。',
    '住院患者出院后0-31天非预期再住院明细查询', NULL, 'full', NULL, NULL,
    '分母：指同期出院患者总人次（除外死亡患者）。', '同期出院患者总人次（除死亡患者外）', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期出院患者总人次_除死亡患者外', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者总人次（除死亡患者外）' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.5：（五）住院患者出院后0-31天非预期再住院率
CALL sp_kpi_item_create(
    '（五）住院患者出院后0-31天非预期再住院率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '住院患者出院后0-31天非预期再住院率是指出院后0-31天非预期再住院患者人次占同期出院患者总人次（除死亡患者外）的比例。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '重返类指标，反映医院医疗质量。',
    '住院患者出院后0-31天非预期再住院明细查询', NULL, 'full', NULL, NULL,
    '分子：指住院患者出院0-31天非预期再住院的患者人数之和。分母：指同期出院患者总人次（除外死亡患者）。', '（五）住院患者出院后0-31天非预期再住院率', '百分比（%）', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.5"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（五）住院患者出院后0-31天非预期再住院率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
