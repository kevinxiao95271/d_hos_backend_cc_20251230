-- ===========================================
-- 国家限制类医疗技术指标注册脚本
-- 指标编码：5.1.2.2
-- 指标名称：总胰岛当量
-- 创建日期：2026-02-06
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '同种胰岛移植技术数据源' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%国家限制类医疗技术%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 创建指标
SET @kpi_name = '总胰岛当量';
SET @category_code = '5.1.2.2';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'integer', 0, 'increase', 'value', @data_source_id, '{"p_date_type":"out"}',
    '胰岛当量（Islet equivalent quantity，IEQ）是一种胰岛计数方法，一个直径 150μm 的胰岛为 1 个胰岛当量。总胰岛当量是指样本中胰岛当量总数。', '《同种胰岛移植技术临床应用管理规范（2022 版）》《同种胰岛移植技术临床应用质量控制指标（2022 版）》。', '用于计算获取胰岛数量，体现胰岛提取技术水平的指标。',
    '同种胰岛移植技术数据源', NULL, '胰岛当量（Islet equivalent quantity，IEQ）是一种胰岛计数方法，一个直径150μm的胰岛为1个胰岛当量。总胰岛当量是指样本中胰岛当量总数。', '胰岛当量', '医院胰岛制备及检测过程记录和检测报告。', NULL,
    '出院日期', '出院科室名称', '指标值', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称","入院科室名称"]', '[]', '["患者ID","住院号","患者姓名","病案号","出院时间"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"5.1.2.2"}]'), NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
