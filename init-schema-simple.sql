-- 简化版schema.sql - 只创建必要的表结构
-- 用于快速测试

USE d_hos_claude_0251230;

-- 1. 指标项表
CREATE TABLE IF NOT EXISTS `t_indicator_item` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `item_code` VARCHAR(50) NOT NULL COMMENT '指标项编码',
    `item_name` VARCHAR(200) NOT NULL COMMENT '指标项名称',
    `item_type` VARCHAR(20) NOT NULL COMMENT '指标项类型',
    `data_source` VARCHAR(100) COMMENT '数据源表名',
    `query_sql` TEXT COMMENT 'SQL查询语句',
    `aggregate_function` VARCHAR(20) COMMENT '聚合函数',
    `aggregate_field` VARCHAR(100) COMMENT '聚合字段',
    `calculation_condition` TEXT COMMENT '计算条件描述',
    `unit` VARCHAR(20) COMMENT '单位',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态',
    `remark` VARCHAR(500) COMMENT '备注说明',
    `sort_order` INT DEFAULT 0 COMMENT '排序号',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_item_code` (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标项表';

-- 2. 指标表
CREATE TABLE IF NOT EXISTS `t_indicator` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `metric_code` VARCHAR(50) NOT NULL COMMENT '指标编码',
    `metric_name` VARCHAR(200) NOT NULL COMMENT '指标名称',
    `parent_code` VARCHAR(50) COMMENT '父级指标编码',
    `indicator_level` INT NOT NULL DEFAULT 1 COMMENT '指标层级',
    `is_leaf` TINYINT NOT NULL DEFAULT 0 COMMENT '是否叶子节点',
    `metric_type` VARCHAR(20) NOT NULL COMMENT '指标类型',
    `calculation_type` VARCHAR(20) NOT NULL COMMENT '计算类型',
    `expression` VARCHAR(500) COMMENT '计算表达式',
    `related_items` VARCHAR(500) COMMENT '关联的指标项编码',
    `unit` VARCHAR(20) COMMENT '单位',
    `support_dept_drill` TINYINT DEFAULT 0 COMMENT '是否支持科室下钻',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态',
    `remark` VARCHAR(500) COMMENT '备注说明',
    `sort_order` INT DEFAULT 0 COMMENT '排序号',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_metric_code` (`metric_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标表';

-- 3. 指标结果表
CREATE TABLE IF NOT EXISTS `t_indicator_result` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `metric_code` VARCHAR(50) NOT NULL COMMENT '指标编码',
    `time_dimension` VARCHAR(20) NOT NULL COMMENT '时间维度',
    `time_value` VARCHAR(20) NOT NULL COMMENT '时间值',
    `start_date` DATE NOT NULL COMMENT '统计开始日期',
    `end_date` DATE NOT NULL COMMENT '统计结束日期',
    `result_value` DECIMAL(20,4) COMMENT '计算结果值',
    `result_json` TEXT COMMENT '完整结果JSON',
    `year_over_year` DECIMAL(10,4) COMMENT '同比增长率',
    `month_over_month` DECIMAL(10,4) COMMENT '环比增长率',
    `calculation_status` VARCHAR(20) NOT NULL DEFAULT 'SUCCESS' COMMENT '计算状态',
    `error_message` TEXT COMMENT '错误信息',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_metric_time` (`metric_code`, `time_dimension`, `time_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标计算结果表';

-- 4. 科室下钻结果表
CREATE TABLE IF NOT EXISTS `t_indicator_result_dept` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `result_id` BIGINT NOT NULL COMMENT '关联的指标结果ID',
    `metric_code` VARCHAR(50) NOT NULL COMMENT '指标编码',
    `time_dimension` VARCHAR(20) NOT NULL COMMENT '时间维度',
    `time_value` VARCHAR(20) NOT NULL COMMENT '时间值',
    `dept_code` VARCHAR(50) NOT NULL COMMENT '科室编码',
    `dept_name` VARCHAR(200) NOT NULL COMMENT '科室名称',
    `result_value` DECIMAL(20,4) COMMENT '科室维度计算结果值',
    `result_json` TEXT COMMENT '完整结果JSON',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_metric_time_dept` (`metric_code`, `time_dimension`, `time_value`, `dept_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标科室下钻结果表';

-- 插入测试数据
INSERT INTO t_indicator_item (item_code, item_name, item_type, data_source, query_sql, unit, status, sort_order) VALUES
('a0050', '肺炎（住院、成人）病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C LIKE ''J18%'') AND A14 >= 18',
'人', 1, 62),
('a0052', '肺炎（住院、成人）出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT IFNULL(SUM(B20), 0) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C LIKE ''J18%'') AND A14 >= 18',
'床日', 1, 64)
ON DUPLICATE KEY UPDATE query_sql = VALUES(query_sql);

INSERT INTO t_indicator (metric_code, metric_name, parent_code, indicator_level, is_leaf, metric_type, calculation_type, expression, related_items, unit, support_dept_drill, status, sort_order) VALUES
('10', '重点病种质量控制指标', NULL, 1, 0, 'QUALITATIVE', 'EXPRESSION', NULL, NULL, NULL, 0, 1, 10),
('10.3', '肺炎（住院、成人）', '10', 2, 0, 'QUALITATIVE', 'EXPRESSION', NULL, NULL, NULL, 0, 1, 103),
('10.3.1', '肺炎（住院、成人）病种例数', '10.3', 3, 1, 'QUANTITATIVE', 'ITEM', 'a0050', '["a0050"]', '人', 1, 1, 1031),
('10.3.2', '肺炎（住院、成人）平均住院日', '10.3', 3, 1, 'QUANTITATIVE', 'EXPRESSION', 'a0052/a0050', '["a0050","a0052"]', '天', 1, 1, 1032)
ON DUPLICATE KEY UPDATE expression = VALUES(expression);

SELECT 'Schema created successfully!' as status;
