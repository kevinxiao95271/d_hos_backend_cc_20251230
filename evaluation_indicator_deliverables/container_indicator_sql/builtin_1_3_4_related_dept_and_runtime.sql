-- ===========================================
-- 1.3-4 相关科室配置和运行指标 内置脚本
-- 严格按 1.3-4相关科室配置和运行指标.txt 的指标编码与名称内置
-- 数据来源：填报类为手工填报，计算类为分子/分母比率
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';
SET @manual_config = '{"dept_ids":[],"cycle":"year"}';

-- 类别ID（按名称匹配，若不存在则需先维护类别）
SET @cat_emergency = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学科%' AND INVALID = 0 LIMIT 1);
SET @cat_icu = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%重症医学科%' AND INVALID = 0 LIMIT 1);
SET @cat_anesthesia = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%麻醉科%' AND INVALID = 0 LIMIT 1);
SET @cat_tcm = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%中医科%' AND INVALID = 0 LIMIT 1);
SET @cat_rehab = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%康复医学科%' AND INVALID = 0 LIMIT 1);
SET @cat_infect = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%感染性疾病科%' AND INVALID = 0 LIMIT 1);
SET @cat_pediatric = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%儿科%' AND INVALID = 0 LIMIT 1);
SET @cat_psych = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%精神科%' AND INVALID = 0 LIMIT 1);
SET @cat_gp = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%全科医学科%' AND INVALID = 0 LIMIT 1);
SET @cat_runtime = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%运行指标%' AND INVALID = 0 LIMIT 1);

-- ==================== 1.3.1 急诊医学科 ====================
-- 1.3.1.1.1 急诊科固定在岗（本院）医师总数
CALL sp_kpi_item_create(
    '急诊科固定在岗（本院）医师总数', @cat_emergency, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param,
    '指急诊医学科的定岗执业医师人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL,
    '分子：指急诊医学科的定岗执业医师人数。分母：除包含分子外还包括转科、临时帮忙、借调等。', NULL, '无', NULL, NULL,
    '统计日期', '全院', '急诊科固定在岗（本院）医师总数',
    NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@cat_emergency,0), ',"category_code":"1.3.1.1.1"}]'), NULL, NULL, 'manual', @manual_config
);
SET @id_13111 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '急诊科固定在岗（本院）医师总数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.3.1.1.2 同期急诊在岗医师人数
CALL sp_kpi_item_create(
    '同期急诊在岗医师人数', @cat_emergency, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param,
    '除定岗医师外还包括转科、临时帮忙、借调等。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL,
    '分母：除包含分子外还包括转科、临时帮忙、借调等。', NULL, '无', NULL, NULL,
    '统计日期', '全院', '同期急诊在岗医师人数',
    NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@cat_emergency,0), ',"category_code":"1.3.1.1.2"}]'), NULL, NULL, 'manual', @manual_config
);
SET @id_13112 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期急诊在岗医师人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.3.1.1 固定急诊医师人数占急诊在岗医师人数的比例
CALL sp_kpi_item_create(
    '固定急诊医师人数占急诊在岗医师人数的比例', @cat_emergency, NULL, 'percent', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param,
    '指急诊科固定在岗（本院）医师总数占同期急诊在岗医师人数的比例。', '《急诊科建设与管理指南（试行）》', NULL, '手工填报', NULL, 'full', NULL, NULL,
    '分子：指急诊医学科的定岗执业医师人数。分母：除包含分子外还包括转科、临时帮忙、借调等。', NULL, '百分比（%）', NULL, NULL,
    '统计日期', '全院', NULL, @id_13111, @id_13112, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@cat_emergency,0), ',"category_code":"1.3.1.1"}]'), NULL, NULL, NULL, NULL
);

-- 1.3.1.2.1 急诊医学科固定急诊护士人数
CALL sp_kpi_item_create(
    '急诊医学科固定急诊护士人数', @cat_emergency, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param,
    '指急诊医学科的定岗执业护士人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL,
    '分子：指急诊医学科的定岗执业护士人数。', NULL, '无', NULL, NULL,
    '统计日期', '全院', '急诊医学科固定急诊护士人数',
    NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@cat_emergency,0), ',"category_code":"1.3.1.2.1"}]'), NULL, NULL, 'manual', @manual_config
);
SET @id_13211 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '急诊医学科固定急诊护士人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.3.1.2.2 同期急诊医学科在岗执业护士人数
CALL sp_kpi_item_create(
    '同期急诊医学科在岗执业护士人数', @cat_emergency, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param,
    '除定岗护士外还包括转科、临时帮忙、借调等，含病产假、外出进修护士。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL,
    '分母：除包含分子外还包括转科、临时帮忙、借调等。均包括急诊医学科的病产假等各类休假护士、外出进修护士。', NULL, '无', NULL, NULL,
    '统计日期', '全院', '同期急诊医学科在岗执业护士人数',
    NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@cat_emergency,0), ',"category_code":"1.3.1.2.2"}]'), NULL, NULL, 'manual', @manual_config
);
SET @id_13212 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期急诊医学科在岗执业护士人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);

-- 1.3.1.2 固定急诊护士人数占急诊在岗护士人数的比例
CALL sp_kpi_item_create(
    '固定急诊护士人数占急诊在岗护士人数的比例', @cat_emergency, NULL, 'percent', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param,
    '指统计周期内急诊医学科固定执业护士总数与急诊医学科所有在岗执业护士人数的比例。', '《急诊科建设与管理指南（试行）》', NULL, '手工填报', NULL, 'full', NULL, NULL,
    '分子：指急诊医学科的定岗执业护士人数。分母：除包含分子外还包括转科、临时帮忙、借调等。均包括急诊医学科的病产假等各类休假护士、外出进修护士。', NULL, '百分比（%）', NULL, NULL,
    '统计日期', '全院', NULL, @id_13211, @id_13212, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', IFNULL(@cat_emergency,0), ',"category_code":"1.3.1.2"}]'), NULL, NULL, NULL, NULL
);

-- ==================== 1.3.2 重症医学科 ====================
CALL sp_kpi_item_create('重症医学科开放床位数', @cat_icu, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '重症医学科开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '重症医学科开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_icu,0), ',"category_code":"1.3.2.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13211 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '重症医学科开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('医院同期开放床位数', @cat_icu, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '医院同期开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '医院同期开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_icu,0), ',"category_code":"1.3.2.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13212 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医院同期开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('重症医学科开放床位数占医院开放床位数的比例', @cat_icu, NULL, 'percent', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指重症医学科开放床位数占医院开放床位数的比例。', '《重症医学科建设与管理指南（试行）》', NULL, '手工填报', NULL, 'full', NULL, NULL, '见指标定义。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_13211, @id_13212, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_icu,0), ',"category_code":"1.3.2.1"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('重症医学科医师人数', @cat_icu, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '重症医学科医师人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '重症医学科医师人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_icu,0), ',"category_code":"1.3.2.2.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13221 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '重症医学科医师人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('重症医学科开放床位数', @cat_icu, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '重症医学科开放床位数（分母）。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '重症医学科开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_icu,0), ',"category_code":"1.3.2.2.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13222 = (SELECT KPI_ID FROM KPI_ITEM_CATEGORY_REL r JOIN KPI_ITEM k ON r.KPI_ID = k.ID WHERE r.CATEGORY_CODE = '1.3.2.2.2' AND k.INVALID = 0 ORDER BY r.KPI_ID DESC LIMIT 1);
CALL sp_kpi_item_create('重症医学科医师人数与重症医学科开放床位数比', @cat_icu, NULL, 'decimal', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指重症医学科医师人数与重症医学科开放床位数的比。', '《重症医学科建设与管理指南（试行）》', NULL, '手工填报', NULL, 'full', NULL, NULL, '医师人数与床位数之比应为0.8：1以上。', NULL, '比值（1：X）', NULL, NULL, '统计日期', '全院', NULL, @id_13221, @id_13222, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_icu,0), ',"category_code":"1.3.2.2"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('重症医学科执业护士总数', @cat_icu, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '医院重症医学科岗位的执业护士总人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '重症医学科执业护士总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_icu,0), ',"category_code":"1.3.2.3.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13231 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '重症医学科执业护士总数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期重症医学科实际开放床位数', @cat_icu, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '同期重症医学科实际开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期重症医学科实际开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_icu,0), ',"category_code":"1.3.2.3.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13232 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期重症医学科实际开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('重症医学科护士人数与重症医学科开放床位数比', @cat_icu, NULL, 'decimal', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指重症医学科所配备的执业护士人数与重症医学科实际开放床位数的比例。', '《重症医学科建设与管理指南（试行）》', NULL, '手工填报', NULL, 'full', NULL, NULL, '护士人数与床位数之比应为3：1以上。', NULL, '比值（1：X）', NULL, NULL, '统计日期', '全院', NULL, @id_13231, @id_13232, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_icu,0), ',"category_code":"1.3.2.3"}]'), NULL, NULL, NULL, NULL);

-- ==================== 1.3.3 麻醉科 ====================
CALL sp_kpi_item_create('麻醉科固定在岗（本院）医师总数', @cat_anesthesia, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '麻醉科固定在岗（本院）医师总数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '麻醉科固定在岗（本院）医师总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13311 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '麻醉科固定在岗（本院）医师总数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期实施麻醉的手术间数', @cat_anesthesia, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '同期实施麻醉的手术间数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期实施麻醉的手术间数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13312 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期实施麻醉的手术间数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('麻醉科医师数与手术间数比', @cat_anesthesia, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指麻醉科固定在岗（本院）医师总数占同期实施麻醉的手术间数的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '比值（X∶1）。', NULL, '比值（X∶1）', NULL, NULL, '统计日期', '全院', NULL, @id_13311, @id_13312, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.1"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('麻醉科日均全麻手术台次', @cat_anesthesia, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '麻醉科日均全麻手术台次。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '麻醉科日均全麻手术台次', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.2.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13321 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '麻醉科日均全麻手术台次' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期麻醉科固定在岗（本院）医师总数', @cat_anesthesia, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '同期麻醉科固定在岗（本院）医师总数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期麻醉科固定在岗（本院）医师总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.2.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13322 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期麻醉科固定在岗（本院）医师总数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('麻醉科医师数与日均全麻手术台次比', @cat_anesthesia, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指麻醉科固定在岗（本院）医师总数占同期麻醉科日均完成全身麻醉手术台次总数的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '比值（1∶X）。', NULL, '比值（1∶X）', NULL, NULL, '统计日期', '全院', NULL, @id_13321, @id_13322, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.2"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('手术科室医师数', @cat_anesthesia, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '手术科室医师数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '手术科室医师数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.3.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13331 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '手术科室医师数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期麻醉科固定在岗（本院）医师总数', @cat_anesthesia, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '同期麻醉科固定在岗（本院）医师总数（分母）。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期麻醉科固定在岗（本院）医师总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.3.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13332 = (SELECT KPI_ID FROM KPI_ITEM_CATEGORY_REL r JOIN KPI_ITEM k ON r.KPI_ID = k.ID WHERE r.CATEGORY_CODE = '1.3.3.3.2' AND k.INVALID = 0 ORDER BY r.KPI_ID DESC LIMIT 1);
CALL sp_kpi_item_create('麻醉科医师和手术科室医师比', @cat_anesthesia, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指麻醉科固定在岗（本院）医师总数占同期手术科室医师的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '比值（1∶X）。', NULL, '比值（1∶X）', NULL, NULL, '统计日期', '全院', NULL, @id_13331, @id_13332, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.3"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('实际开放手术台数量', @cat_anesthesia, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '实际开放手术台数量。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '实际开放手术台数量', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.4.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13341 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实际开放手术台数量' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期手术间麻醉护士总数', @cat_anesthesia, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '同期手术间麻醉护士总数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期手术间麻醉护士总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.4.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13342 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期手术间麻醉护士总数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('手术间麻醉护士与实际开放手术台的数量比', @cat_anesthesia, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指医院手术间麻醉护士总数占同期实际开放手术台数量的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '比值（1∶X）。', NULL, '比值（1∶X）', NULL, NULL, '统计日期', '全院', NULL, @id_13341, @id_13342, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_anesthesia,0), ',"category_code":"1.3.3.4"}]'), NULL, NULL, NULL, NULL);

-- ==================== 1.3.4 中医科 ====================
CALL sp_kpi_item_create('中医科实际开放床位数', @cat_tcm, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '中医科实际开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '中医科实际开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_tcm,0), ',"category_code":"1.3.4.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13411 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '中医科实际开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('医院实际开放床位数', @cat_tcm, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '医院实际开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '医院实际开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_tcm,0), ',"category_code":"1.3.4.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13412 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医院实际开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('中医科开放床位数占医院开放床位数的比例', @cat_tcm, NULL, 'percent', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指中医科实际开放床位数与医院实际开放床位数的比例。', '《综合医院中医临床科室基本标准》', NULL, '手工填报', NULL, 'full', NULL, NULL, '床位数不低于医院标准床位数的5%。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_13411, @id_13412, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_tcm,0), ',"category_code":"1.3.4.1"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('中医科中医类别医师人数', @cat_tcm, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '中医科中医类别医师人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '中医科中医类别医师人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_tcm,0), ',"category_code":"1.3.4.2.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13421 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '中医科中医类别医师人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('中医科开放床位数', @cat_tcm, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '中医科开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '中医科开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_tcm,0), ',"category_code":"1.3.4.2.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13422 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '中医科开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('中医科中医类别医师人数与中医科开放床位数比', @cat_tcm, NULL, 'decimal', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指中医科中医类别医师人数与中医科开放床位数的比例。', '《综合医院中医临床科室基本标准》', NULL, '手工填报', NULL, 'full', NULL, NULL, '每床至少配备0.4名中医类别医师。', NULL, '比值（X：1）', NULL, NULL, '统计日期', '全院', NULL, @id_13421, @id_13422, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_tcm,0), ',"category_code":"1.3.4.2"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('中医科执业护士总数', @cat_tcm, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '中医科执业护士总数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '中医科执业护士总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_tcm,0), ',"category_code":"1.3.4.3.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13431 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '中医科执业护士总数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期中医科开放床位数', @cat_tcm, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '同期中医科开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期中医科开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_tcm,0), ',"category_code":"1.3.4.3.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13432 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期中医科开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('中医科护士人数与中医科开放床位数比', @cat_tcm, NULL, 'decimal', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指统计周期内中医科所配备的执业护士人数与实际开放床位数的比例。', '《综合医院中医临床科室基本标准》', NULL, '手工填报', NULL, 'full', NULL, NULL, '每床至少配备0.4名护士。', NULL, '比值（X：1）', NULL, NULL, '统计日期', '全院', NULL, @id_13431, @id_13432, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_tcm,0), ',"category_code":"1.3.4.3"}]'), NULL, NULL, NULL, NULL);

-- ==================== 1.3.5 康复医学科 ====================
CALL sp_kpi_item_create('康复科开放床位数', @cat_rehab, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '康复科开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '康复科开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13511 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '康复科开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('医院开放床位数', @cat_rehab, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '医院开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '医院开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13512 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医院开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('康复科开放床位数占医院开放床位数的比例', @cat_rehab, NULL, 'percent', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指康复科开放床位数占医院开放床位数的比例。', '《综合医院康复医学科基本标准（试行）》', NULL, '手工填报', NULL, 'full', NULL, NULL, '应为医院总床位数的2%-5%。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_13511, @id_13512, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.1"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('康复科医师人数', @cat_rehab, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '康复科医师人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '康复科医师人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.2.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13521 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '康复科医师人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('康复科开放床位数', @cat_rehab, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '康复科开放床位数（分母）。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '康复科开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.2.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13522 = (SELECT KPI_ID FROM KPI_ITEM_CATEGORY_REL r JOIN KPI_ITEM k ON r.KPI_ID = k.ID WHERE r.CATEGORY_CODE = '1.3.5.2.2' AND k.INVALID = 0 ORDER BY r.KPI_ID DESC LIMIT 1);
CALL sp_kpi_item_create('康复科医师人数与康复科开放床位数比', @cat_rehab, NULL, 'decimal', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指康复科医师人数与康复医学科开放床位数之比。', '《综合医院康复医学科基本标准（试行）》', NULL, '手工填报', NULL, 'full', NULL, NULL, '每床至少配备0.25名医师。', NULL, '比值（X∶1）', NULL, NULL, '统计日期', '全院', NULL, @id_13521, @id_13522, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.2"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('康复科康复师人数', @cat_rehab, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '康复科康复师人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '康复科康复师人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.3.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13531 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '康复科康复师人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('康复科开放床位数', @cat_rehab, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '康复科开放床位数（分母）。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '康复科开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.3.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13532 = (SELECT KPI_ID FROM KPI_ITEM_CATEGORY_REL r JOIN KPI_ITEM k ON r.KPI_ID = k.ID WHERE r.CATEGORY_CODE = '1.3.5.3.2' AND k.INVALID = 0 ORDER BY r.KPI_ID DESC LIMIT 1);
CALL sp_kpi_item_create('康复科康复师人数与康复科开放床位数比', @cat_rehab, NULL, 'decimal', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指康复科康复师人数与康复科开放床位数的比。', '《综合医院康复医学科基本标准（试行）》', NULL, '手工填报', NULL, 'full', NULL, NULL, '每床至少配备0.5名康复治疗师。', NULL, '比值（X∶1）', NULL, NULL, '统计日期', '全院', NULL, @id_13531, @id_13532, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.3"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('康复医学科执业护士总数', @cat_rehab, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '康复医学科执业护士总数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '康复医学科执业护士总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.4.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13541 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '康复医学科执业护士总数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期康复医学科实际开放床位数', @cat_rehab, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '同期康复医学科实际开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期康复医学科实际开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.4.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13542 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期康复医学科实际开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('康复科护士人数与康复科开放床位数比', @cat_rehab, NULL, 'decimal', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '指康复医学科所配备的执业护士人数与康复科实际开放床位数的比值。', '《综合医院康复医学科基本标准（试行）》', NULL, '手工填报', NULL, 'full', NULL, NULL, '每床至少配备0.3名护士。', NULL, '比值（X∶1）', NULL, NULL, '统计日期', '全院', NULL, @id_13541, @id_13542, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_rehab,0), ',"category_code":"1.3.5.4"}]'), NULL, NULL, NULL, NULL);

-- ==================== 1.3.6 感染性疾病科 ====================
CALL sp_kpi_item_create('感染性疾病科固定医师人数', @cat_infect, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '感染性疾病科固定医师人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '感染性疾病科固定医师人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13611 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '感染性疾病科固定医师人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('感染性疾病科在岗医师人数', @cat_infect, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '感染性疾病科在岗医师人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '感染性疾病科在岗医师人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13612 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '感染性疾病科在岗医师人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('感染性疾病科固定医师人数占在岗医师人数的比例', @cat_infect, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指感染科固定医师人数占感染科在岗医师人数的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, NULL, NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_13611, @id_13612, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.1"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('感染性疾病科固定执业护士总数', @cat_infect, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '感染性疾病科固定执业护士总数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '感染性疾病科固定执业护士总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.2.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13621 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '感染性疾病科固定执业护士总数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期感染性疾病科在岗执业护士人数', @cat_infect, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '同期感染性疾病科在岗执业护士人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期感染性疾病科在岗执业护士人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.2.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13622 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期感染性疾病科在岗执业护士人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('固定护士人数占感染性疾病科在岗护士人数的比例', @cat_infect, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指感染性疾病科固定执业护士总数与感染性疾病科所有在岗执业护士人数的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：定岗执业护士人数；分母含转科、临时帮忙、借调等。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_13621, @id_13622, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.2"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('感染性疾病科实际开放床位数', @cat_infect, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '感染性疾病科实际开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '感染性疾病科实际开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.3.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13631 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '感染性疾病科实际开放床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('医院实际开放床位数', @cat_infect, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '医院实际开放床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '医院实际开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.3.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13632 = (SELECT KPI_ID FROM KPI_ITEM_CATEGORY_REL r JOIN KPI_ITEM k ON r.KPI_ID = k.ID WHERE r.CATEGORY_CODE = '1.3.6.3.2' AND k.INVALID = 0 ORDER BY r.KPI_ID DESC LIMIT 1);
CALL sp_kpi_item_create('感染性疾病科开放床位数占医院开放床位数的比例', @cat_infect, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指感染性疾病科配备的实际开放床位数占医院实际开放床位数的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, NULL, NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_13631, @id_13632, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.3"}]'), NULL, NULL, NULL, NULL);

CALL sp_kpi_item_create('可转换感染性疾病床位数', @cat_infect, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '可转换感染性疾病床位数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '符合或简易改造后符合三区两通道要求的床位。', NULL, '无', NULL, NULL, '统计日期', '全院', '可转换感染性疾病床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.4.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13641 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '可转换感染性疾病床位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('医院实际开放床位数', @cat_infect, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '医院实际开放床位数（分母）。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '医院实际开放床位数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.4.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13642 = (SELECT KPI_ID FROM KPI_ITEM_CATEGORY_REL r JOIN KPI_ITEM k ON r.KPI_ID = k.ID WHERE r.CATEGORY_CODE = '1.3.6.4.2' AND k.INVALID = 0 ORDER BY r.KPI_ID DESC LIMIT 1);
CALL sp_kpi_item_create('可转换感染性疾病床位数占医院开放床位数的比例', @cat_infect, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指可转换感染性疾病床位数占医院开放床位数的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '可转换感染性疾病床位指符合或简易改造后符合三区两通道要求的床位。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_13641, @id_13642, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_infect,0), ',"category_code":"1.3.6.4"}]'), NULL, NULL, NULL, NULL);

-- ==================== 1.3.7 儿科 ====================
CALL sp_kpi_item_create('医院注册的儿科在岗医师数', @cat_pediatric, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param, '医院注册的儿科在岗医师数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '医院注册的儿科在岗医师数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_pediatric,0), ',"category_code":"1.3.7.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13711 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医院注册的儿科在岗医师数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('全院同期医师总数', @cat_pediatric, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param, '全院同期医师总数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '全院同期医师总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_pediatric,0), ',"category_code":"1.3.7.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13712 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '全院同期医师总数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('儿科医师数占比', @cat_pediatric, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, @data_source_param, '指医院注册的儿科在岗医师占同期全院医师总数的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：儿科专业医师；分母：全院医师总数。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_13711, @id_13712, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_pediatric,0), ',"category_code":"1.3.7.1"}]'), NULL, NULL, NULL, NULL);

-- ==================== 1.3.8 精神科 ====================
CALL sp_kpi_item_create('三级甲等综合医院应当设置精神科', @cat_psych, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '三级甲等综合医院应当设置精神科，1是0否。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '1是0否。', NULL, '1是0否', NULL, NULL, '统计日期', '全院', '三级甲等综合医院应当设置精神科', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_psych,0), ',"category_code":"1.3.8.1"}]'), NULL, NULL, 'manual', @manual_config);

CALL sp_kpi_item_create('医院注册的精神科在岗医师数', @cat_psych, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param, '医院注册的精神科在岗医师数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '医院注册的精神科在岗医师数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_psych,0), ',"category_code":"1.3.8.2.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13821 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医院注册的精神科在岗医师数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('全院同期医师总数', @cat_psych, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param, '全院同期医师总数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '全院同期医师总数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_psych,0), ',"category_code":"1.3.8.2.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_13822 = (SELECT KPI_ID FROM KPI_ITEM_CATEGORY_REL r JOIN KPI_ITEM k ON r.KPI_ID = k.ID WHERE r.CATEGORY_CODE = '1.3.8.2.2' AND k.INVALID = 0 ORDER BY r.KPI_ID DESC LIMIT 1);
CALL sp_kpi_item_create('精神科医师数占比', @cat_psych, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, @data_source_param, '指医院注册的精神科在岗医师占同期全院医师总数的比。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：精神科专业医师；分母：全院医师总数。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_13821, @id_13822, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_psych,0), ',"category_code":"1.3.8.2"}]'), NULL, NULL, NULL, NULL);

-- ==================== 1.3.9 全科医学科 ====================
CALL sp_kpi_item_create('三级甲等综合医院应当设置全科医学科', @cat_gp, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '三级甲等综合医院应当设置全科医学科，1是0否。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '1是0否。', NULL, '1是0否', NULL, NULL, '统计日期', '全院', '三级甲等综合医院应当设置全科医学科', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_gp,0), ',"category_code":"1.3.9.1"}]'), NULL, NULL, 'manual', @manual_config);
CALL sp_kpi_item_create('是否设置全科医学科', @cat_gp, NULL, 'integer', 0, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '是否设置全科医学科，1是0否。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '1是0否。', NULL, '1是0否', NULL, NULL, '统计日期', '全院', '是否设置全科医学科', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_gp,0), ',"category_code":"1.3.9.2"}]'), NULL, NULL, 'manual', @manual_config);

-- ==================== 1.4 运行指标 ====================
-- 1.4.1 相关手术科室年手术人次占其出院人次比例
CALL sp_kpi_item_create('相关手术科室手术人次', @cat_runtime, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param, '相关手术科室出院患者手术人次。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '相关手术科室手术人次', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_1411 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '相关手术科室手术人次' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期手术科室出院人次', @cat_runtime, NULL, 'integer', 0, 'increase', 'value', NULL, @data_source_id, @data_source_param, '同期手术科室出院人次。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期手术科室出院人次', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_1412 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期手术科室出院人次' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('（一）相关手术科室年手术人次占其出院人次比例', @cat_runtime, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, @data_source_param, '指手术相关科室出院患者手术人次占同期手术相关科室出院患者总人次的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：手术人次；分母：出院人次。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_1411, @id_1412, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.1"}]'), NULL, NULL, NULL, NULL);

-- 1.4.2 人员支出占业务支出的比重
CALL sp_kpi_item_create('人员经费', @cat_runtime, NULL, 'decimal', 2, 'increase', 'value', NULL, @data_source_id, @data_source_param, '人员经费。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '人员经费', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.2.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_1421 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '人员经费' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('医疗活动费用', @cat_runtime, NULL, 'decimal', 2, 'increase', 'value', NULL, @data_source_id, @data_source_param, '医疗活动费用。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '医疗活动费用', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.2.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_1422 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗活动费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('（二）人员支出占业务支出的比重', @cat_runtime, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, @data_source_param, '人员经费占医疗活动费用的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：人员经费；分母：医疗活动费用。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_1421, @id_1422, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.2"}]'), NULL, NULL, NULL, NULL);

-- 1.4.3 收支结构：1.4.3.1 医疗服务收入占医疗收入比例
CALL sp_kpi_item_create('医疗服务收入（不含药品、耗材、检查检验收入）', @cat_runtime, NULL, 'decimal', 2, 'increase', 'value', NULL, @data_source_id, @data_source_param, '医疗服务收入（不含药品、耗材、检查检验收入）。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '医疗服务收入（不含药品、耗材、检查检验收入）', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14311 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗服务收入（不含药品、耗材、检查检验收入）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('医疗收入', @cat_runtime, NULL, 'decimal', 2, 'increase', 'value', NULL, @data_source_id, @data_source_param, '医疗收入。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '医疗收入', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14312 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗收入' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('1.医疗服务收入（不含药品、耗材、检查检验收入）占医疗收入比例', @cat_runtime, NULL, 'percent', 2, 'increase', 'ratio', NULL, @data_source_id, @data_source_param, '年度医疗服务收入（不包含药品、耗材、检查检验收入）占医疗收入的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：医疗服务收入；分母：医疗收入。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_14311, @id_14312, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.1"}]'), NULL, NULL, NULL, NULL);

-- 1.4.3.2 收支结余（医疗盈余率）
CALL sp_kpi_item_create('医疗盈余', @cat_runtime, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '医疗盈余。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '医疗盈余', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.2.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14321 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗盈余' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('医疗活动收入', @cat_runtime, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '医疗活动收入。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '医疗活动收入', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.2.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14322 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医疗活动收入' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('2.收支结余（医疗盈余率）', @cat_runtime, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '医疗盈余占医疗活动收入的比例。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：医疗盈余；分母：医疗活动收入。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_14321, @id_14322, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.2"}]'), NULL, NULL, NULL, NULL);

-- 1.4.3.3 资产负债率
CALL sp_kpi_item_create('负债合计', @cat_runtime, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '负债合计。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '负债合计', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.3.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14331 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '负债合计' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('资产合计', @cat_runtime, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '资产合计。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '资产合计', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.3.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14332 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '资产合计' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('3.资产负债率', @cat_runtime, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指年度医院负债合计与资产合计的比值。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：负债合计；分母：资产合计。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_14331, @id_14332, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.3"}]'), NULL, NULL, NULL, NULL);

-- 1.4.3.4 流动比率
CALL sp_kpi_item_create('流动资产', @cat_runtime, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '流动资产。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '流动资产', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.4.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14341 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '流动资产' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('流动负债', @cat_runtime, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '流动负债。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '流动负债', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.4.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14342 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '流动负债' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('4.流动比率', @cat_runtime, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指年度医院流动资产与流动负债的比值。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：流动资产；分母：流动负债。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_14341, @id_14342, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.4"}]'), NULL, NULL, NULL, NULL);

-- 1.4.3.5 速动比率
CALL sp_kpi_item_create('速动资产', @cat_runtime, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '速动资产。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '速动资产', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.5.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14351 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '速动资产' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('流动负债', @cat_runtime, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param, '流动负债（速动比率分母）。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '流动负债', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.5.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14352 = (SELECT KPI_ID FROM KPI_ITEM_CATEGORY_REL r JOIN KPI_ITEM k ON r.KPI_ID = k.ID WHERE r.CATEGORY_CODE = '1.4.3.5.2' AND k.INVALID = 0 ORDER BY r.KPI_ID DESC LIMIT 1);
CALL sp_kpi_item_create('5.速动比率', @cat_runtime, NULL, 'percent', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param, '指年度医院速动资产与流动负债的比值。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：速动资产；分母：流动负债。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_14351, @id_14352, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.3.5"}]'), NULL, NULL, NULL, NULL);

-- 1.4.4 费用控制：1.4.4.1 门诊次均费用增幅
CALL sp_kpi_item_create('本年度门诊患者次均医药费用-上一年度门诊患者次均医药费用', @cat_runtime, NULL, 'decimal', 2, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '本年度门诊患者次均医药费用减上一年度门诊患者次均医药费用。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '本年度门诊患者次均医药费用-上一年度门诊患者次均医药费用', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14411 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '本年度门诊患者次均医药费用-上一年度门诊患者次均医药费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('上一年度门诊患者次均医药费用', @cat_runtime, NULL, 'decimal', 2, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '上一年度门诊患者次均医药费用。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '上一年度门诊患者次均医药费用', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14412 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '上一年度门诊患者次均医药费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('1.门诊次均费用增幅', @cat_runtime, NULL, 'percent', 2, 'decrease', 'ratio', NULL, @data_source_id, @data_source_param, '指年度门诊患者次均医药费用与上一年度次均医药费用之差与上一年度次均医药费用的比值。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：本年-上年；分母：上年。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_14411, @id_14412, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.1"}]'), NULL, NULL, NULL, NULL);

-- 1.4.4.2 门诊次均药品费用增幅
CALL sp_kpi_item_create('本年度门诊患者次均药品费用-上一年度门诊患者次均药品费用', @cat_runtime, NULL, 'decimal', 2, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '本年度门诊患者次均药品费用减上一年度。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '本年度门诊患者次均药品费用-上一年度门诊患者次均药品费用', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.2.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14421 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '本年度门诊患者次均药品费用-上一年度门诊患者次均药品费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('上一年度门诊患者次均药品费用', @cat_runtime, NULL, 'decimal', 2, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '上一年度门诊患者次均药品费用。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '上一年度门诊患者次均药品费用', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.2.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14422 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '上一年度门诊患者次均药品费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('2.门诊次均药品费用增幅', @cat_runtime, NULL, 'percent', 2, 'decrease', 'ratio', NULL, @data_source_id, @data_source_param, '指年度门诊患者次均药品费用与上一年度次均药品费用之差与上一年度次均药品费用的比值。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, NULL, NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_14421, @id_14422, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.2"}]'), NULL, NULL, NULL, NULL);

-- 1.4.4.3 住院次均费用增幅
CALL sp_kpi_item_create('本年度住院患者次均医药费用-上一年度住院患者次均医药费用', @cat_runtime, NULL, 'decimal', 2, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '本年度住院患者次均医药费用减上一年度。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '本年度住院患者次均医药费用-上一年度住院患者次均医药费用', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.3.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14431 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '本年度住院患者次均医药费用-上一年度住院患者次均医药费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('上一年度住院患者次均医药费用', @cat_runtime, NULL, 'decimal', 2, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '上一年度住院患者次均医药费用。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '上一年度住院患者次均医药费用', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.3.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14432 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '上一年度住院患者次均医药费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('3.住院次均费用增幅', @cat_runtime, NULL, 'percent', 2, 'decrease', 'ratio', NULL, @data_source_id, @data_source_param, '指年度出院患者次均医药费用与上一年度之差与上一年度次均医药费用的比值。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, NULL, NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_14431, @id_14432, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.3"}]'), NULL, NULL, NULL, NULL);

-- 1.4.4.4 住院次均药品费用增幅
CALL sp_kpi_item_create('本年度住院患者次均药品费用-上一年度住院患者次均药品费用', @cat_runtime, NULL, 'decimal', 2, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '本年度住院患者次均药品费用减上一年度。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '本年度住院患者次均药品费用-上一年度住院患者次均药品费用', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.4.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14441 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '本年度住院患者次均药品费用-上一年度住院患者次均药品费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('上一年度住院患者次均药品费用', @cat_runtime, NULL, 'decimal', 2, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '上一年度住院患者次均药品费用。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '上一年度住院患者次均药品费用', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.4.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14442 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '上一年度住院患者次均药品费用' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('4.住院次均药品费用增幅', @cat_runtime, NULL, 'percent', 2, 'decrease', 'ratio', NULL, @data_source_id, @data_source_param, '指年度住院患者次均药品费用与上一年度次均药品费用之差与上一年度住院次均药品费用的比值。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, NULL, NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_14441, @id_14442, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.4.4"}]'), NULL, NULL, NULL, NULL);

-- 1.4.5 开放床位使用率
CALL sp_kpi_item_create('实际占用总床日数', @cat_runtime, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '实际占用总床日数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '实际占用总床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.5.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_1451 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实际占用总床日数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期实际开放总床日数', @cat_runtime, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '同期实际开放总床日数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期实际开放总床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.5.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_1452 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期实际开放总床日数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('（五）开放床位使用率', @cat_runtime, NULL, 'percent', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '床位使用率反映每天使用床位与实有床位的比率，即实际占用的总床日数与实际开放的总床日数之比。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：实际占用总床日数；分母：实际开放总床日数。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_1451, @id_1452, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.5"}]'), NULL, NULL, NULL, NULL);

-- 1.4.6 核定床位使用率
CALL sp_kpi_item_create('实际占用总床日数', @cat_runtime, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '实际占用总床日数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '实际占用总床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.6.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_1461 = (SELECT KPI_ID FROM KPI_ITEM_CATEGORY_REL r JOIN KPI_ITEM k ON r.KPI_ID = k.ID WHERE r.CATEGORY_CODE = '1.4.6.1' AND k.INVALID = 0 ORDER BY r.KPI_ID DESC LIMIT 1);
CALL sp_kpi_item_create('同期编制床位总床日数', @cat_runtime, NULL, 'integer', 0, 'target', 'value', NULL, @data_source_id, @data_source_param, '同期编制床位总床日数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期编制床位总床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.6.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_1462 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期编制床位总床日数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('（六）核定床位使用率', @cat_runtime, NULL, 'percent', 2, 'target', 'ratio', NULL, @data_source_id, @data_source_param, '床位使用率反映每天使用床位与实有床位的比率，即实际占用的总床日数与编制床位的总床日数之比。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：实际占用总床日数；分母：编制床位总床日数。', NULL, '百分比（%）', NULL, NULL, '统计日期', '全院', NULL, @id_1461, @id_1462, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.6"}]'), NULL, NULL, NULL, NULL);

-- 1.4.7.1 出院患者平均住院日
CALL sp_kpi_item_create('出院患者占用总床日数', @cat_runtime, NULL, 'integer', 0, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '出院患者占用总床日数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子。', NULL, '无', NULL, NULL, '统计日期', '全院', '出院患者占用总床日数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.7.1.1"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14711 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '出院患者占用总床日数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('同期出院患者人数', @cat_runtime, NULL, 'integer', 0, 'decrease', 'value', NULL, @data_source_id, @data_source_param, '同期出院患者人数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分母。', NULL, '无', NULL, NULL, '统计日期', '全院', '同期出院患者人数', NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.7.1.2"}]'), NULL, NULL, 'manual', @manual_config);
SET @id_14712 = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期出院患者人数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1);
CALL sp_kpi_item_create('1.出院患者平均住院日', @cat_runtime, NULL, 'decimal', 2, 'decrease', 'ratio', NULL, @data_source_id, @data_source_param, '出院患者平均住院日是指年度医院平均每个出院患者占用的住院床日数。', NULL, NULL, '手工填报', NULL, 'full', NULL, NULL, '分子：出院患者占用总床日数；分母：同期出院患者人数。', NULL, '天', NULL, NULL, '统计日期', '全院', NULL, @id_14711, @id_14712, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]', @create_user, CONCAT('[{"category_id":', IFNULL(@cat_runtime,0), ',"category_code":"1.4.7.1"}]'), NULL, NULL, NULL, NULL);

SELECT '1.3-4 相关科室配置和运行指标 内置完成' AS message;
