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
    `metric_pool` VARCHAR(20) DEFAULT 'POOL_NATIONAL' COMMENT '指标池：POOL_NATIONAL(国考)、POOL_GRADE(等级评审)',
    `metric_category` VARCHAR(50) COMMENT '指标分类：医疗质量、运营效率、财务成本等',
    `business_direction` VARCHAR(100) COMMENT '业务方向（JSON数组）：INPATIENT(住院)、OUTPATIENT(门诊)、INSPECTION(检查室)、HOSPITAL(医院级)等，多个用逗号分隔',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `remark` VARCHAR(500) COMMENT '备注说明',
    `sort_order` INT DEFAULT 0 COMMENT '排序号',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_metric_code` (`metric_code`),
    KEY `idx_parent_code` (`parent_code`),
    KEY `idx_is_leaf` (`is_leaf`),
    KEY `idx_metric_pool` (`metric_pool`),
    KEY `idx_business_direction` (`business_direction`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标表';

-- ========================================
-- 2. 科室与用户权限管理表
-- ========================================

-- 科室表
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
    `dept_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `dept_code` VARCHAR(50) NOT NULL COMMENT '本地科室编码',
    `dept_name` VARCHAR(100) NOT NULL COMMENT '科室名称',
    `parent_id` BIGINT DEFAULT 0 COMMENT '上级科室ID（0表示一级科室）',
    `dept_level` INT DEFAULT 1 COMMENT '科室级别：1-一级科室，2-二级科室',
    `dept_type` VARCHAR(20) DEFAULT 'CLINICAL' COMMENT '科室类型：CLINICAL(临床)、MEDICAL_TECH(医技)、ADMIN(行政)、MGMT(管理)',
    `is_mgmt_dept` TINYINT DEFAULT 0 COMMENT '是否管理科室（1-是，0-否）。管理科室默认拥有全院数据权限',
    `default_business_direction` VARCHAR(100) COMMENT '科室默认业务方向（JSON数组）：INPATIENT(住院)、OUTPATIENT(门诊)、INSPECTION(检查室)等，多个用逗号分隔。用户可覆盖',
    `std_dept_code` VARCHAR(50) COMMENT '对照RC023国家编码',
    `status` CHAR(1) DEFAULT '0' COMMENT '状态：0-启用，1-停用',
    `sort_order` INT DEFAULT 0 COMMENT '排序号',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`dept_id`),
    UNIQUE KEY `uk_dept_code` (`dept_code`),
    KEY `idx_parent_id` (`parent_id`),
    KEY `idx_dept_level` (`dept_level`),
    KEY `idx_is_mgmt_dept` (`is_mgmt_dept`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='科室表';

-- 角色表
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
    `role_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    `role_name` VARCHAR(30) NOT NULL COMMENT '角色名称',
    `role_key` VARCHAR(100) NOT NULL COMMENT '角色权限字符串',
    `role_sort` INT DEFAULT 0 COMMENT '显示顺序',
    `data_scope` INT DEFAULT 10 COMMENT '数据范围（10：全部数据权限 30：自定数据权限 50：本部门数据权限 70：本部门及以下数据权限 90：仅本人数据权限）',
    `status` CHAR(1) DEFAULT '0' COMMENT '角色状态（0正常 1停用）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色信息表';

-- 用户表
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
    `user_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `real_name` VARCHAR(50) COMMENT '真实姓名',
    `dept_id` BIGINT NOT NULL COMMENT '所属科室ID（必填）',
    `role_id` BIGINT COMMENT '角色ID',
    `data_scope` INT DEFAULT 10 COMMENT '数据权限范围：10-本人，30-本部门及下属，50-全部数据',
    `business_direction_preference` VARCHAR(100) COMMENT '业务方向偏好（JSON数组）：INPATIENT(住院)、OUTPATIENT(门诊)、INSPECTION(检查室)等。为空表示继承科室默认值',
    `status` CHAR(1) DEFAULT '0' COMMENT '状态：0-启用，1-停用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_dept_id` (`dept_id`),
    KEY `idx_role_id` (`role_id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 指标科室关联表（指标仅挂载到一级科室）
DROP TABLE IF EXISTS `t_indicator_dept_scope`;
CREATE TABLE `t_indicator_dept_scope` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `metric_code` VARCHAR(50) NOT NULL COMMENT '指标编码',
    `root_dept_id` BIGINT NOT NULL COMMENT '归口一级科室ID',
    `is_primary_owner` TINYINT DEFAULT 1 COMMENT '是否主要负责科室（1-是，0-否）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_metric_dept` (`metric_code`, `root_dept_id`),
    KEY `idx_metric_code` (`metric_code`),
    KEY `idx_root_dept_id` (`root_dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标科室关联表（指标仅挂载到一级科室）';

-- 菜单权限表
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
    `menu_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
    `menu_name` VARCHAR(50) NOT NULL COMMENT '菜单名称',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父菜单ID',
    `order_num` INT DEFAULT 0 COMMENT '显示顺序',
    `path` VARCHAR(200) DEFAULT '' COMMENT '路由地址',
    `component` VARCHAR(255) DEFAULT NULL COMMENT '组件路径',
    `is_frame` INT DEFAULT 1 COMMENT '是否为外链（0是 1否）',
    `menu_type` CHAR(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
    `visible` CHAR(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
    `status` CHAR(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
    `perms` VARCHAR(100) DEFAULT NULL COMMENT '权限标识',
    `icon` VARCHAR(100) DEFAULT '#' COMMENT '菜单图标',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT '' COMMENT '备注',
    PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';

-- 角色菜单关联表
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    `menu_id` BIGINT NOT NULL COMMENT '菜单ID',
    PRIMARY KEY (`role_id`, `menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色菜单关联表';

-- 用户业务方向偏好表（支持更灵活的个性化配置）
DROP TABLE IF EXISTS `sys_user_business_preference`;
CREATE TABLE `sys_user_business_preference` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `business_direction` VARCHAR(50) NOT NULL COMMENT '业务方向：INPATIENT(住院)、OUTPATIENT(门诊)、INSPECTION(检查室)等',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '是否启用该业务方向（1-是，0-否）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_direction` (`user_id`, `business_direction`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_business_direction` (`business_direction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户业务方向偏好表';

-- ========================================
-- 3. Cube维度表存储库
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
-- 5. 初始化数据
-- ========================================

-- 5.1 初始化一级科室（从医院部门结构导入）
INSERT INTO sys_dept (dept_code, dept_name, parent_id, dept_level, dept_type, is_mgmt_dept, status, sort_order) VALUES
-- 临床科室
('1001', '神经内科', 0, 1, 'CLINICAL', 0, '0', 10),
('1004', '烧伤整形科', 0, 1, 'CLINICAL', 0, '0', 11),
('1005', '呼吸与危重症医学科', 0, 1, 'CLINICAL', 0, '0', 12),
('1007', '心血管内科', 0, 1, 'CLINICAL', 0, '0', 13),
('1011', '康复医学科', 0, 1, 'CLINICAL', 0, '0', 14),
('1012', '风湿免疫科', 0, 1, 'CLINICAL', 0, '0', 15),
('1013', '胃肠外科', 0, 1, 'CLINICAL', 0, '0', 16),
('1014', '肝胆胰外科', 0, 1, 'CLINICAL', 0, '0', 17),
('1015', '甲乳外科', 0, 1, 'CLINICAL', 0, '0', 18),
('1016', '肛肠外科', 0, 1, 'CLINICAL', 0, '0', 19),
('1022', '脊柱健康中心', 0, 1, 'CLINICAL', 0, '0', 20),
('1024', '足踝外科手外科', 0, 1, 'CLINICAL', 0, '0', 21),
('1025', '运动医学科', 0, 1, 'CLINICAL', 0, '0', 22),
('1026', '神经外科肿瘤', 0, 1, 'CLINICAL', 0, '0', 23),
('1027', '神经外科血管', 0, 1, 'CLINICAL', 0, '0', 24),
('1029', '功能神经科', 0, 1, 'CLINICAL', 0, '0', 25),
('1031', '眼科', 0, 1, 'CLINICAL', 0, '0', 26),
('1035', '产科', 0, 1, 'CLINICAL', 0, '0', 27),
('1036', '重症医学科', 0, 1, 'CLINICAL', 0, '0', 28),
('1038', '肿瘤科', 0, 1, 'CLINICAL', 0, '0', 29),
('1041', '急诊科', 0, 1, 'CLINICAL', 0, '0', 30),
('1043', '口腔科', 0, 1, 'CLINICAL', 0, '0', 31),
('1044', '生殖医学科', 0, 1, 'CLINICAL', 0, '0', 32),
('1048', '特诊科', 0, 1, 'CLINICAL', 0, '0', 33),
('1054', '营养科', 0, 1, 'CLINICAL', 0, '0', 34),
('1055', '隔离病区', 0, 1, 'CLINICAL', 0, '0', 35),
-- 医技科室
('2002', '医学影像科', 0, 1, 'MEDICAL_TECH', 0, '0', 40),
('2012', '麻醉科', 0, 1, 'MEDICAL_TECH', 0, '0', 41),
-- 管理科室
('4008', '医务科', 0, 1, 'MGMT', 0, '0', 50),
('4009', '质控科', 0, 1, 'MGMT', 1, '0', 51),
('4010', '护理部', 0, 1, 'MGMT', 0, '0', 52),
('4011', '院感科', 0, 1, 'MGMT', 0, '0', 53),
('4012', '财务科', 0, 1, 'MGMT', 0, '0', 54),
('4019', '病案统计图书科', 0, 1, 'MGMT', 0, '0', 55);

-- 5.2 示例指标项数据
INSERT INTO t_indicator_item (item_code, item_name, item_type, data_source, query_sql, aggregate_function, aggregate_field, calculation_condition, unit, status, sort_order) VALUES
('a0050', '肺炎（住院、成人）病种例数', 'COLLECTED', 'D_MR',
'SELECT COUNT(*) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C LIKE ''J18%'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C LIKE ''J18%'') AND A14 >= 18',
'COUNT', '*', '出院日期=指定时间范围 AND (出院主要诊断 OR 出院其他诊断1) LIKE ("J13%" OR "J14%" OR "J15%" OR "J18%") AND 年龄≥18', '人', 1, 62),

('a0052', '肺炎（住院、成人）出院患者占用总床日数', 'COLLECTED', 'D_MR',
'SELECT SUM(B20) as result_value FROM D_MR WHERE B15 BETWEEN #{startDate} AND #{endDate} AND (C03C LIKE ''J13%'' OR C03C LIKE ''J14%'' OR C03C LIKE ''J15%'' OR C03C LIKE ''J18%'' OR C06x01C LIKE ''J13%'' OR C06x01C LIKE ''J14%'' OR C06x01C LIKE ''J15%'' OR C06x01C LIKE ''J18%'') AND A14 >= 18',
'SUM', 'B20', '出院日期=指定时间范围 AND (出院主要诊断 OR 出院其他诊断1) LIKE ("J13%" OR "J14%" OR "J15%" OR "J18%") AND 年龄≥18', '床日', 1, 64);

-- 5.3 示例指标数据（国考池）
INSERT INTO t_indicator (metric_code, metric_name, parent_code, indicator_level, is_leaf, metric_type, calculation_type, expression, related_items, unit, support_dept_drill, metric_pool, metric_category, status, sort_order) VALUES
('10', '重点病种质量控制指标', NULL, 1, 0, 'QUALITATIVE', 'EXPRESSION', NULL, NULL, NULL, 0, 'POOL_NATIONAL', '医疗质量', 1, 10),
('10.3', '肺炎（住院、成人）', '10', 2, 0, 'QUALITATIVE', 'EXPRESSION', NULL, NULL, NULL, 0, 'POOL_NATIONAL', '医疗质量', 1, 103),
('10.3.1', '肺炎（住院、成人）病种例数', '10.3', 3, 1, 'QUANTITATIVE', 'ITEM', 'a0050', '["a0050"]', '人', 1, 'POOL_NATIONAL', '医疗质量', 1, 1031),
('10.3.2', '肺炎（住院、成人）平均住院日', '10.3', 3, 1, 'QUANTITATIVE', 'EXPRESSION', 'a0052/a0050', '["a0050","a0052"]', '天', 1, 'POOL_NATIONAL', '医疗质量', 1, 1032),
('10.3.2.1', '肺炎（住院、成人）出院患者占用总床日数', '10.3.2', 4, 1, 'QUANTITATIVE', 'ITEM', 'a0052', '["a0052"]', '床日', 1, 'POOL_NATIONAL', '医疗质量', 1, 10321),
('10.3.2.2', '同期肺炎（住院、成人）病种例数', '10.3.2', 4, 1, 'QUANTITATIVE', 'ITEM', 'a0050', '["a0050"]', '人', 1, 'POOL_NATIONAL', '医疗质量', 1, 10322);

-- 5.4 示例指标科室关联（肺炎指标挂载到呼吸科）
INSERT INTO t_indicator_dept_scope (metric_code, root_dept_id, is_primary_owner) VALUES
('10.3.1', (SELECT dept_id FROM sys_dept WHERE dept_code='1005'), 1),
('10.3.2', (SELECT dept_id FROM sys_dept WHERE dept_code='1005'), 1),
('10.3.2.1', (SELECT dept_id FROM sys_dept WHERE dept_code='1005'), 1),
('10.3.2.2', (SELECT dept_id FROM sys_dept WHERE dept_code='1005'), 1);

-- 5.5 初始化菜单数据
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon) VALUES
-- 核心工作台
(1, '工作台', 0, 1, 'dashboard', 'Layout', 'M', '0', '0', NULL, 'dashboard'),
(2, '指标总览', 1, 1, 'index', 'dashboard/index', 'C', '0', '0', 'dashboard:view', 'peoples'),

-- 指标管理池
(3, '指标中心', 0, 2, 'indicator', 'Layout', 'M', '0', '0', NULL, 'chart'),
(4, '国考指标池', 3, 1, 'national', 'indicator/national', 'C', '0', '0', 'indicator:national:view', 'list'),
(5, '评审指标池', 3, 2, 'grade', 'indicator/grade', 'C', '0', '0', 'indicator:grade:view', 'tree'),

-- 数据治理与计算
(6, '数据中心', 0, 3, 'data', 'Layout', 'M', '0', '0', NULL, 'table'),
(7, '最小粒子库', 6, 1, 'particle', 'data/particle', 'C', '0', '0', 'data:particle:view', 'component'),
(8, '计算任务', 6, 2, 'task', 'data/task', 'C', '0', '0', 'data:task:view', 'job'),

-- 系统配置
(9, '配置管理', 0, 4, 'system', 'Layout', 'M', '0', '0', NULL, 'setting'),
(10, '科室管理', 9, 1, 'dept', 'system/dept/index', 'C', '0', '0', 'system:dept:view', 'tree-table'),
(11, '用户管理', 9, 2, 'user', 'system/user/index', 'C', '0', '0', 'system:user:view', 'user'),
(12, '角色权限', 9, 3, 'role', 'system/role/index', 'C', '0', '0', 'system:role:view', 'peoples');

-- 5.6 初始化角色数据
INSERT INTO sys_role (role_id, role_name, role_key, role_sort, data_scope, status, remark) VALUES
(1, '系统实施OPS', 'superadmin', 1, 10, '0', '系统实施/超级管理员，拥有所有权限'),
(2, '质控科长', 'quality_manager', 2, 10, '0', '质控科室负责人，全院数据视图'),
(3, '科室主任', 'dept_manager', 3, 70, '0', '临床科室负责人，本部门及下属数据权限');

-- 5.7 初始化角色菜单关联
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, menu_id FROM sys_menu; -- 超管拥有所有菜单

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
