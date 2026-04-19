-- ===========================================
-- 单病种应上报资源消耗指标注册脚本
-- 指标编码：4.40.2.1（以CSV为准）
-- 指标名称：口腔种植术种植体次均费用
-- 创建日期：2026-02
-- 说明：分母编码 4.40.2.1.2 与 4.40.1.1.2（同期手术患者例数）同源，须先执行 4.40.1.1 注册脚本。
-- ===========================================

SET @data_source_id = (
    SELECT ID FROM DATASOURCE
    WHERE DATASOURCE_NAME = '单病种应上报资源消耗查询' AND INVALID = 0
    LIMIT 1
);

SET @category_id = (
    SELECT ID FROM KPI_CATEGORY
    WHERE CATEGORY_NAME LIKE '%口腔种植术%' AND INVALID = 0
    LIMIT 1
);

SET @create_user = 'system';
SET @data_source_param = '{"p_date_type":"out","p_disease_code":"DENTAL_IMPLANT"}';

-- 分子：所有患者种植体总费用（sum 种植体费用）
SET @numerator_kpi_name = '口腔种植术种植体总费用';
SET @numerator_category_code = '4.40.2.1.1';
CALL sp_kpi_item_create(
    @numerator_kpi_name, @category_id, NULL, 'decimal', 2, 'monitor', 'value', NULL, @data_source_id, @data_source_param,
    '所有患者种植体总费用', '《河北省三级医院评审标准实施细则（2025年版）》第四章。', '评价口腔种植术种植体消耗情况',
    '单病种应上报资源消耗查询', NULL, 'full', NULL, NULL, '分子：所有患者种植体总费用。分母：所有患者使用种植体总数。', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', '种植体费用', NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间","种植体费用"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @numerator_category_code, '"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @numerator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

-- 分母：与 4.40.1.1.2 同源时为同期手术患者例数；无源指标时直连「种植体数量」汇总
SET @denominator_kpi_name = '口腔种植术种植体使用总数';
SET @denominator_category_code = '4.40.2.1.2';
SET @source_kpi_id = (
    SELECT k.ID FROM KPI_ITEM k
    INNER JOIN KPI_ITEM_CATEGORY_REL r ON r.KPI_ID = k.ID AND r.CATEGORY_CODE = '4.40.1.1.2'
    WHERE k.INVALID = 0 LIMIT 1
);

CALL sp_kpi_item_create(
    @denominator_kpi_name, @category_id, NULL, 'integer', 0, 'monitor', 'value', NULL, IF(@source_kpi_id IS NOT NULL, NULL, @data_source_id),
    IF(@source_kpi_id IS NOT NULL, NULL, @data_source_param),
    '所有患者使用种植体总数', '《河北省三级医院评审标准实施细则（2025年版）》第四章。', '评价口腔种植术种植体消耗情况',
    IF(@source_kpi_id IS NOT NULL, '与指标编码4.40.1.1.2（同期手术患者例数）同源，采集源于该指标', '单病种应上报资源消耗查询'), NULL, 'full', NULL, NULL, '分子：所有患者种植体总费用。分母：所有患者使用种植体总数。（与4.40.1.1.2一致）', '无', '无', NULL, NULL,
    '出院日期', '出院科室名称', IF(@source_kpi_id IS NOT NULL, '同期手术患者例数', '种植体数量'), NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间","种植体数量"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @denominator_category_code, '"}]'), NULL, NULL, IF(@source_kpi_id IS NOT NULL, 'datasource', NULL), NULL, @source_kpi_id, NULL, 1
);
SET @denominator_kpi_id = (
    SELECT ID FROM KPI_ITEM
    WHERE KPI_NAME = @denominator_kpi_name AND INVALID = 0 AND KPI_TYPE = 'value'
    ORDER BY CREATE_TIME DESC LIMIT 1
);

UPDATE KPI_ITEM SET SOURCE_KPI_ID = @source_kpi_id WHERE ID = @denominator_kpi_id AND @source_kpi_id IS NOT NULL;

SET @kpi_name = '口腔种植术种植体次均费用';
SET @category_code = '4.40.2.1';
CALL sp_kpi_item_create(
    @kpi_name, @category_id, NULL, 'decimal', 2, 'monitor', 'ratio', NULL, @data_source_id, @data_source_param,
    '所有患者种植体总费用除以所有患者使用种植体总数', '《河北省三级医院评审标准实施细则（2025年版）》第四章。', '评价口腔种植术种植体消耗情况，反映医疗成本控制',
    '单病种应上报资源消耗查询', NULL, 'full', NULL, NULL, '分子：所有患者种植体总费用。分母：所有患者使用种植体总数。', '元', '无', NULL, NULL,
    '出院日期', '出院科室名称', NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '["出院科室名称"]', '[]', '["患者ID","住院号","病案号","出院时间","种植体费用","种植体数量"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"', @category_code, '"}]'), NULL, NULL, NULL, NULL, NULL, NULL, NULL
);

SELECT k.ID AS 指标ID, k.KPI_NAME AS 指标名称, k.KPI_TYPE AS 指标类型
FROM KPI_ITEM k WHERE k.KPI_NAME = @kpi_name AND k.INVALID = 0 ORDER BY k.CREATE_TIME DESC LIMIT 1;
