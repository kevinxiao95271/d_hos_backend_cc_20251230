-- 4.33.1.3 T2-4a，N0-2，M0结肠癌，相应肠段切除加区域淋巴结清扫的比例（结肠癌）
SET @ds_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '第四章-结肠癌（手术治疗）质量控制查询' AND INVALID = 0 LIMIT 1);
SET @cat_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%结肠癌%' AND INVALID = 0 LIMIT 1);
SET @user = 'system';
SET @param = '{"p_date_type":"out"}';

SET @num_name = 'T2_4a_N0_2_M0结肠癌肠段切除加淋巴结清扫例数';
CALL sp_kpi_item_create(@num_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    'T2-4a,N0-2,M0结肠癌相应肠断切除加区域淋巴结清除的例数', '无', '反映结肠癌手术规范性', '第四章-结肠癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：T2-4a,N0-2,M0结肠癌相应肠断切除加区域淋巴结清除的例数。分母：同期T2-4a,N0-2,M0结肠癌手术患者总人次。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', 'T2_4a_N0_2_M0结肠癌相应肠断切除加区域淋巴结清除的例数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.33.1.3.1"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @num_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @num_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @den_name = '同期T2_4a_N0_2_M0结肠癌手术患者总人次_4.33.1.3';
CALL sp_kpi_item_create(@den_name, @cat_id, NULL, 'integer', 0, 'increase', 'value', NULL, @ds_id, @param,
    '同期T2-4a,N0-2,M0结肠癌手术患者总人次', '无', '反映结肠癌手术规范性', '第四章-结肠癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：T2-4a,N0-2,M0结肠癌相应肠断切除加区域淋巴结清除的例数。分母：同期T2-4a,N0-2,M0结肠癌手术患者总人次。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '同期T2_4a_N0_2_M0结肠癌手术患者总人次', NULL, NULL, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.33.1.3.2"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET @den_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @den_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

SET @kpi_name = 'T2-4a，N0-2，M0结肠癌，相应肠段切除加区域淋巴结清扫的比例';
CALL sp_kpi_item_create(@kpi_name, @cat_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, @ds_id, @param,
    'T2-4a,N0-2,M0结肠癌相应肠段切除加区域淋巴结清扫例数占同期手术患者总人次的比例', '无', '反映结肠癌手术规范性', '第四章-结肠癌（手术治疗）质量控制查询', NULL, 'full', NULL, NULL, '分子：T2-4a,N0-2,M0结肠癌相应肠断切除加区域淋巴结清除的例数。分母：同期T2-4a,N0-2,M0结肠癌手术患者总人次。', '百分比（%）', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @num_id, @den_id, NULL, NULL, 1.0000, 'sum', '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间"]',
    @user, CONCAT('[{"category_id":', @cat_id, ',"category_code":"4.33.1.3"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = @kpi_name AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
