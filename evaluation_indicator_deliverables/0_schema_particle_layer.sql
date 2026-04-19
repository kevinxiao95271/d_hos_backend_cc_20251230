-- ========================================
-- 评审指标系统 - 最小粒子层中间表设计
-- 新增文件（补充到现有 schema.sql）
-- ========================================

-- ========================================
-- 1. 最小粒子中间表 (统一单表方案)
-- ========================================

DROP TABLE IF EXISTS `t_mid_detail`;
CREATE TABLE `t_mid_detail` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `batch_id` VARCHAR(50) NOT NULL COMMENT '批次ID（UUID或时间戳）',

    -- 粒子分类（关键：用于区分不同数据粒度）
    `particle_type` VARCHAR(50) NOT NULL COMMENT '粒子类型：CASE_SETTLEMENT(病例)、CASE_DIAG(诊断)、CASE_OP(手术)、CASE_VTE、CASE_INFECT等',
    `business_domain` VARCHAR(50) COMMENT '业务域：INPATIENT(住院)、ER(急诊)、ICU、OPERATION、VTE、INFECT',
    `source_view` VARCHAR(100) COMMENT '来源接口视图名称',

    -- 实体标识（确保可以追溯到原始记录）
    `patient_id` VARCHAR(50) NOT NULL COMMENT '患者ID',
    `visit_id` VARCHAR(50) NOT NULL COMMENT '就诊ID/住院号',
    `case_id` VARCHAR(50) COMMENT '出院病例唯一标识（patient_id#visit_id）',
    `record_id` VARCHAR(50) COMMENT '粒子特定记录ID（如诊断序号、手术序号）',

    -- 时间维度（用于聚合和时间分析）
    `stat_date` DATE NOT NULL COMMENT '统计日期（如出院日期、评估日期、事件日期）',
    `stat_month` VARCHAR(7) NOT NULL COMMENT '统计月份（YYYY-MM格式）',
    `stat_quarter` VARCHAR(10) COMMENT '统计季度（YYYY-Q1格式）',
    `stat_year` INT COMMENT '统计年份',

    -- 科室维度（支持科室下钻）
    `discharge_dept_code` VARCHAR(50) COMMENT '出院科室编码',
    `discharge_dept_name` VARCHAR(100) COMMENT '出院科室名称',
    `discharge_hospital_code` VARCHAR(50) COMMENT '出院医疗机构代码',

    -- 编码字段（用于过滤和分类）
    `diag_code` VARCHAR(50) COMMENT '诊断编码（CASE_DIAG粒子）',
    `diag_name` VARCHAR(200) COMMENT '诊断名称',
    `diag_type` TINYINT COMMENT '诊断类型：1-主诊断、2-其他诊断',
    `operation_code` VARCHAR(50) COMMENT '手术编码（CASE_OP粒子）',
    `operation_name` VARCHAR(200) COMMENT '手术名称',
    `operation_sequence` INT COMMENT '手术序号',

    -- 关键衍生指标字段（提高聚合性能）
    `los_days` INT COMMENT '住院日数',
    `admission_date` DATE COMMENT '入院日期',
    `discharge_date` DATE COMMENT '出院日期',
    `total_cost` DECIMAL(15,2) COMMENT '总费用（元）',
    `death_flag` TINYINT COMMENT '死亡标志：1-死亡，0-存活',
    `transfer_flag` TINYINT COMMENT '转院标志：1-转出，0-未转',
    `icu_day` INT COMMENT 'ICU占用床日数',
    `ventilator_day` INT COMMENT '呼吸机使用天数',

    -- 灵活存储字段
    `num_value` DECIMAL(15,4) COMMENT '数值型值（用于VTE评分等）',
    `str_value` VARCHAR(500) COMMENT '字符串值',
    `flag_value` TINYINT COMMENT '标志值（0/1）',
    `ext_json` JSON COMMENT '扩展字段（JSON格式存储额外属性）',

    -- 数据质量和追踪
    `data_quality_flag` TINYINT DEFAULT 1 COMMENT '数据质量标记：1-正常，0-异常',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_particle_unique` (`batch_id`, `particle_type`, `patient_id`, `visit_id`, `record_id`),
    KEY `idx_batch_id` (`batch_id`),
    KEY `idx_particle_type` (`particle_type`),
    KEY `idx_stat_date` (`stat_date`),
    KEY `idx_stat_month` (`stat_month`),
    KEY `idx_stat_quarter` (`stat_quarter`),
    KEY `idx_dept` (`discharge_dept_code`),
    KEY `idx_diag_code` (`diag_code`),
    KEY `idx_op_code` (`operation_code`),
    KEY `idx_patient_visit` (`patient_id`, `visit_id`),
    KEY `idx_business_domain` (`business_domain`),
    KEY `idx_source_view` (`source_view`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评审指标最小粒子中间表（统一单表存储）';

-- ========================================
-- 2. 粒子规则表（定义如何从源视图抽取粒子）
-- ========================================

DROP TABLE IF EXISTS `t_particle_rule`;
CREATE TABLE `t_particle_rule` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `particle_code` VARCHAR(50) NOT NULL COMMENT '粒子编码',
    `particle_name` VARCHAR(200) NOT NULL COMMENT '粒子名称',
    `particle_type` VARCHAR(50) NOT NULL COMMENT '粒子类型分类',

    `business_object` VARCHAR(100) COMMENT '业务对象（如 INPATIENT_VISIT、DIAGNOSIS、OPERATION）',
    `granularity` VARCHAR(100) COMMENT '粒度描述（如 一行一出院、一行一诊断）',
    `primary_key` VARCHAR(200) COMMENT '唯一键定义（JSON格式）',

    `source_view` VARCHAR(100) COMMENT '来源接口视图',
    `source_table` VARCHAR(100) COMMENT '实际来源表',
    `time_field` VARCHAR(100) COMMENT '时间字段',
    `core_fields` TEXT COMMENT '核心字段列表（JSON格式）',

    `load_sql_template` TEXT COMMENT 'SQL装载模板',
    `supports_metrics` TEXT COMMENT '支持的指标编码列表（JSON格式）',

    `status` TINYINT DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
    `remarks` VARCHAR(500) COMMENT '备注',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_particle_code` (`particle_code`),
    KEY `idx_particle_type` (`particle_type`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='粒子规则表（定义粒子的装载规则）';

-- ========================================
-- 3. 聚合规则表（定义如何从粒子层聚合到指标项）
-- ========================================

DROP TABLE IF EXISTS `t_agg_rule`;
CREATE TABLE `t_agg_rule` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `agg_code` VARCHAR(50) NOT NULL COMMENT '聚合规则编码',
    `agg_name` VARCHAR(200) COMMENT '聚合规则名称',

    -- 粒子配置
    `particle_types` VARCHAR(500) COMMENT '支持的粒子类型（JSON数组）',
    `filter_condition` VARCHAR(1000) COMMENT '过滤条件SQL片段（如 diag_code LIKE "J%"）',

    -- 分组维度
    `group_by_fields` VARCHAR(500) COMMENT '分组字段（JSON数组，如 ["discharge_dept_code","stat_month"]）',

    -- 聚合函数配置
    `agg_func` VARCHAR(50) COMMENT '聚合函数：COUNT、SUM、AVG、DISTINCT_COUNT、MAX、MIN、RATIO',
    `agg_field` VARCHAR(100) COMMENT '聚合字段（如 id、los_days、total_cost）',
    `distinct_key` VARCHAR(500) COMMENT '去重字段（DISTINCT_COUNT时使用，JSON数组）',

    -- 时间维度
    `time_dimension` VARCHAR(20) COMMENT '时间粒度：DAY、MONTH、QUARTER、YEAR',

    -- 结果映射
    `result_field` VARCHAR(100) COMMENT '结果存储字段',
    `result_unit` VARCHAR(50) COMMENT '结果单位',

    `status` TINYINT DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_agg_code` (`agg_code`),
    KEY `idx_particle_types` (`particle_types`(100)),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='聚合规则表（定义从粒子到指标项的聚合逻辑）';

-- ========================================
-- 4. 指标项与粒子映射表（关键：元数据驱动）
-- ========================================

DROP TABLE IF EXISTS `t_item_particle_mapping`;
CREATE TABLE `t_item_particle_mapping` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `item_code` VARCHAR(50) NOT NULL COMMENT '指标项编码（如 a0050）',
    `item_name` VARCHAR(200) COMMENT '指标项名称',

    -- 粒子配置
    `particle_code` VARCHAR(50) COMMENT '粒子编码',
    `particle_type` VARCHAR(50) COMMENT '粒子类型（CASE_SETTLEMENT、CASE_DIAG等）',
    `particle_filter` VARCHAR(500) COMMENT '粒子过滤规则（如 diag_code IN (...)）',

    -- 聚合配置
    `agg_code` VARCHAR(50) COMMENT '关联的聚合规则编码',
    `agg_func` VARCHAR(50) COMMENT '聚合函数类型',
    `agg_field` VARCHAR(100) COMMENT '聚合字段',
    `distinct_key` VARCHAR(500) COMMENT '去重键（DISTINCT_COUNT用）',

    -- 时间和维度配置
    `time_field` VARCHAR(100) COMMENT '时间字段名（如 stat_date）',
    `time_dimension` VARCHAR(20) COMMENT '统计粒度（DAY、MONTH、QUARTER、YEAR）',
    `group_by_fields` VARCHAR(500) COMMENT '分组维度（JSON数组）',

    -- 结果配置
    `result_field` VARCHAR(100) COMMENT '结果字段名',
    `result_unit` VARCHAR(50) COMMENT '单位（人、人次、天、元等）',

    -- 业务配置
    `supports_drill_down` TINYINT DEFAULT 1 COMMENT '是否支持科室下钻',
    `supports_time_compare` TINYINT DEFAULT 1 COMMENT '是否支持时间对比',

    -- 文档和风险
    `mapping_notes` TEXT COMMENT '映射说明',
    `risk_notes` TEXT COMMENT '风险提示',
    `data_source_refs` VARCHAR(500) COMMENT '数据源引用',

    `status` TINYINT DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_item_code` (`item_code`),
    KEY `idx_particle_type` (`particle_type`),
    KEY `idx_agg_code` (`agg_code`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标项与粒子映射表（元数据驱动聚合SQL生成）';

-- ========================================
-- 5. 粒子装载任务表（追踪装载进度）
-- ========================================

DROP TABLE IF EXISTS `t_particle_load_task`;
CREATE TABLE `t_particle_load_task` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `batch_id` VARCHAR(50) NOT NULL COMMENT '批次ID',
    `particle_type` VARCHAR(50) NOT NULL COMMENT '粒子类型',

    `source_view` VARCHAR(100) COMMENT '来源视图',
    `start_date` DATE COMMENT '数据起始日期',
    `end_date` DATE COMMENT '数据截止日期',

    `task_status` VARCHAR(20) COMMENT '任务状态：PENDING/RUNNING/SUCCESS/FAILED',
    `affected_rows` BIGINT COMMENT '影响行数',
    `error_message` TEXT COMMENT '错误信息',

    `exec_sql` TEXT COMMENT '实际执行的SQL语句（用于调试）',
    `exec_time_ms` INT COMMENT '执行耗时（毫秒）',

    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    PRIMARY KEY (`id`),
    KEY `idx_batch_id` (`batch_id`),
    KEY `idx_particle_type` (`particle_type`),
    KEY `idx_task_status` (`task_status`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='粒子装载任务执行日志';

-- ========================================
-- 6. 指标项聚合任务表（追踪聚合进度）
-- ========================================

DROP TABLE IF EXISTS `t_item_agg_task`;
CREATE TABLE `t_item_agg_task` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `batch_id` VARCHAR(50) NOT NULL COMMENT '批次ID',
    `item_code` VARCHAR(50) NOT NULL COMMENT '指标项编码',
    `agg_code` VARCHAR(50) COMMENT '聚合规则编码',

    `time_dimension` VARCHAR(20) COMMENT '统计维度',
    `time_value` VARCHAR(20) COMMENT '时间值',

    `task_status` VARCHAR(20) COMMENT '任务状态',
    `result_rows` INT COMMENT '结果行数',
    `error_message` TEXT COMMENT '错误信息',

    `exec_time_ms` INT COMMENT '执行耗时',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    PRIMARY KEY (`id`),
    KEY `idx_batch_id` (`batch_id`),
    KEY `idx_item_code` (`item_code`),
    KEY `idx_task_status` (`task_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='指标项聚合任务执行日志';

-- ========================================
-- 7. 初始化粒子规则表（示例数据）
-- ========================================

INSERT INTO `t_particle_rule` (
    `particle_code`, `particle_name`, `particle_type`,
    `business_object`, `granularity`, `primary_key`,
    `source_view`, `time_field`, `core_fields`
) VALUES
('CASE_SETTLEMENT', '病例事实', 'CASE_SETTLEMENT',
    'INPATIENT_VISIT', '一行一出院', 'patient_id,visit_id',
    'I_MR_HOME_PAGE', 'discharge_date',
    '["patient_id","visit_id","admission_date","discharge_date","los_days","total_cost","death_flag"]'),

('CASE_DIAG', '诊断编码', 'CASE_DIAG',
    'DIAGNOSIS', '一行一诊断', 'patient_id,visit_id,diag_code,diag_type',
    'I_MR_DIAGNOSIS', 'discharge_date',
    '["patient_id","visit_id","diag_code","diag_name","diag_type","discharge_date","discharge_dept"]'),

('CASE_OP', '手术事件', 'CASE_OP',
    'OPERATION', '一行一手术', 'patient_id,visit_id,operation_sequence',
    'I_MR_OPERATION', 'discharge_date',
    '["patient_id","visit_id","operation_code","operation_name","operation_sequence","operation_date"]')
ON DUPLICATE KEY UPDATE
    `particle_name` = VALUES(`particle_name`),
    `update_time` = NOW();

-- ========================================
-- 8. 说明
-- ========================================
-- 本脚本定义了评审指标系统的最小粒子层和聚合层
-- 实现了从源接口视图 → 最小粒子 → 聚合 → 指标的完整链路
--
-- 核心表：
--  1. t_mid_detail: 统一的粒子中间表（单表方案）
--  2. t_particle_rule: 粒子定义和装载规则
--  3. t_agg_rule: 聚合规则定义
--  4. t_item_particle_mapping: 指标项到粒子的映射（元数据驱动）
--  5. t_particle_load_task: 装载任务追踪
--  6. t_item_agg_task: 聚合任务追踪
--
-- 设计优势：
--  - 支持后期按业务需求拆分粒子表
--  - 元数据驱动的聚合，易于维护和扩展
--  - 清晰的数据血缘和质量追踪
