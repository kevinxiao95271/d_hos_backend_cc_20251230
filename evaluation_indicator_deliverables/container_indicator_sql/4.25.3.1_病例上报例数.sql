-- 4.25.3.1 病例上报例数（发育性髋关节发育不良，手术治疗）
SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '单病种病例上报查询' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE (CATEGORY_NAME LIKE '%发育性髋关节发育不良%' OR CATEGORY_NAME LIKE '%DDH%') AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{"p_disease_code":"4.25"}';

SET @kpi_name = '发育性髋关节发育不良（手术治疗）病例上报例数';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param,
    '报告至国家单病种质量监测平台的发育性髋关节发育不良（手术治疗）病例数', '《单病种系统接口规范》', '反映单病种病例向国家平台上报情况',
    '单病种病例上报查询', NULL, 'full', NULL, NULL, '指报告至国家单病种质量监测平台的病例数。', '例', '无', NULL, NULL,
    '出院日期', NULL, '病例上报例数', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '["病种编码","统计年份","统计月份","病例上报例数"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"4.25.3.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
