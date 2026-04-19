-- ===========================================
-- 3.53.4 （四）抢救室滞留时间中位数
-- 数据源：手工填报
-- ===========================================

SET @data_source_id = (SELECT ID FROM DATASOURCE WHERE DATASOURCE_NAME = '手工填报' AND INVALID = 0 LIMIT 1);
SET @category_id = (SELECT ID FROM KPI_CATEGORY WHERE CATEGORY_NAME LIKE '%急诊医学专业%' AND INVALID = 0 LIMIT 1);
SET @create_user = 'system';
SET @data_source_param = '{}';

CALL sp_kpi_item_create(
    '（四）抢救室滞留时间中位数', @category_id, NULL, 'integer', 0, 'decrease', 'value', @data_source_id, @data_source_param,
    '抢救室滞留时间中位数是指将急诊抢救室患者从进入抢救室到离开抢救室（不包括死亡患者）的时间由长到短排序后取其中位数。', '《急诊医学专业医疗质量控制指标（2024 年版）》。', '反映急诊抢救室工作量、工作效率和急危重症救治质量的重要指标。',
    '手工填报', NULL, 'full', NULL, NULL,
    '将急诊抢救室患者从进入抢救室到离开抢救室（不包括死亡患者）的时间由长到短排序后取其中位数。当急诊抢救室患者数为奇数时，抢救室滞留时间中位数为全部急诊抢救患者抢救室滞留时间从长到短排序后取其中间患者的抢救室滞留时间；当急诊抢救室患者数为偶数时，抢救室滞留时间中位数为全部急诊抢救患者抢救室滞留时间从长到短排序后取中间两个患者的抢救室滞留时间。', '同上。', '分钟', '无', NULL,
    '就诊日期', '急诊科', '（四）抢救室滞留时间中位数',
    NULL, NULL, NULL, NULL,
    1.0000, 'sum',
    '["急诊科"]', '[]', '["住院号","病案号","患者姓名"]',
    @create_user, CONCAT('[{"category_id":', @category_id, ',"category_code":"3.53.4"}]'), NULL, NULL, NULL, NULL
);

SELECT ID AS 指标ID, KPI_NAME AS 指标名称, KPI_TYPE AS 指标类型 FROM KPI_ITEM WHERE KPI_NAME = '（四）抢救室滞留时间中位数' AND INVALID = 0 ORDER BY CREATE_TIME DESC LIMIT 1;
