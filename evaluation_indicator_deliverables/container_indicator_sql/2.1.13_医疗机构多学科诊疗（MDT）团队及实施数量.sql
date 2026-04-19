-- ===========================================
-- 2.1.13 医疗机构多学科诊疗（MDT）团队及实施数量（手工填报）
-- 两个指标：2.1.13.1 团队数量、2.1.13.2 实施数量；无数据源，采集模式为手工填报
-- ===========================================

SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%医疗服务能力%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';

-- 2.1.13.1 规范开展MDT的团队数量（手工填报）
CALL sp_kpi_item_create(
    '（十三）医疗机构多学科诊疗（MDT）团队数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    '规范开展MDT的团队指经医院正式备案并开展活动的多学科诊疗团队，需包含三个及以上相关学科，副高职称及以上专家组成相对固定的专家组、明确病种范围、相对固定的时间地点，季度内开展≥1次活动。', '《全面提升医疗质量行动计划（2023-2025年）》（国卫医政发〔2023〕12号）', '反映医疗机构规范开展MDT的团队规模。',
    NULL, NULL, 'full', NULL, '预约信息、患者病历资料、MDT讨论记录等。',
    '规范开展MDT的团队数量=Σ（规范开展MDT活动的团队数）。', 'MDT团队数量', '个', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.13.1"}]'), NULL, NULL, NULL, NULL
);

-- 2.1.13.2 MDT实施例数（手工填报）
CALL sp_kpi_item_create(
    '（十三）医疗机构多学科诊疗（MDT）实施数量', @category_id, NULL, 'integer', 0, 'increase', 'value', NULL, NULL,
    'MDT实施例数指通过完整MDT流程（含讨论记录、执行方案、效果评估）的实际诊疗病例数。', '《全面提升医疗质量行动计划（2023-2025年）》（国卫医政发〔2023〕12号）', '反映MDT实际开展规模。',
    NULL, NULL, 'full', NULL, '预约信息、患者病历资料、MDT讨论记录等。',
    'MDT实施例数=Σ（评价周期内完成MDT全流程管理的病例数）。', 'MDT实施数量', '次', NULL, '无',
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1.0000, 'sum',
    '[]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"2.1.13.2"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称 FROM KPI_ITEM WHERE KPI_NAME LIKE '%多学科诊疗（MDT）%' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 2;
