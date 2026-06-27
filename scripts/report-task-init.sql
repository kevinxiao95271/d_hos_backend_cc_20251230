-- ============================================================
-- 手工填报任务子系统 · 建表脚本
-- ============================================================

-- 1. t_indicator 加 input_type 字段
ALTER TABLE t_indicator
    ADD COLUMN input_type VARCHAR(10) NOT NULL DEFAULT 'AUTO'
        COMMENT '指标类型：AUTO=自动采集计算，MANUAL=手工填报'
    AFTER metric_code;

-- 2. 填报任务专属配置表（全局，只有一行）
CREATE TABLE IF NOT EXISTS t_report_config (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    input_mode           VARCHAR(30)  NOT NULL DEFAULT 'NUM_DEN_OR_RESULT'
                         COMMENT '填报方式：RESULT_ONLY/NUM_DEN/NUM_DEN_OR_RESULT',
    version_strategy     VARCHAR(20)  NOT NULL DEFAULT 'VERSIONED'
                         COMMENT '模板版本策略：OVERWRITE/VERSIONED',
    review_mode          VARCHAR(20)  NOT NULL DEFAULT 'ADMIN_REVIEW'
                         COMMENT '审核流程：AUTO_APPROVE/ADMIN_REVIEW',
    default_deadline_days INT         NOT NULL DEFAULT 15
                         COMMENT '任务默认截止天数',
    remind_before_days   INT          NOT NULL DEFAULT 3
                         COMMENT '截止前N天自动催报',
    allow_resubmit       TINYINT(1)   NOT NULL DEFAULT 1
                         COMMENT '提交后截止前是否允许重新填报：0否/1是',
    remark               VARCHAR(500)
                         COMMENT '配置说明',
    update_by            VARCHAR(50)  COMMENT '最后修改人',
    update_time          DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报任务全局配置';

INSERT INTO t_report_config (input_mode, version_strategy, review_mode,
    default_deadline_days, remind_before_days, allow_resubmit, remark)
VALUES ('NUM_DEN_OR_RESULT', 'VERSIONED', 'ADMIN_REVIEW', 15, 3, 1, '系统默认配置');

-- 3. 填报任务主表
CREATE TABLE IF NOT EXISTS t_report_task (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    name                 VARCHAR(100) NOT NULL COMMENT '任务名称',
    time_dimension       VARCHAR(10)  NOT NULL COMMENT '时间维度：YEAR/QUARTER/MONTH',
    start_date           DATE         NOT NULL COMMENT '统计开始日期',
    end_date             DATE         NOT NULL COMMENT '统计结束日期',
    deadline             DATE         COMMENT '填报截止日期',
    status               VARCHAR(20)  NOT NULL DEFAULT 'DRAFT'
                         COMMENT '任务状态：DRAFT/PUBLISHED/CLOSED',
    input_mode           VARCHAR(30)  COMMENT '填报方式（覆盖全局配置，为空则继承）',
    review_mode          VARCHAR(20)  COMMENT '审核流程（覆盖全局配置，为空则继承）',
    template_id          BIGINT       COMMENT '来源模板ID（为空表示全新创建）',
    remark               VARCHAR(500) COMMENT '备注',
    created_by           VARCHAR(50)  COMMENT '创建人',
    create_time          DATETIME     DEFAULT CURRENT_TIMESTAMP,
    update_time          DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报任务主表';

-- 4. 填报模板表
CREATE TABLE IF NOT EXISTS t_report_template (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    name                 VARCHAR(100) NOT NULL COMMENT '模板名称',
    version              INT          NOT NULL DEFAULT 1 COMMENT '版本号',
    is_current           TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '是否为当前默认版本',
    source_task_id       BIGINT       COMMENT '来源任务ID',
    remark               VARCHAR(500),
    created_by           VARCHAR(50),
    create_time          DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报任务模板表';

-- 5. 任务-科室范围表（填报范围 + 填报状态）
CREATE TABLE IF NOT EXISTS t_report_task_scope (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    task_id              BIGINT       NOT NULL COMMENT '任务ID',
    dept_id              BIGINT       NOT NULL COMMENT '科室ID',
    dept_name            VARCHAR(100) COMMENT '科室名称',
    metric_codes         JSON         COMMENT '分配的指标编码列表',
    fill_status          VARCHAR(20)  NOT NULL DEFAULT 'PENDING'
                         COMMENT '填报状态：PENDING/FILLING/SUBMITTED/APPROVED/REJECTED',
    submit_time          DATETIME     COMMENT '提交时间',
    review_time          DATETIME     COMMENT '审核时间',
    review_by            VARCHAR(50)  COMMENT '审核人',
    review_comment       VARCHAR(500) COMMENT '打回原因',
    update_time          DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_task_dept (task_id, dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报任务科室范围与状态';

-- 6. 模板明细表
CREATE TABLE IF NOT EXISTS t_report_template_item (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    template_id          BIGINT       NOT NULL COMMENT '模板ID',
    dept_id              BIGINT       NOT NULL COMMENT '科室ID',
    dept_name            VARCHAR(100) COMMENT '科室名称',
    metric_codes         JSON         COMMENT '该科室分配的指标编码列表',
    KEY idx_template (template_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报模板明细';

-- 7. 填报数据明细表
CREATE TABLE IF NOT EXISTS t_report_data (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    task_id              BIGINT       NOT NULL COMMENT '任务ID',
    dept_id              BIGINT       NOT NULL COMMENT '科室ID',
    metric_code          VARCHAR(50)  NOT NULL COMMENT '指标编码',
    item_code            VARCHAR(50)  COMMENT '指标项编码（结果行为NULL）',
    item_name            VARCHAR(200) COMMENT '指标项名称（结果行为NULL）',
    is_result_row        TINYINT(1)   NOT NULL DEFAULT 0
                         COMMENT '是否为结果行：1=是，0=指标项行',
    input_mode           VARCHAR(30)  COMMENT '本行采用的填报方式',
    input_value          DECIMAL(20,4) COMMENT '用户填入的原始值（指标项行）',
    result_value         DECIMAL(20,4) COMMENT '最终结果值（结果行，系统算或直接填）',
    remark               VARCHAR(500) COMMENT '备注',
    save_time            DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                         COMMENT '最后保存时间',
    KEY idx_task_dept (task_id, dept_id),
    KEY idx_task_dept_metric (task_id, dept_id, metric_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报数据明细';
