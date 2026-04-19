-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.12.2
-- 指标名称：自体器官移植术成功率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '自体器官移植技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '自体器官移植术成功的例数';
SET @numerator_category_code = '5.1.12.2.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '自体器官移植术成功是指通过自体器官移植手术达到预期目标病灶彻底清除，预留器官脉管可靠修复及重建，再植后预留器官血流和功能正常。自体器官移植术成功率是指自体器官移植术成功的例数占同期自体器官移植术总例数的比例。', '《自体器官移植技术临床应用管理规范（2022 版）》《自体器官移植技术临床应用质量控制指标（2022 版）》。', '反映医院自体器官移植技术水平。',
    '自体器官移植技术数据源', NULL, '分子：是指医院实施自体器官移植技术成功的例数。 分母：是指同期医院实施自体器官移植技术的总例数。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成自体器官移植术成功', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.12.2.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期自体器官移植术总例数';
SET @denominator_category_code = '5.1.12.2.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '自体器官移植术成功是指通过自体器官移植手术达到预期目标病灶彻底清除，预留器官脉管可靠修复及重建，再植后预留器官血流和功能正常。自体器官移植术成功率是指自体器官移植术成功的例数占同期自体器官移植术总例数的比例。', '《自体器官移植技术临床应用管理规范（2022 版）》《自体器官移植技术临床应用质量控制指标（2022 版）》。', '反映医院自体器官移植技术水平。',
    '自体器官移植技术数据源', NULL, '分子：是指医院实施自体器官移植技术成功的例数。 分母：是指同期医院实施自体器官移植技术的总例数。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成自体器官移植术成功', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.12.2.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '自体器官移植术成功率';
SET @category_code = '5.1.12.2';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'increase', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '自体器官移植术成功是指通过自体器官移植手术达到预期目标病灶彻底清除，预留器官脉管可靠修复及重建，再植后预留器官血流和功能正常。自体器官移植术成功率是指自体器官移植术成功的例数占同期自体器官移植术总例数的比例。', '《自体器官移植技术临床应用管理规范（2022 版）》《自体器官移植技术临床应用质量控制指标（2022 版）》。', '反映医院自体器官移植技术水平。',
    '自体器官移植技术数据源', NULL, '分子：是指医院实施自体器官移植技术成功的例数。 分母：是指同期医院实施自体器官移植技术的总例数。', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.12.2"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
