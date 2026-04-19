-- 4.22.1.1 初始治疗的规范率（哮喘儿童，急性发作住院）
-- 说明：分母编码 4.22.1.1.2（同期支气管哮喘急性发作出院患儿总例数）为 4.22.1 小节统一源分母；
--       4.22.1.2.2、4.22.1.3.2、4.22.2.1.2、4.22.2.2.2 与上述口径一致，注册脚本中采集源于本指标。
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-哮喘（儿童，急性发作住院）质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%哮喘%' AND CATEGORY_NAME LIKE '%儿童%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = '哮喘儿童接受规范初始治疗患儿数_4.22.1.1';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '接受规范初始治疗的患儿数', '无', '反映儿童支气管哮喘急性发作治疗的规范性', '第四章-哮喘（儿童，急性发作住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：入院接受规范初始治疗的患儿数。分母：同期支气管哮喘急性发作的出院患儿总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '接受规范初始治疗的患儿数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.22.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期支气管哮喘急性发作出院患儿总例数_4.22.1.1';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期支气管哮喘急性发作出院患儿总例数', '无', '反映儿童支气管哮喘急性发作治疗的规范性', '第四章-哮喘（儿童，急性发作住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：入院接受规范初始治疗的患儿数。分母：同期支气管哮喘急性发作的出院患儿总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期支气管哮喘急性发作的出院患儿总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.22.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '初始治疗的规范率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '入院接受规范初始治疗的患儿数占同期支气管哮喘急性发作出院患儿总数的比例', '无', '反映儿童支气管哮喘急性发作治疗的规范性', '第四章-哮喘（儿童，急性发作住院）质量控制查询', NULL, 'full', NULL, NULL, '分子：入院接受规范初始治疗的患儿数。分母：同期支气管哮喘急性发作的出院患儿总数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.22.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
