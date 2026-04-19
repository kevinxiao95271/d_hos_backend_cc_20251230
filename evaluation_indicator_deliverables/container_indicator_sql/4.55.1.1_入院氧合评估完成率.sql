-- 4.55.1.1 入院氧合评估完成率（急性肺血栓栓塞症）
-- 说明：分母编码 4.55.1.1.2（同期急性肺血栓栓塞症患者总数）为 4.55.1 及资源消耗 4.55.2 统一源分母；
--       4.55.1.2.2、4.55.1.3.2、4.55.2.1.2、4.55.2.2.2 等与本章要求一致的指标分母，注册脚本中采集源于本指标。
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-急性肺血栓栓塞症质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急性肺血栓栓塞症%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'PTE入院完成氧合评估患者数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '入院完成氧合评估患者数', '无', '反映PTE氧合评估规范性', '第四章-急性肺血栓栓塞症质量控制查询', NULL, 'full', NULL, NULL, '分子：入院完成氧合评估患者数。分母：同期急性肺血栓栓塞症患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '入院完成氧合评估患者数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.55.1.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期PTE患者总数_4.55.1.1';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期急性肺血栓栓塞症患者总数', '无', '反映PTE氧合评估规范性', '第四章-急性肺血栓栓塞症质量控制查询', NULL, 'full', NULL, NULL, '分子：入院完成氧合评估患者数。分母：同期急性肺血栓栓塞症患者总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期急性肺血栓栓塞症患者总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.55.1.1.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = '入院氧合评估完成率';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    '入院完成氧合评估患者数占同期急性肺血栓栓塞症患者总数的比例', '无', '反映PTE氧合评估规范性', '第四章-急性肺血栓栓塞症质量控制查询', NULL, 'full', NULL, NULL, '分子：入院完成氧合评估患者数。分母：同期急性肺血栓栓塞症患者总数。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.55.1.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
