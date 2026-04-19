-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.11.5.1
-- 指标名称：出血发生率
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '体外膜肺氧合（ECMO）技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建分子指标
SET @numerator_kpi_name = '发生出血并发症例次数';
SET @numerator_category_code = '5.1.11.5.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '出血包括应用ECMO期间的（调整内容）:①致死性出血;②颅内出血;③与ECMO抗凝相关的纵隔、消化道、呼吸道、插管局部等部位出血,导致血色素进行性下降（下降幅度>2g/dL/d）、循环不稳定、或需要外科手术干预。', '《体外膜肺氧合（ECMO）技术临床应用管理规范（2022 版）》《体外膜肺氧合（ECMO）技术临床应用质量控制指标（2022 版）》。', '反映ECMO技术治疗的安全性，是反映医院ECMO技术医疗质量的重要结果性指标之一。',
    '体外膜肺氧合（ECMO）技术数据源', NULL, '无', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成出血发生', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.11.5.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建分母指标
SET @denominator_kpi_name = '同期ECMO应用例次数';
SET @denominator_category_code = '5.1.11.5.1.2';
CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, '{"p_date_type":"out"}',
    '出血包括应用ECMO期间的（调整内容）:①致死性出血;②颅内出血;③与ECMO抗凝相关的纵隔、消化道、呼吸道、插管局部等部位出血,导致血色素进行性下降（下降幅度>2g/dL/d）、循环不稳定、或需要外科手术干预。', '《体外膜肺氧合（ECMO）技术临床应用管理规范（2022 版）》《体外膜肺氧合（ECMO）技术临床应用质量控制指标（2022 版）》。', '反映ECMO技术治疗的安全性，是反映医院ECMO技术医疗质量的重要结果性指标之一。',
    '体外膜肺氧合（ECMO）技术数据源', NULL, '无', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', '是否完成ECMO应用', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.11.5.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 创建比率指标
SET @kpi_name = '出血发生率';
SET @category_code = '5.1.11.5.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'percent', 2, 'decrease', 'ratio', @data_source_id, '{"p_date_type":"out"}',
    '出血包括应用ECMO期间的（调整内容）:①致死性出血;②颅内出血;③与ECMO抗凝相关的纵隔、消化道、呼吸道、插管局部等部位出血,导致血色素进行性下降（下降幅度>2g/dL/d）、循环不稳定、或需要外科手术干预。', '《体外膜肺氧合（ECMO）技术临床应用管理规范（2022 版）》《体外膜肺氧合（ECMO）技术临床应用质量控制指标（2022 版）》。', '反映ECMO技术治疗的安全性，是反映医院ECMO技术医疗质量的重要结果性指标之一。',
    '体外膜肺氧合（ECMO）技术数据源', NULL, '无', '百分比（%）', '病案首页。', NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.11.5.1"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型, k.NUMERATOR_KPI_ID AS 分子指标ID, k.DENOMINATOR_KPI_ID AS 分母指标ID
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
