-- ===========================================
-- 2.2.10.31 危急值报告时间（监测达标，中位数，手工填报）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '危急值报告时间', @category_id, NULL, 'decimal', 2, 'target', 'value', NULL, NULL,
    '将出现危急值到临床科室获取危急值的时间，由长到短排序后取其中位数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映危急值上报的效率。',
    NULL, NULL, 'full', NULL, '无',
    'n为实际报告的危急值项目数；X为出现危急值到临床科室获取危急值的时间。分别计算住院、门诊、急诊危急值报告时间。', '危急值报告时间', '值', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.31"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '危急值报告时间' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
