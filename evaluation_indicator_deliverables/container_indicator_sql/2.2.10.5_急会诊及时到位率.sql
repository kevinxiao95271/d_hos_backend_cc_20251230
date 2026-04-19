-- ===========================================
-- 2.2.10.5 急会诊及时到位率（手工填报，分子+分母+比率）
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗质量安全核心制度%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

CALL sp_kpi_item_create(
    '急会诊记录中10分钟内到位的急会诊次数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '急会诊记录中10分钟内到位的急会诊次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分子。',
    NULL, NULL, 'full', NULL, '无',
    '急会诊范围包括当患者罹患疾病超出本科室诊疗范围和处置能力，且经评估可能随时危及生命，需要院内其他科室医师立刻协助诊疗、参与抢救所发出的会诊申请。', '急会诊记录中10分钟内到位的急会诊次数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '急会诊记录中10分钟内到位的急会诊次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期急会诊总次数', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '同期急会诊总次数。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '分母。',
    NULL, NULL, 'full', NULL, '无',
    '分母。', '同期急会诊总次数', '无', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期急会诊总次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '急会诊及时到位率', @category_id, NULL, 'percent', 2, 'increase', 'ratio', NULL, NULL,
    '急会诊请求发出后，10分钟内到达现场的急会诊次数占同期急会诊总次数的比例。', '《医疗质量安全核心制度落实情况监测指标（2025 版）》。', '反映急会诊制度执行的规范性。',
    NULL, NULL, 'full', NULL, '无',
    '急会诊范围包括当患者罹患疾病超出本科室诊疗范围和处置能力，且经评估可能随时危及生命，需要院内其他科室医师立刻协助诊疗、参与抢救所发出的会诊申请。', '急会诊及时到位率', '百分比（%）', NULL, '无',
    NULL, NULL, NULL, @numerator_kpi_id, @denominator_kpi_id, NULL, NULL, 1.0000, 'sum', '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.2.10.5"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME = '急会诊及时到位率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
