-- ===========================================
-- 3.28.8 住院患者首次行 18F-FDG PET/CT 诊断符合率（NM-08）
-- 数据源：手工填报
-- 创建日期：2026-02
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%核医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

-- 分子 3.28.8.1
CALL sp_kpi_item_create(
    '在本医疗机构首次行 18F-FDGPET/CT 住院患者的报告结论与病理结果相符合的例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映 18F-FDG PET/CT 检查诊断质量与准确性。 附表 要素 描述 项目数 临床病史 显像适应证病变的类型和位置与本次检查相关的治疗史 3 操作流程 放射性药物名称 放射性药物注射方式 显像时间（从注射到显像的时间） 使用的辅助药物 精确的扫描范围 CT 相关参数（包括口服或静脉注射造影剂） 6 前后显像对比 是否与上次 PET 显像结果对比，注明日期 是否与上次非 PET 显像（CT 或MRI）结果对比，注明日期 2 报告描述 病变位置，大小/程度，异常 18F-FDG 摄取的强度 异常的 PET 发现与同机 CT 或其他影像的相关性 意外的 PET 发现（如果有） 意外的 CT 发现（如果有） 4 报告结论 明确的正常或异常 对描述的解读而非重述 简明的鉴别诊断 对于随访的建议 4 报告图像 报告包含病变相关图像 报告重点病变图像有注释明确的图注 2 总项目数 21 备注：以上报告要素需参考中华医学会核医学分会翻译的《18F-FDGPET/CT肿瘤 显像报告书写指南》。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '检查日期', '核医学科', '在本医疗机构首次行 18F-FDGPET/CT 住院患者的报告结论与病理结果相符合的例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.8.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '在本医疗机构首次行 18F-FDGPET/CT 住院患者的报告结论与病理结果相符合的例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 分母 3.28.8.2
CALL sp_kpi_item_create(
    '首次行 18F-FDGPET/CT 住院患者且有病理结果的总例数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '无', '反映 18F-FDG PET/CT 检查诊断质量与准确性。 附表 要素 描述 项目数 临床病史 显像适应证病变的类型和位置与本次检查相关的治疗史 3 操作流程 放射性药物名称 放射性药物注射方式 显像时间（从注射到显像的时间） 使用的辅助药物 精确的扫描范围 CT 相关参数（包括口服或静脉注射造影剂） 6 前后显像对比 是否与上次 PET 显像结果对比，注明日期 是否与上次非 PET 显像（CT 或MRI）结果对比，注明日期 2 报告描述 病变位置，大小/程度，异常 18F-FDG 摄取的强度 异常的 PET 发现与同机 CT 或其他影像的相关性 意外的 PET 发现（如果有） 意外的 CT 发现（如果有） 4 报告结论 明确的正常或异常 对描述的解读而非重述 简明的鉴别诊断 对于随访的建议 4 报告图像 报告包含病变相关图像 报告重点病变图像有注释明确的图注 2 总项目数 21 备注：以上报告要素需参考中华医学会核医学分会翻译的《18F-FDGPET/CT肿瘤 显像报告书写指南》。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '检查日期', '核医学科', '首次行 18F-FDGPET/CT 住院患者且有病理结果的总例数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.8.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '首次行 18F-FDGPET/CT 住院患者且有病理结果的总例数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

-- 比率 3.28.8
CALL sp_kpi_item_create(
    '住院患者首次行 18F-FDG PET/CT 诊断符合率（NM-08）', @category_id, NULL, 'integer', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '在本医疗机构首次行 18F-FDGPET/CT 住院患者的报告结论与病理结果相符合的例数占同期首次行 18F-FDGPET/CT 住院患者且有病理结果的总例数的比例。', '无', '反映 18F-FDG PET/CT 检查诊断质量与准确性。 附表 要素 描述 项目数 临床病史 显像适应证病变的类型和位置与本次检查相关的治疗史 3 操作流程 放射性药物名称 放射性药物注射方式 显像时间（从注射到显像的时间） 使用的辅助药物 精确的扫描范围 CT 相关参数（包括口服或静脉注射造影剂） 6 前后显像对比 是否与上次 PET 显像结果对比，注明日期 是否与上次非 PET 显像（CT 或MRI）结果对比，注明日期 2 报告描述 病变位置，大小/程度，异常 18F-FDG 摄取的强度 异常的 PET 发现与同机 CT 或其他影像的相关性 意外的 PET 发现（如果有） 意外的 CT 发现（如果有） 4 报告结论 明确的正常或异常 对描述的解读而非重述 简明的鉴别诊断 对于随访的建议 4 报告图像 报告包含病变相关图像 报告重点病变图像有注释明确的图注 2 总项目数 21 备注：以上报告要素需参考中华医学会核医学分会翻译的《18F-FDGPET/CT肿瘤 显像报告书写指南》。',
    '手工填报', NULL, 'full', NULL, NULL,
    '无', '无', '无', '无', NULL,
    '检查日期', '核医学科', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["核医学科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.28.8"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '住院患者首次行 18F-FDG PET/CT 诊断符合率（NM-08）' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
