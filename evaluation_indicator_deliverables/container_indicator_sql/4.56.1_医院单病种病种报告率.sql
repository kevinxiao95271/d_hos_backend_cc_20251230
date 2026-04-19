-- 4.56.1 医院单病种病种报告率（单病种医院报告总体情况评价）
-- 分子 4.56.1.1：报告至国家单病种质量监测平台的病种数；分母 4.56.1.2：医院应当报告的病种数
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '单病种病例上报查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%单病种%' AND CATEGORY_NAME LIKE '%总体%' AND INVALID = 0 LIMIT 1);
SET @cat_id = IF(@cat_id IS NULL, (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%单病种%' AND INVALID = 0 LIMIT 1), @cat_id);
SET @user = 'system';
SET @param = '{}';

SET @num_name = '报告至国家单病种质量监测平台的病种数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '报告至国家单病种质量监测平台的病种数（报告例数≥1或按平台规则的病种数）', '《单病种系统接口规范》', '反映医院实际报告病种数量',
    '单病种病例上报查询', NULL, 'full', NULL, NULL, '分子：报告至国家单病种质量监测平台的病种数。分母：医院应当报告的病种数。', '无', '无', NULL, NULL,
    '统计月份', NULL, '报告病种数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '["统计年份","统计月份","报告病种数"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.56.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '医院应当报告的病种数_4.56.1';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '根据医院执业许可证诊疗科目登记范围核定的应报病种数', '《单病种系统接口规范》', '反映医院应报告病种范围',
    '单病种病例上报查询', NULL, 'full', NULL, NULL, '分子：报告至国家单病种质量监测平台的病种数。分母：医院应当报告的病种数。', '无', '无', NULL, NULL,
    '统计月份', NULL, '应当报告病种数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '["统计年份","统计月份","应当报告病种数"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.56.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '医院单病种病种报告率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '报告至国家单病种质量监测平台的病种数占医院应当报告病种数的比例', '《单病种系统接口规范》', '评价医院单病种报告病种数量',
    '单病种病例上报查询', NULL, 'full', NULL, NULL, '分子：报告至国家单病种质量监测平台的病种数。分母：医院应当报告的病种数（根据执业许可证诊疗科目核定）。', '百分比（%）', '无', NULL, NULL,
    '统计月份', NULL, NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '["统计年份","统计月份"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.56.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
