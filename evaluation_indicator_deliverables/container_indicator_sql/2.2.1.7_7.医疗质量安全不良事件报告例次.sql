-- ===========================================
-- 2.2.1.7 医疗质量安全不良事件报告例次（床均 + 每百名出院人次）（手工填报）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- ========== 2.2.1.7.1 床均医疗质量安全不良事件报告例次 ==========
-- 分子 2.2.1.7.1.1
CALL sp_kpi_item_create(
    '医疗质量安全不良事件报告例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, NULL,
    '医疗机构实际发生的医疗质量安全不良事件例数之和。', '《2.2.1 年度安全目标.csv》', '分子：指医疗机构实际发生的医疗质量安全不良事件例数之和。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指医疗机构实际发生的医疗质量安全不良事件例数之和。分母：同期实际开放床位数。', '医疗质量安全不良事件报告例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.7.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_711_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗质量安全不良事件报告例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.7.1.2
CALL sp_kpi_item_create(
    '同期实际开放床位数', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, NULL,
    '《国家卫生健康统计调查制度》中开放床位数：医院目前实际开放的床位，即实有床位数。', '《2.2.1 年度安全目标.csv》', '分母：指同期实际开放床位数。',
    NULL, NULL, 'full', NULL, NULL,
    '开放床位数指年底固定实有床位，包括正规床、简易床、监护床、超过半年加床、正在消毒和修理的床位、因扩建或大修而停用的床位。不包括产科新生儿床、接产室待产床、库存床、观察床、临时加床和病人家属陪侍床。', '同期实际开放床位数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.7.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_712_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期实际开放床位数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.7.1 床均医疗质量安全不良事件报告例次（单位：例次）
CALL sp_kpi_item_create(
    '床均医疗质量安全不良事件报告例次', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, NULL,
    '医疗质量安全不良事件是指在医疗机构内被工作人员主动发现，或患者在接受诊疗服务过程中出现的，除了患者自身疾病自然过程之外的各种因素所致的不安全隐患、状态或造成后果的负性事件。床均报告例次 = 不良事件报告例数/同期实际开放床位数。', '《2.2.1 年度安全目标.csv》', '加强医疗质量安全不良事件报告工作，提高识别和报告率，对构建医疗机构医疗质量安全文化和学习平台、提升医疗质量安全水平具有重要意义。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指医疗机构实际发生的医疗质量安全不良事件例数之和。分母：指同期实际开放床位数。', '床均医疗质量安全不良事件报告例次', '例次', NULL, '无',
    NULL, NULL, NULL, @num_711_id, @den_712_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.7.1"}]'), NULL, NULL, NULL, NULL
);

-- ========== 2.2.1.7.2 每百名出院人次医疗质量安全不良事件报告例次 ==========
-- 分子 2.2.1.7.2.1（与 7.1.1 同名，新建一条以区分编码 2.2.1.7.2.1）
CALL sp_kpi_item_create(
    '医疗质量安全不良事件报告例数_每百名', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, NULL,
    '医疗机构实际发生的医疗质量安全不良事件例数之和（用于每百名出院人次指标）。', '《2.2.1 年度安全目标.csv》', '分子：指医疗机构实际发生的医疗质量安全不良事件例数之和。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指医疗机构实际发生的医疗质量安全不良事件例数之和。分母：指同期出院患者总人次。', '医疗质量安全不良事件报告例数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.7.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @num_721_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗质量安全不良事件报告例数_每百名' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.7.2.2
CALL sp_kpi_item_create(
    '同期出院患者人次_不良事件', @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, NULL,
    '同期出院患者人次（用于每百名出院人次不良事件报告例次分母）。', '《2.2.1 年度安全目标.csv》', '分母：指同期出院患者总人次。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期出院患者总人次。', '同期出院患者人次', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.7.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @den_722_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者人次_不良事件' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.7.2 每百名出院人次医疗质量安全不良事件报告例次（例次，= 分子/分母*100）
CALL sp_kpi_item_create(
    '每百名出院人次医疗质量安全不良事件报告例次', @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, NULL,
    '每百名出院人次医疗质量安全不良事件报告例次 = 医疗质量安全不良事件报告例数/同期出院患者人次×100。', '《2.2.1 年度安全目标.csv》', '加强医疗质量安全不良事件报告工作，提高识别和报告率。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指医疗机构实际发生的医疗质量安全不良事件例数之和。分母：指同期出院患者总人次。', '每百名出院人次医疗质量安全不良事件报告例次', '例次', NULL, '无',
    NULL, NULL, NULL, @num_721_id, @den_722_id, NULL, NULL, 100.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.7.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME IN ('床均医疗质量安全不良事件报告例次','每百名出院人次医疗质量安全不良事件报告例次') AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 2;
