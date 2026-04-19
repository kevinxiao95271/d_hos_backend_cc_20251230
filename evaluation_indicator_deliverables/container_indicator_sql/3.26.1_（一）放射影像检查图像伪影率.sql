-- ===========================================
-- 3.26.1 （一）放射影像检查图像伪影率
-- 数据源：手工填报；分子：放射影像检查出现不良伪影的例次数，分母：同期放射影像检查总例次数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%放射影像专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '放射影像检查出现不良伪影的例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '放射影像专业医疗质量控制指标（2024版）。', '反映放射影像检查图像伪影率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '放射影像检查包括CT和MRI，每1份检查报告为1个检查例次。不良伪影指成像过程中产生的与被扫描组织结构无关的异常影像，降低图像质量、影响病变分析诊断。', '无', '无', '无', NULL,
    '统计日期', '全院', '放射影像检查出现不良伪影的例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.1.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '放射影像检查出现不良伪影的例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期放射影像检查总例次数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '放射影像专业医疗质量控制指标（2024版）。', '反映放射影像检查图像伪影率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期放射影像检查总例次数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期放射影像检查总例次数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.1.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期放射影像检查总例次数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（一）放射影像检查图像伪影率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '放射影像检查出现不良伪影的例次数占同期放射影像检查总例次数的比例。', '放射影像专业医疗质量控制指标（2024版）。', '反映放射影像检查图像伪影情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：放射影像检查出现不良伪影的例次数。分母：同期放射影像检查总例次数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.26.1"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（一）放射影像检查图像伪影率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
