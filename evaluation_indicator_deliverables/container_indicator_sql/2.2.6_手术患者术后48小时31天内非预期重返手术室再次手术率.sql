-- ===========================================
-- 2.2.6.1 手术患者术后48小时内非预期重返手术室再次手术率
-- 2.2.6.2 手术患者术后31天内非预期重返手术室再次手术率
-- 数据源：手术患者术后48小时31天内非预期重返手术室明细查询
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手术患者术后48小时31天内非预期重返手术室明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%住院质量与安全指标%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- ========== 2.2.6.1 ==========
-- 分子 2.2.6.1.1：手术患者48小时内非计划重返手术室再次手术的人数
CALL sp_kpi_item_create(
    '手术患者48小时内非计划重返手术室再次手术的人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '术后48小时（2天）以内非计划重返手术室再次手术人数。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '重返类指标，反映医院医疗质量。',
    '手术患者术后48小时31天内非预期重返手术室明细查询', NULL, 'full', NULL, NULL,
    '分子：指术后48小时（2天）以内非计划重返手术室再次手术人数。分母：指同期出院患者手术例数。', '手术患者48小时内非计划重返手术室再次手术的人数', '无', NULL, NULL,
    '出院日期', '出院科室名称', '手术患者48小时内非计划重返手术室再次手术的人数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.6.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_48_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '手术患者48小时内非计划重返手术室再次手术的人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.6.1.2：同期出院患者手术例数
CALL sp_kpi_item_create(
    '同期出院患者手术例数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期出院患者手术例数。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '重返类指标，反映医院医疗质量。',
    '手术患者术后48小时31天内非预期重返手术室明细查询', NULL, 'full', NULL, NULL,
    '分母：指同期出院患者手术例数。', '同期出院患者手术例数', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期出院患者手术例数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.6.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denom_62_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者手术例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.6.1
CALL sp_kpi_item_create(
    '1.手术患者术后48小时内非预期重返手术室再次手术率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '手术患者术后48小时内非预期重返手术室再次手术率是指手术患者手术后48小时（2天）内因各种原因导致患者需进行的计划外再次手术占同期出院患者手术例数的比例。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '重返类指标，反映医院医疗质量。',
    '手术患者术后48小时31天内非预期重返手术室明细查询', NULL, 'full', NULL, NULL,
    '分子：指术后48小时（2天）以内非计划重返手术室再次手术人数。分母：指同期出院患者手术例数。', '1.手术患者术后48小时内非预期重返手术室再次手术率', '百分比（%）', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_48_id, @denom_62_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.6.1"}]'), NULL, NULL, NULL, NULL
);

-- ========== 2.2.6.2 ==========
-- 分子 2.2.6.2.1：手术患者31天内非计划重返手术室再次手术的人数
CALL sp_kpi_item_create(
    '手术患者31天内非计划重返手术室再次手术的人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '术后31天以内非计划重返手术室再次手术人数。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '重返类指标，反映医院医疗质量。',
    '手术患者术后48小时31天内非预期重返手术室明细查询', NULL, 'full', NULL, NULL,
    '分子：指术后31天以内非计划重返手术室再次手术人数。分母：指同期出院患者手术例数。', '手术患者31天内非计划重返手术室再次手术的人数', '无', NULL, NULL,
    '出院日期', '出院科室名称', '手术患者31天内非计划重返手术室再次手术的人数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.6.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_31_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '手术患者31天内非计划重返手术室再次手术的人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.6.2.2 与 2.2.6.1.2 同口径，单独注册以便 category_code 为 2.2.6.2.2
CALL sp_kpi_item_create(
    '同期出院患者手术例数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '同期出院患者手术例数。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '重返类指标，反映医院医疗质量。',
    '手术患者术后48小时31天内非预期重返手术室明细查询', NULL, 'full', NULL, NULL,
    '分母：指同期出院患者手术例数。', '同期出院患者手术例数', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期出院患者手术例数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.6.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denom_62_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者手术例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.6.2
CALL sp_kpi_item_create(
    '2.手术患者术后31天内非预期重返手术室再次手术率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '手术患者术后31天内非预期重返手术室再次手术率是指手术患者手术后31天内因各种原因导致患者需进行的计划外再次手术占同期出院患者手术例数的比例。', '《三级综合医院医疗质量管理与控制指标（2011年版）》及国家医疗质量管理与控制信息网（NCIS）。', '重返类指标，反映医院医疗质量。',
    '手术患者术后48小时31天内非预期重返手术室明细查询', NULL, 'full', NULL, NULL,
    '分子：指术后31天以内非计划重返手术室再次手术人数。分母：指同期出院患者手术例数。', '2.手术患者术后31天内非预期重返手术室再次手术率', '百分比（%）', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_31_id, @denom_62_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["主键ID","住院号","病案号","患者姓名","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.6.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID, KPI_NAME, KPI_TYPE FROM KPI_ITEM WHERE KPI_NAME IN ('1.手术患者术后48小时内非预期重返手术室再次手术率','2.手术患者术后31天内非预期重返手术室再次手术率') AND INVALID = 0 ORDER BY KPI_NAME, CREATE_TIME DESC;
