-- 4.56.2 医院单病种报告病例数占出院病人之比（单病种医院报告总体情况评价）
-- 分子 4.56.2.1：报告至国家单病种质量监测平台的各病种病例数之和；分母 4.56.2.2：同期医院出院患者总数（HQMS病案首页）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '单病种病例上报查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%单病种%' AND CATEGORY_NAME LIKE '%总体%' AND INVALID = 0 LIMIT 1);
SET @cat_id = IF(@cat_id IS NULL, (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%单病种%' AND INVALID = 0 LIMIT 1), @cat_id);
SET @user = 'system';
SET @param = '{}';

SET @num_name = '报告至国家单病种质量监测平台的各病种病例数之和';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '单位时间内报告至国家单病种质量监测平台的各病种报告病例数之和', '《单病种系统接口规范》', '反映医院单病种报告病例总量',
    '单病种病例上报查询', NULL, 'full', NULL, NULL, '分子：各病种报告病例数之和。分母：同期医院出院患者总数。', '无', '无', NULL, NULL,
    '统计月份', NULL, '病例上报例数之和', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '["统计年份","统计月份","病例上报例数之和"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.56.2.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期医院出院患者总数_4.56.2';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期医院出院患者总数（数据来源于HQMS病案首页）', '《单病种系统接口规范》', '反映医院同期出院规模',
    '单病种病例上报查询', NULL, 'full', NULL, NULL, '分子：各病种报告病例数之和。分母：同期医院出院患者总数。', '无', '无', NULL, NULL,
    '统计月份', NULL, '出院患者总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '["统计年份","统计月份","出院患者总数"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.56.2.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '医院单病种报告病例数占出院病人之比';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '报告至国家单病种质量监测平台的各病种病例数之和占同期医院出院患者总数的比例', '《单病种系统接口规范》', '评价医院单病种报告的总体数量，反映此项工作的总体管理情况',
    '单病种病例上报查询', NULL, 'full', NULL, NULL, '分子：各病种报告病例数之和。分母：同期医院出院患者总数（HQMS病案首页）。', '百分比（%）', '无', NULL, NULL,
    '统计月份', NULL, NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '["统计年份","统计月份"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.56.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
