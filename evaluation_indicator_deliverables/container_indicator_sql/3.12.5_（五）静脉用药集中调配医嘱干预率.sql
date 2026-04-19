-- ===========================================
-- 3.12.5 （五）静脉用药集中调配医嘱干预率
-- 数据源：手工填报；分子：医师同意修改的不适宜静脉用药集中调配医嘱条目数，分母：同期静脉用药集中调配医嘱总条目数
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%药事管理专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '医师同意修改的不适宜静脉用药集中调配医嘱条目数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映静脉用药集中调配医嘱干预率分子。',
    '手工填报', NULL, 'full', NULL, NULL,
    '药师审核发现不适宜医嘱，经沟通医师同意修改的静脉用药集中调配医嘱条目数。', '无', '无', '无', NULL,
    '统计日期', '全院', '医师同意修改的不适宜静脉用药集中调配医嘱条目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.5.1"}]'), NULL, NULL, NULL, NULL
);
SET @numerator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '医师同意修改的不适宜静脉用药集中调配医嘱条目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '同期静脉用药集中调配医嘱总条目数', @category_id, NULL, 'integer', 0, 'monitor', 'value', @data_source_id, @data_source_param,
    '无', '药事管理专业医疗质量控制指标（2020版）。', '反映静脉用药集中调配医嘱干预率分母。',
    '手工填报', NULL, 'full', NULL, NULL,
    '同期静脉用药集中调配医嘱总条目数。', '无', '无', '无', NULL,
    '统计日期', '全院', '同期静脉用药集中调配医嘱总条目数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.5.2"}]'), NULL, NULL, NULL, NULL
);
SET @denominator_kpi_id = (SELECT ID FROM KPI_ITEM WHERE KPI_NAME = '同期静脉用药集中调配医嘱总条目数' AND INVALID = 0 AND KPI_TYPE = 'value' ORDER BY CREATE_TIME DESC LIMIT 1);

CALL sp_kpi_item_create(
    '（五）静脉用药集中调配医嘱干预率', @category_id, NULL, 'percent', 2, 'monitor', 'ratio', @data_source_id, @data_source_param,
    '药师审核静脉用药集中调配医嘱时发现不适宜医嘱，经过沟通，医师同意对不适宜静脉用药集中调配医嘱进行修改的医嘱条目数占同期静脉用药集中调配医嘱总条目数的比例。', '药事管理专业医疗质量控制指标（2020版）。', '反映静脉用药调配干预情况。',
    '手工填报', NULL, 'full', NULL, NULL,
    '分子：医师同意修改的不适宜静脉用药集中调配医嘱条目数。分母：同期静脉用药集中调配医嘱总条目数。', '无', '百分比（%）', '无', NULL,
    '统计日期', '全院', NULL,
    @numerator_kpi_id, @denominator_kpi_id, NULL, NULL,
    1.0000, 'sum',
    '["全院"]', '[]', '[]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.12.5"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（五）静脉用药集中调配医嘱干预率' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
