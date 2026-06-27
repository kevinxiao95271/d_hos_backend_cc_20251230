"""
在远端数据库执行建表 DDL，并初始化测试数据
"""
import pymysql, sys

conn = pymysql.connect(
    host='gz-cdb-bq7gk3k5.sql.tencentcdb.com',
    port=63606, user='root', password='Yiguo9527_',
    database='d_hos_claude_0251230', charset='utf8mb4',
    autocommit=True
)
cur = conn.cursor()

ddl_statements = [
# --- t_indicator 加 input_type 字段 ---
"""
ALTER TABLE t_indicator
    ADD COLUMN IF NOT EXISTS input_type VARCHAR(10) NOT NULL DEFAULT 'AUTO'
    COMMENT '指标类型：AUTO=自动采集计算，MANUAL=手工填报'
    AFTER metric_code
""",

# --- t_report_config ---
"""
CREATE TABLE IF NOT EXISTS t_report_config (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    input_mode           VARCHAR(30)  NOT NULL DEFAULT 'NUM_DEN_OR_RESULT'
                         COMMENT '填报方式：RESULT_ONLY/NUM_DEN/NUM_DEN_OR_RESULT',
    version_strategy     VARCHAR(20)  NOT NULL DEFAULT 'VERSIONED',
    review_mode          VARCHAR(20)  NOT NULL DEFAULT 'ADMIN_REVIEW',
    default_deadline_days INT         NOT NULL DEFAULT 15,
    remind_before_days   INT          NOT NULL DEFAULT 3,
    allow_resubmit       TINYINT(1)   NOT NULL DEFAULT 1,
    remark               VARCHAR(500),
    update_by            VARCHAR(50),
    update_time          DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报任务全局配置'
""",

# --- 初始化一行全局配置 ---
"""
INSERT IGNORE INTO t_report_config (id, input_mode, version_strategy, review_mode,
    default_deadline_days, remind_before_days, allow_resubmit, remark)
VALUES (1, 'NUM_DEN_OR_RESULT', 'VERSIONED', 'ADMIN_REVIEW', 15, 3, 1, '系统默认配置')
""",

# --- t_report_task ---
"""
CREATE TABLE IF NOT EXISTS t_report_task (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    name                 VARCHAR(100) NOT NULL,
    time_dimension       VARCHAR(10)  NOT NULL,
    start_date           DATE         NOT NULL,
    end_date             DATE         NOT NULL,
    deadline             DATE,
    status               VARCHAR(20)  NOT NULL DEFAULT 'DRAFT',
    input_mode           VARCHAR(30),
    review_mode          VARCHAR(20),
    template_id          BIGINT,
    remark               VARCHAR(500),
    created_by           VARCHAR(50),
    create_time          DATETIME     DEFAULT CURRENT_TIMESTAMP,
    update_time          DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报任务主表'
""",

# --- t_report_template ---
"""
CREATE TABLE IF NOT EXISTS t_report_template (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    name                 VARCHAR(100) NOT NULL,
    version              INT          NOT NULL DEFAULT 1,
    is_current           TINYINT(1)   NOT NULL DEFAULT 1,
    source_task_id       BIGINT,
    remark               VARCHAR(500),
    created_by           VARCHAR(50),
    create_time          DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报任务模板表'
""",

# --- t_report_template_item ---
"""
CREATE TABLE IF NOT EXISTS t_report_template_item (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    template_id          BIGINT       NOT NULL,
    dept_id              BIGINT       NOT NULL,
    dept_name            VARCHAR(100),
    metric_codes         JSON,
    KEY idx_template (template_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报模板明细'
""",

# --- t_report_task_scope ---
"""
CREATE TABLE IF NOT EXISTS t_report_task_scope (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    task_id              BIGINT       NOT NULL,
    dept_id              BIGINT       NOT NULL,
    dept_name            VARCHAR(100),
    metric_codes         JSON,
    fill_status          VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
    submit_time          DATETIME,
    review_time          DATETIME,
    review_by            VARCHAR(50),
    review_comment       VARCHAR(500),
    update_time          DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_task_dept (task_id, dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报任务科室范围与状态'
""",

# --- t_report_data ---
"""
CREATE TABLE IF NOT EXISTS t_report_data (
    id                   BIGINT       AUTO_INCREMENT PRIMARY KEY,
    task_id              BIGINT       NOT NULL,
    dept_id              BIGINT       NOT NULL,
    metric_code          VARCHAR(50)  NOT NULL,
    item_code            VARCHAR(50),
    item_name            VARCHAR(200),
    is_result_row        TINYINT(1)   NOT NULL DEFAULT 0,
    input_mode           VARCHAR(30),
    input_value          DECIMAL(20,4),
    result_value         DECIMAL(20,4),
    remark               VARCHAR(500),
    save_time            DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_task_dept (task_id, dept_id),
    KEY idx_task_dept_metric (task_id, dept_id, metric_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='填报数据明细'
""",
]

for i, stmt in enumerate(ddl_statements):
    stmt = stmt.strip()
    if not stmt:
        continue
    try:
        cur.execute(stmt)
        print(f"[OK] Statement {i+1}")
    except pymysql.err.OperationalError as e:
        if "Duplicate column" in str(e) or "already exists" in str(e):
            print(f"[SKIP] Statement {i+1}: already exists")
        else:
            print(f"[ERROR] Statement {i+1}: {e}")
    except Exception as e:
        print(f"[ERROR] Statement {i+1}: {e}")

# 查几个 MANUAL 指标（标记几条用于测试）
cur.execute("SELECT metric_code, metric_name FROM t_indicator WHERE is_leaf=1 AND status=1 LIMIT 5")
rows = cur.fetchall()
print("\n可用的叶子指标（用于测试）:")
for r in rows:
    print(f"  {r[0]}  {r[1]}")

# 把前3个标记为 MANUAL
if rows:
    codes = [r[0] for r in rows[:3]]
    fmt = ','.join(['%s']*len(codes))
    cur.execute(f"UPDATE t_indicator SET input_type='MANUAL' WHERE metric_code IN ({fmt})", codes)
    print(f"\n已将以下指标标记为 MANUAL: {codes}")

conn.close()
print("\nDDL 执行完毕")
