-- ===========================================
-- 2.2.10.29 三、四级手术实际开展率（手工填报，分子+分母+比率）
-- 分母为备案术种数，需备案数据或手工填报
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.10.29.1
CALL sp_kpi_item_create(
    '实际开展的三、四级手术术种数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '实际开展的三、四级手术术种数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '本指标中的三、四级手术备案是指按《医疗机构手术分级管理办法》（国卫办医政发〔2022〕18 号）要求，向核发《医疗机构执业许可证》的卫生健康行政部门报送本机构三、四级手术管理目录信息。', '实际开展的三、四级手术术种数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.29.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '实际开展的三、四级手术术种数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.10.29.2
CALL sp_kpi_item_create(
    '同期备案的三、四级手术术种数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期备案的三、四级手术术种数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '本指标中的三、四级手术备案是指按《医疗机构手术分级管理办法》（国卫办医政发〔2022〕18 号）要求，向核发《医疗机构执业许可证》的卫生健康行政部门报送本机构三、四级手术管理目录信息。', '同期备案的三、四级手术术种数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.29.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期备案的三、四级手术术种数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.10.29
CALL sp_kpi_item_create(
    '三、四级手术实际开展率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '实际开展的三、四级手术术种数占同期备案的三、四级手术术种数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映手术分级的合理性。',
    NULL, NULL, 'full', NULL, '无',
    '本指标中的三、四级手术备案是指按《医疗机构手术分级管理办法》（国卫办医政发〔2022〕18 号）要求，向核发《医疗机构执业许可证》的卫生健康行政部门报送本机构三、四级手术管理目录信息。', '三、四级手术实际开展率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.29"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型
FROM KPI_ITEM WHERE KPI_NAME = '三、四级手术实际开展率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
