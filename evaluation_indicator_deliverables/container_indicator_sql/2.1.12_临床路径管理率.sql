-- ===========================================
-- 2.1.12 临床路径管理率（三组指标，每组分子+分母+比率，共9个指标）
-- 编码：2.1.12.1（覆盖率）、2.1.12.1.1/2.1.12.1.2（分子/分母）；2.1.12.2（入组率）、2.1.12.2.1/2.1.12.2.2；2.1.12.3（完成率）、2.1.12.3.1/2.1.12.3.2
-- 覆盖率分母统一使用MR数据源（病案首页明细查询）
-- ===========================================

SET @ds_cp_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '临床路径医疗服务能力指标明细查询' AND INVALID = 0 LIMIT 1);
SET @ds_mr_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '病案首页明细查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @param_out = '{"p_date_type":"out"}';

-- ========== 第一组：覆盖率 2.1.12.1 ==========
-- 2.1.12.1.1 分子：实施临床路径管理的患者人数（临床路径数据源）
CALL sp_kpi_item_create(
    '实施临床路径管理的患者人数', @category_id, NULL, 'integer', 0, 'increase', 'value', @ds_cp_id, @param_out,
    '实施临床路径管理的患者人数，用于覆盖率分子。', '《2.1 医疗服务能力指标.csv》', '反映临床路径管理广度。',
    '临床路径医疗服务能力指标明细查询', NULL, 'full', NULL, '无',
    '分子：实施临床路径管理的患者人数。', '实施临床路径管理的患者人数', '无', NULL, '无',
    '出院日期', '科室名称', '实施临床路径管理人数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["住院号","住院次数","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.12.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @cov_num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实施临床路径管理的患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 2.1.12.1.2 分母：同期出院患者人数（MR数据源，统一口径）
CALL sp_kpi_item_create(
    '同期出院患者人数', @category_id, NULL, 'integer', 0, 'increase', 'value', @ds_mr_id, @param_out,
    '同期出院患者人数，用于临床路径覆盖率分母，统一使用MR数据源。', '《2.1 医疗服务能力指标.csv》', '反映出院规模。',
    '病案首页明细查询', NULL, 'full', NULL, '无',
    '分母：同期出院患者人数。', '同期出院患者人数', '无', NULL, '无',
    '出院日期', '出院科室名称', '出院人次数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.12.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @cov_den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者人数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 2.1.12.1 比率：临床路径管理率-覆盖率
CALL sp_kpi_item_create(
    '临床路径管理率-覆盖率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @ds_mr_id, @param_out,
    '实施临床路径管理的患者人数占医院同期出院患者人数的比例。', '《医疗机构临床路径管理指导原则》（国卫医发〔2017〕49号）', '反映临床路径管理广度。',
    '临床路径+病案首页', NULL, 'full', NULL, '无',
    '覆盖率=实施临床路径管理的患者人数/同期出院患者人数。分母统一使用MR数据源。', '临床路径覆盖率', '百分比（%）', NULL, '无',
    '出院日期', '出院科室名称', NULL, @cov_num_id, @cov_den_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.12.1"}]'), NULL, NULL, NULL, NULL
);

-- ========== 第二组：入组率 2.1.12.2 ==========
-- 2.1.12.2.1 分子：入组病例数（临床路径数据源）
CALL sp_kpi_item_create(
    '临床路径入组病例数', @category_id, NULL, 'integer', 0, 'increase', 'value', @ds_cp_id, @param_out,
    '实际进入临床路径管理的病例数。', '《2.1 医疗服务能力指标.csv》', '反映入组规模。',
    '临床路径医疗服务能力指标明细查询', NULL, 'full', NULL, '无',
    '分子：入组病例数。', '入组病例数', '无', NULL, '无',
    '出院日期', '科室名称', '入组病例数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["住院号","住院次数","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.12.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @entry_num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '临床路径入组病例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 2.1.12.2.2 分母：符合入组标准的病例数（临床路径数据源）
CALL sp_kpi_item_create(
    '临床路径符合入组标准的病例数', @category_id, NULL, 'integer', 0, 'increase', 'value', @ds_cp_id, @param_out,
    '符合入组标准的病例数，主要诊断与路径病种ICD-10编码匹配的病例。', '《2.1 医疗服务能力指标.csv》', '反映符合路径病种病例规模。',
    '临床路径医疗服务能力指标明细查询', NULL, 'full', NULL, '无',
    '分母：符合入组标准的病例数。', '符合入组标准的病例数', '无', NULL, '无',
    '出院日期', '科室名称', '符合入组标准病例数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["住院号","住院次数","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.12.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @entry_den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '临床路径符合入组标准的病例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 2.1.12.2 比率：临床路径管理率-入组率
CALL sp_kpi_item_create(
    '临床路径管理率-入组率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @ds_cp_id, @param_out,
    '实际进入临床路径管理的病例数占符合入组标准病例数的比例。', '《医疗机构临床路径管理指导原则》（国卫医发〔2017〕49号）', '反映入组率。',
    '临床路径医疗服务能力指标明细查询', NULL, 'full', NULL, '无',
    '入组率=入组病例数/符合入组标准的病例数。', '临床路径入组率', '百分比（%）', NULL, '无',
    '出院日期', '科室名称', NULL, @entry_num_id, @entry_den_id, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["住院号","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.12.2"}]'), NULL, NULL, NULL, NULL
);

-- ========== 第三组：完成率 2.1.12.3 ==========
-- 2.1.12.3.1 分子：完成路径病例数（临床路径数据源）
CALL sp_kpi_item_create(
    '临床路径完成路径病例数', @category_id, NULL, 'integer', 0, 'increase', 'value', @ds_cp_id, @param_out,
    '未退出的临床路径病例数，即完成路径的病例数。', '《2.1 医疗服务能力指标.csv》', '反映路径完成规模。',
    '临床路径医疗服务能力指标明细查询', NULL, 'full', NULL, '无',
    '分子：完成路径病例数。分母：入组病例总数。', '完成路径病例数', '无', NULL, '无',
    '出院日期', '科室名称', '完成路径病例数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["住院号","住院次数","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.12.3.1"}]'), NULL, NULL, NULL, NULL
);
SET @comp_num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '临床路径完成路径病例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 2.1.12.3.2 分母：入组病例总数（复用 2.1.12.2.1 入组病例数同一指标）
SET @comp_den_id = @entry_num_id;

-- 2.1.12.3 比率：临床路径管理率-完成率
CALL sp_kpi_item_create(
    '临床路径管理率-完成率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', @ds_cp_id, @param_out,
    '完成路径病例数占入组病例总数的比例。', '《医疗机构临床路径管理指导原则》（国卫医发〔2017〕49号）', '反映路径完成率。',
    '临床路径医疗服务能力指标明细查询', NULL, 'full', NULL, '无',
    '完成率=完成路径病例数/入组病例总数。分母与2.1.12.2.1入组病例数同口径。', '临床路径完成率', '百分比（%）', NULL, '无',
    '出院日期', '科室名称', NULL, @comp_num_id, @comp_den_id, NULL, NULL, 1.0000, 'sum',
    '["科室名称"]', '[]', '["住院号","出院日期"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.12.3"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE INVALID = 0 AND (KPI_NAME LIKE '临床路径管理率%' OR KPI_NAME IN ('实施临床路径管理的患者人数','同期出院患者人数','临床路径入组病例数','临床路径符合入组标准的病例数','临床路径完成路径病例数')) ORDER BY CREATE_TIME DESC LIMIT 10;
