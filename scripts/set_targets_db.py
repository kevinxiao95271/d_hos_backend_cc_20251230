import sys
import pymysql
sys.stdout.reconfigure(encoding='utf-8')

conn = pymysql.connect(
    host='gz-cdb-bq7gk3k5.sql.tencentcdb.com', port=63606,
    user='root', password='Yiguo9527_', database='d_hos_claude_0251230',
    charset='utf8mb4', connect_timeout=15
)
cur = conn.cursor()

EXPLICIT = {
    'rate_incision_infection':   (0.001,  'DECREASE'),
    'rate_surgery_complication': (0.005,  'DECREASE'),
    'avg_cost_pneumonia_adult':  (5000,   'DECREASE'),
}

cur.execute("""
    SELECT i.metric_code, i.metric_name, r.result_value
    FROM t_indicator i
    LEFT JOIN t_indicator_result r
      ON r.metric_code = i.metric_code
     AND r.time_dimension='YEAR' AND r.time_value='2020'
     AND r.calculation_status='SUCCESS'
    WHERE i.is_leaf=1 AND i.status=1
""")
rows = cur.fetchall()

def guess(name, rv):
    if rv is None:
        return None, 'MONITOR'
    if any(k in (name or '') for k in ['感染','并发症','死亡','费用','成本']):
        return round(float(rv)*0.8, 4), 'DECREASE'
    if any(k in (name or '') for k in ['满意','覆盖','完成','治愈']):
        return round(float(rv)*1.1, 4), 'INCREASE'
    return float(rv), 'MONITOR'

n = 0
for code, name, rv in rows:
    if code in EXPLICIT:
        tv, md = EXPLICIT[code]
    else:
        tv, md = guess(name, rv)
        if tv is None:
            continue
    cur.execute("UPDATE t_indicator SET target_value=%s, monitor_direction=%s WHERE metric_code=%s", (tv, md, code))
    n += 1

conn.commit()
print(f'已更新 {n} 个指标')
for c in EXPLICIT:
    cur.execute("SELECT metric_code,target_value,monitor_direction FROM t_indicator WHERE metric_code=%s", (c,))
    print(' ', cur.fetchone())
cur.close(); conn.close()
