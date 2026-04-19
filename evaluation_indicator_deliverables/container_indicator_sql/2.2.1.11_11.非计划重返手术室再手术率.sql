-- ===========================================
-- 2.2.1.11 非计划重返手术室再手术率（48小时内 + 31天内）（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- ========== 2.2.1.11.1 手术患者术后48小时内非预期重返手术室再次手术率 ==========
-- 分子 2.2.1.11.1.1
CALL sp_kpi_item_create(
    '手术患者48小时内非计划重返手术室再次手术的人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '术后48小时（2天）以内非计划重返手术室再次手术人数。', '《2.2.1 年度安全目标.csv》', '分子：指术后48小时（2天）以内非计划重返手术室再次手术人数。',
    NULL, NULL, 'full', NULL, NULL,
    '手术患者非计划重返手术室再次手术判定（同时满足）：①同一医院，同一患者，同一次住院中；②手术后非计划重返手术室进行第二次或两次以上手术的；③排除诊疗计划中已确认计划分期手术者除外。分母：指同期出院患者手术例数。', '手术患者48小时内非计划重返手术室再次手术的人数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.11.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_1111_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '手术患者48小时内非计划重返手术室再次手术的人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.11.1.2
CALL sp_kpi_item_create(
    '同期出院患者手术例数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '同期出院患者手术例数。', '《2.2.1 年度安全目标.csv》', '分母：指同期出院患者手术例数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期出院患者手术例数。', '同期出院患者手术例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.11.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_1112_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者手术例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.11.1
CALL sp_kpi_item_create(
    '手术患者术后48小时内非预期重返手术室再次手术率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', NULL, NULL,
    '手术患者术后48小时内非预期重返手术室再次手术率是指手术患者手术后48小时（2天）内因各种原因导致患者需进行的计划外再次手术占同期出院患者手术例数的比例。', '《2.2.1 年度安全目标.csv》', '反映手术质量与围术期管理。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指术后48小时（2天）以内非计划重返手术室再次手术人数。分母：指同期出院患者手术例数。', '手术患者术后48小时内非预期重返手术室再次手术率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_1111_id, @den_1112_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.11.1"}]'), NULL, NULL, NULL, NULL
);

-- ========== 2.2.1.11.2 手术患者术后31天内非预期重返手术室再次手术率 ==========
-- 分子 2.2.1.11.2.1
CALL sp_kpi_item_create(
    '手术患者31天内非计划重返手术室再次手术的人数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '术后31天以内非计划重返手术室再次手术人数。', '《2.2.1 年度安全目标.csv》', '分子：指术后31天以内非计划重返手术室再次手术人数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指术后31天以内非计划重返手术室再次手术人数，为术后48小时以内与术后3-31天非计划重返手术室再次手术人数之和。分母：指同期出院患者手术例数。', '手术患者31天内非计划重返手术室再次手术的人数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.11.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_1121_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '手术患者31天内非计划重返手术室再次手术的人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.11.2.2 与 11.1.2 相同概念，新建一条以区分编码
CALL sp_kpi_item_create(
    '同期出院患者手术例数_31天', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '同期出院患者手术例数（用于31天内重返手术室率分母）。', '《2.2.1 年度安全目标.csv》', '分母：指同期出院患者手术例数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期出院患者手术例数。', '同期出院患者手术例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.11.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_1122_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者手术例数_31天' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.11.2
CALL sp_kpi_item_create(
    '手术患者术后31天内非预期重返手术室再次手术率', @category_id, NULL, 'percent', 2, 'decrease', 'ratio', NULL, NULL,
    '手术患者术后31天内非预期重返手术室再次手术率是指手术患者手术后31天内因各种原因导致患者需进行的计划外再次手术占同期出院患者手术例数的比例。', '《2.2.1 年度安全目标.csv》', '反映手术质量与围术期管理。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指术后31天以内非计划重返手术室再次手术人数。分母：指同期出院患者手术例数。', '手术患者术后31天内非预期重返手术室再次手术率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @num_1121_id, @den_1122_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.11.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME IN ('手术患者术后48小时内非预期重返手术室再次手术率','手术患者术后31天内非预期重返手术室再次手术率') AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 2;
