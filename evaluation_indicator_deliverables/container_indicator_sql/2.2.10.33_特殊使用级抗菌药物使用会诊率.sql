-- ===========================================
-- 2.2.10.33 特殊使用级抗菌药物使用会诊率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '特殊使用级抗菌药物使用医嘱与会诊记录相对应的医嘱数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '特殊使用级抗菌药物使用医嘱与会诊记录相对应的医嘱数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '使用医嘱与会诊记录相对应是指经抗菌药物管理工作机构指定的专业技术人员会诊同意后按程序合理使用。', '特殊使用级抗菌药物使用医嘱与会诊记录相对应的医嘱数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.33.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '特殊使用级抗菌药物使用医嘱与会诊记录相对应的医嘱数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期特殊使用级抗菌药物使用医嘱总数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期特殊使用级抗菌药物使用医嘱总数量。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期特殊使用级抗菌药物使用医嘱总数量', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.33.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期特殊使用级抗菌药物使用医嘱总数量' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '特殊使用级抗菌药物使用会诊率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '特殊使用级抗菌药物使用医嘱与会诊记录相对应的医嘱数量占同期特殊使用级抗菌药物使用医嘱总数量的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映特殊使用级抗菌药物使用的规范性。',
    NULL, NULL, 'full', NULL, '无',
    '特殊使用级抗菌药物包括如第三、四代头孢菌素、碳青霉烯类、万古霉素等。使用医嘱与会诊记录相对应是指经指定专业技术人员会诊同意后按程序合理使用。', '特殊使用级抗菌药物使用会诊率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.33"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '特殊使用级抗菌药物使用会诊率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
