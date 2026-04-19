-- ===========================================
-- 3.3.12 检验总周转时间第 90 百分位数（CL-12）
-- 数据源：手工填报
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%临床检验专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.3.12.1
CALL sp_kpi_item_create(
    '检验总周转时间第 90 百分位数（CL-12）分子', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映标本运送、实验室检测及结果报告的及时性和效率。',
    '手工填报', NULL, 'full', NULL, NULL,
    '检验总周转时间是指实验室的所有标本从标本采集到发送报告的时间（以分钟为单位），其中检验前周转时间是指从标本采集到实验室接收标本的时间；实验室内周转时间是指从实验室收到标本到发送报告的时间。实验室在实际工作中仍需要分别监测急诊、住院、门诊服务中具体检验项目的检验前和实验室内周转时间。', '检验总周转时间是指实验室的所有标本从标本采集到发送报告的时间（以分钟为单位），其中检验前周转时间是指从标本采集到实验室接收标本的时间；实验室内周转时间是指从实验室收到标本到发送报告的时间。实验室在实际工作中仍需要分别监测急诊、住院、门诊服务中具体检验项目的检验前和实验室内周转时间。', '无', '无', NULL,
    '出院日期', '出院科室名称', '检验总周转时间第 90 百分位数（CL-12）分子',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.12.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '检验总周转时间第 90 百分位数（CL-12）分子' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.3.12.2
CALL sp_kpi_item_create(
    '检验总周转时间第 90 百分位数（CL-12）分母', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映标本运送、实验室检测及结果报告的及时性和效率。',
    '手工填报', NULL, 'full', NULL, NULL,
    '检验总周转时间是指实验室的所有标本从标本采集到发送报告的时间（以分钟为单位），其中检验前周转时间是指从标本采集到实验室接收标本的时间；实验室内周转时间是指从实验室收到标本到发送报告的时间。实验室在实际工作中仍需要分别监测急诊、住院、门诊服务中具体检验项目的检验前和实验室内周转时间。', '检验总周转时间是指实验室的所有标本从标本采集到发送报告的时间（以分钟为单位），其中检验前周转时间是指从标本采集到实验室接收标本的时间；实验室内周转时间是指从实验室收到标本到发送报告的时间。实验室在实际工作中仍需要分别监测急诊、住院、门诊服务中具体检验项目的检验前和实验室内周转时间。', '无', '无', NULL,
    '出院日期', '出院科室名称', '检验总周转时间第 90 百分位数（CL-12）分母',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.12.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '检验总周转时间第 90 百分位数（CL-12）分母' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.3.12
CALL sp_kpi_item_create(
    '检验总周转时间第 90 百分位数（CL-12）', @category_id, NULL, 'integer', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '将检验总周转时间由短到长排序后取其第 90 百分位数。', '无', '反映标本运送、实验室检测及结果报告的及时性和效率。',
    '手工填报', NULL, 'full', NULL, NULL,
    '检验总周转时间是指实验室的所有标本从标本采集到发送报告的时间（以分钟为单位），其中检验前周转时间是指从标本采集到实验室接收标本的时间；实验室内周转时间是指从实验室收到标本到发送报告的时间。实验室在实际工作中仍需要分别监测急诊、住院、门诊服务中具体检验项目的检验前和实验室内周转时间。', '检验总周转时间是指实验室的所有标本从标本采集到发送报告的时间（以分钟为单位），其中检验前周转时间是指从标本采集到实验室接收标本的时间；实验室内周转时间是指从实验室收到标本到发送报告的时间。实验室在实际工作中仍需要分别监测急诊、住院、门诊服务中具体检验项目的检验前和实验室内周转时间。', '无', '无', NULL,
    '出院日期', '出院科室名称', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["出院科室名称"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.3.12"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '检验总周转时间第 90 百分位数（CL-12）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
