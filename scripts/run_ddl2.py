import pymysql

conn = pymysql.connect(
    host='gz-cdb-bq7gk3k5.sql.tencentcdb.com',
    port=63606, user='root', password='Yiguo9527_',
    database='d_hos_claude_0251230', charset='utf8mb4',
    autocommit=True
)
cur = conn.cursor()

# 1. 检查 input_type 是否已存在
cur.execute("SHOW COLUMNS FROM t_indicator LIKE 'input_type'")
if cur.fetchone():
    print("[SKIP] input_type 已存在")
else:
    cur.execute("ALTER TABLE t_indicator ADD COLUMN input_type VARCHAR(10) NOT NULL DEFAULT 'AUTO' COMMENT '指标类型：AUTO=自动采集计算，MANUAL=手工填报' AFTER metric_code")
    print("[OK] input_type 字段已添加")

# 2. 查前3个叶子指标，标记为 MANUAL
cur.execute("SELECT metric_code, metric_name FROM t_indicator WHERE is_leaf=1 AND status=1 ORDER BY metric_code LIMIT 3")
rows = cur.fetchall()
print("\n用于测试的指标：")
manual_codes = []
for r in rows:
    print(f"  {r[0]}  {r[1].encode('utf-8').decode('utf-8', errors='replace') if r[1] else ''}")
    manual_codes.append(r[0])

if manual_codes:
    for code in manual_codes:
        cur.execute("UPDATE t_indicator SET input_type='MANUAL' WHERE metric_code=%s", (code,))
    print(f"\n[OK] 已标记为MANUAL: {manual_codes}")

# 3. 验证
cur.execute("SELECT metric_code, input_type FROM t_indicator WHERE input_type='MANUAL' LIMIT 5")
print("\nMANUAL 指标验证：")
for r in cur.fetchall():
    print(f"  {r}")

conn.close()
print("\n完成")
