-- ===========================================
-- 2.2.1.9 血管内导管相关血流感染发生率（手工填报，单位：例/千导管日）
-- 创建日期：2026-02
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%年度国家医疗质量安全目标改进情况%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 分子 2.2.1.9.1
CALL sp_kpi_item_create(
    '血管内导管相关血流感染发生例次数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '住院患者血管内导管相关血流感染发生总例数。', '《2.2.1 年度安全目标.csv》', '分子：指住院患者血管内导管相关血流感染发生总例数。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院患者血管内导管相关血流感染发生总例数。分母：指同期住院患者使用血管内导管留置的总天数。', '血管内导管相关血流感染发生例次数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.9.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '血管内导管相关血流感染发生例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 2.2.1.9.2
CALL sp_kpi_item_create(
    '同期患者使用血管内导管留置总天数', @category_id, NULL, 'integer', 0, 'decrease', 'value', NULL, NULL,
    '同期住院患者使用血管内导管留置的总天数。', '《2.2.1 年度安全目标.csv》', '分母：指同期住院患者使用血管内导管留置的总天数。',
    NULL, NULL, 'full', NULL, NULL,
    '分母：指同期住院患者使用血管内导管留置的总天数。', '同期患者使用血管内导管留置总天数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.9.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期患者使用血管内导管留置总天数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 2.2.1.9 例/千导管日（比率系数 1000）
CALL sp_kpi_item_create(
    '9.血管内导管相关血流感染发生率', @category_id, NULL, 'decimal', 2, 'decrease', 'ratio', NULL, NULL,
    '血管内导管相关血流感染发生率是指使用血管内导管住院患者中新发血管内导管相关血流感染的发病频率。单位：例/千导管日。', '《2.2.1 年度安全目标.csv》', '反映血管内导管相关血流感染情况及医疗机构院感防控能力。',
    NULL, NULL, 'full', NULL, NULL,
    '分子：指住院患者血管内导管相关血流感染发生总例数。分母：指同期住院患者使用血管内导管留置的总天数。血管内导管相关感染是指留置血管导管期间及拔除血管导管后48小时内发生的原发性、且与其他部位感染无关的感染。', '血管内导管相关血流感染发生率', '例/千导管日', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1000.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.1.9"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '9.血管内导管相关血流感染发生率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
