-- ========================================
-- 医疗指标管理系统 - 数据库设计
-- 数据库: d_hos_claude_0251230
-- ========================================

-- ========================================
-- 1. 业务基础库表
-- ========================================

-- 指标项表（存储基础指标项及其SQL查询逻辑）
DROP TABLE IF EXISTS `t_indicator_item`;
CREATE TABLE `t_indicator_item` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `item_code` VARCHAR(50) NOT NULL COMMENT '指标项编码（如 a0050）',
    `item_name` VARCHAR(200) NOT NULL COMMENT '指标项名称',
    `item_type` VARCHAR(20) NOT NULL COMMENT '指标项类型：COLLECTED(采集)、CALCULATED(计算)',
    `data_source` VARCHAR(100) COMMENT '数据源表名（如 D_MR、门诊就诊记录）',
    `query_sql` TEXT COMMENT 'SQL查询语句（支持参数占位符 #{startDate}、#{endDate}）',
    `aggregate_function` VARCHAR(20) COMMENT '聚合函数：COUNT、SUM、AVG、MAX、MIN',
    `aggregate_field` VARCHAR(100) COMMENT '聚合字段名',
    `calculation_condition` TEXT COMMENT '计算条件描述',
    `unit` VARCHAR(20) COMMENT '单位（人、人次、天、元、%等）',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `remark` VARCHAR(500) COMMENT '备注说明',
    `sort_order` INT DEFAULT 0 COMMENT '排序号',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_item_code` (`item_code`),
    KEY `idx_item_type` (`item_type`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标项表';

-- 指标表（存储指标及其计算表达式）
DROP TABLE IF EXISTS `t_indicator`;
CREATE TABLE `t_indicator` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `metric_code` VARCHAR(50) NOT NULL COMMENT '指标编码（如 10.3.1）',
    `metric_name` VARCHAR(200) NOT NULL COMMENT '指标名称',
    `parent_code` VARCHAR(50) COMMENT '父级指标编码',
    `indicator_level` INT NOT NULL DEFAULT 1 COMMENT '指标层级：1-一级、2-二级...',
    `is_leaf` TINYINT NOT NULL DEFAULT 0 COMMENT '是否叶子节点：0-否，1-是',
    `metric_type` VARCHAR(20) NOT NULL COMMENT '指标类型：QUANTITATIVE(定量)、QUALITATIVE(定性)',
    `calculation_type` VARCHAR(20) NOT NULL COMMENT '计算类型：ITEM(指标项)、EXPRESSION(表达式)',
    `expression` VARCHAR(500) COMMENT '计算表达式（如 SUM(a0050)/SUM(a0052)、a0050）',
    `related_items` VARCHAR(500) COMMENT '关联的指标项编码（JSON数组，如 ["a0050","a0052"]）',
    `unit` VARCHAR(20) COMMENT '单位',
    `support_dept_drill` TINYINT DEFAULT 0 COMMENT '是否支持科室下钻：0-否，1-是',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `remark` VARCHAR(500) COMMENT '备注说明',
    `sort_order` INT DEFAULT 0 COMMENT '排序号',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_metric_code` (`metric_code`),
    KEY `idx_parent_code` (`parent_code`),
    KEY `idx_is_leaf` (`is_leaf`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标表';

-- ========================================
-- 2. Cube维度表存储库
-- ========================================

-- 时间维度表
DROP TABLE IF EXISTS `t_time_dimension`;
CREATE TABLE `t_time_dimension` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `date_key` VARCHAR(20) NOT NULL COMMENT '日期键（格式：YYYYMMDD）',
    `full_date` DATE NOT NULL COMMENT '完整日期',
    `year` INT NOT NULL COMMENT '年份',
    `quarter` INT NOT NULL COMMENT '季度（1-4）',
    `month` INT NOT NULL COMMENT '月份（1-12）',
    `day` INT NOT NULL COMMENT '日（1-31）',
    `year_month` VARCHAR(10) NOT NULL COMMENT '年月（格式：YYYY-MM）',
    `year_quarter` VARCHAR(10) NOT NULL COMMENT '年季（格式：YYYY-Q1）',
    `week_of_year` INT COMMENT '年内第几周',
    `day_of_week` INT COMMENT '星期几（1-7）',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_date_key` (`date_key`),
    KEY `idx_full_date` (`full_date`),
    KEY `idx_year_month` (`year_month`),
    KEY `idx_year_quarter` (`year_quarter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='时间维度表';

-- 指标计算结果表
DROP TABLE IF EXISTS `t_indicator_result`;
CREATE TABLE `t_indicator_result` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `metric_code` VARCHAR(50) NOT NULL COMMENT '指标编码',
    `time_dimension` VARCHAR(20) NOT NULL COMMENT '时间维度：YEAR(年)、QUARTER(季)、MONTH(月)、DAY(日)',
    `time_value` VARCHAR(20) NOT NULL COMMENT '时间值（如 2025、2025-Q1、2025-01、2025-01-01）',
    `start_date` DATE NOT NULL COMMENT '统计开始日期',
    `end_date` DATE NOT NULL COMMENT '统计结束日期',
    `result_value` DECIMAL(20,4) COMMENT '计算结果值',
    `result_json` TEXT COMMENT '完整结果JSON（包含所有关联指标项的值）',
    `year_over_year` DECIMAL(10,4) COMMENT '同比增长率（%）',
    `month_over_month` DECIMAL(10,4) COMMENT '环比增长率（%）',
    `calculation_status` VARCHAR(20) NOT NULL DEFAULT 'SUCCESS' COMMENT '计算状态：SUCCESS、FAILED、PENDING',
    `error_message` TEXT COMMENT '错误信息',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_metric_time` (`metric_code`, `time_dimension`, `time_value`),
    KEY `idx_time_value` (`time_value`),
    KEY `idx_start_end_date` (`start_date`, `end_date`),
    KEY `idx_calculation_status` (`calculation_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标计算结果表';

-- 指标科室下钻结果表
DROP TABLE IF EXISTS `t_indicator_result_dept`;
CREATE TABLE `t_indicator_result_dept` (
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
    UNIQUE KEY `uk_metric_time_dept` (`metric_code`, `time_dimension`, `time_value`, `dept_code`),
    KEY `idx_result_id` (`result_id`),
    KEY `idx_dept_code` (`dept_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标科室下钻结果表';

-- ========================================
-- 3. 内部存储临时库表（用于计算过程中的临时数据存储）
-- ========================================

-- 指标项临时计算结果表（存储指标项的中间计算结果）
DROP TABLE IF EXISTS `t_indicator_item_temp`;
CREATE TABLE `t_indicator_item_temp` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `batch_id` VARCHAR(50) NOT NULL COMMENT '批次ID（UUID）',
    `item_code` VARCHAR(50) NOT NULL COMMENT '指标项编码',
    `start_date` DATE NOT NULL COMMENT '统计开始日期',
    `end_date` DATE NOT NULL COMMENT '统计结束日期',
    `result_value` DECIMAL(20,4) COMMENT '计算结果值',
    `dept_code` VARCHAR(50) COMMENT '科室编码（如果按科室计算）',
    `dept_name` VARCHAR(200) COMMENT '科室名称',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_batch_id` (`batch_id`),
    KEY `idx_item_code` (`item_code`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标项临时计算结果表（用于计算过程中暂存数据）';

-- ========================================
-- 4. 初始化时间维度数据（示例：生成2023-2026年的时间维度）
-- ========================================

-- 存储过程：生成时间维度数据
DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_generate_time_dimension`$$
CREATE PROCEDURE `sp_generate_time_dimension`(IN start_year INT, IN end_year INT)
BEGIN
    DECLARE current_date DATE;
    DECLARE end_date DATE;

    SET current_date = CONCAT(start_year, '-01-01');
    SET end_date = CONCAT(end_year, '-12-31');

    WHILE current_date <= end_date DO
        INSERT IGNORE INTO t_time_dimension (
            date_key,
            full_date,
            year,
            quarter,
            month,
            day,
            year_month,
            year_quarter,
            week_of_year,
            day_of_week
        ) VALUES (
            DATE_FORMAT(current_date, '%Y%m%d'),
            current_date,
            YEAR(current_date),
            QUARTER(current_date),
            MONTH(current_date),
            DAY(current_date),
            DATE_FORMAT(current_date, '%Y-%m'),
            CONCAT(YEAR(current_date), '-Q', QUARTER(current_date)),
            WEEK(current_date, 3),
            DAYOFWEEK(current_date)
        );

        SET current_date = DATE_ADD(current_date, INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

-- 调用存储过程生成2023-2026年的时间维度数据
CALL sp_generate_time_dimension(2023, 2026);

-- ========================================
-- 5. 示例数据初始化（肺炎相关指标）
-- ========================================

-- 插入指标项示例数据
INSERT INTO t_indicator_item (item_code, item_name, item_type, data_source, query_sql, aggregate_function, aggregate_field, calculation_condition, unit, status, sort_order) VALUES
('a0050', '肺炎（住院、成人）病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C LIKE ''J18%'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C LIKE ''J18%'') AND A14 >= 18',
'COUNT', '*', '出院日期=指定时间范围 AND (出院主要诊断 OR 出院其他诊断1) LIKE ("J13%" OR "J14%" OR "J15%" OR "J18%") AND 年龄≥18', '人', 1, 62),

('a0052', '肺炎（住院、成人）出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT SUM(B20) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C LIKE ''J18%'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C LIKE ''J18%'') AND A14 >= 18',
'SUM', 'B20', '出院日期=指定时间范围 AND (出院主要诊断 OR 出院其他诊断1) LIKE ("J13%" OR "J14%" OR "J15%" OR "J18%") AND 年龄≥18', '床日', 1, 64);

-- 插入指标示例数据
INSERT INTO t_indicator (metric_code, metric_name, parent_code, indicator_level, is_leaf, metric_type, calculation_type, expression, related_items, unit, support_dept_drill, status, sort_order) VALUES
('10', '重点病种质量控制指标', NULL, 1, 0, 'QUALITATIVE', 'EXPRESSION', NULL, NULL, NULL, 0, 1, 10),
('10.3', '肺炎（住院、成人）', '10', 2, 0, 'QUALITATIVE', 'EXPRESSION', NULL, NULL, NULL, 0, 1, 103),
('10.3.1', '肺炎（住院、成人）病种例数', '10.3', 3, 1, 'QUANTITATIVE', 'ITEM', 'a0050', '["a0050"]', '人', 1, 1, 1031),
('10.3.2', '肺炎（住院、成人）平均住院日', '10.3', 3, 1, 'QUANTITATIVE', 'EXPRESSION', 'a0052/a0050', '["a0050","a0052"]', '天', 1, 1, 1032),
('10.3.2.1', '肺炎（住院、成人）出院患者占用总床日数', '10.3.2', 4, 1, 'QUANTITATIVE', 'ITEM', 'a0052', '["a0052"]', '床日', 1, 1, 10321),
('10.3.2.2', '同期肺炎（住院、成人）病种例数', '10.3.2', 4, 1, 'QUANTITATIVE', 'ITEM', 'a0050', '["a0050"]', '人', 1, 1, 10322);

-- ========================================
-- 说明
-- ========================================
-- 1. 业务基础库表：存储指标项和指标的定义及配置
-- 2. Cube维度表：存储计算结果和时间维度数据
-- 3. 临时表：用于计算过程中的中间数据存储
-- 4. 字段 query_sql 支持参数占位符：#{startDate}、#{endDate}、#{deptCode} 等
-- 5. 指标表达式支持：
--    - 单个指标项：a0050
--    - 四则运算：a0052/a0050
--    - 聚合函数：SUM(a0050)/SUM(a0052)
--    - 复杂表达式：(a0050-a0051)/a0052*100
-- 6. 时间维度支持：按年、按季、按月、按日统计
-- 7. 支持科室下钻功能
