"""
恢复 rate_incision_infection 的科室绑定
从上次 dept-drill-down 的返回结果中可以看到有 23 个科室
但 t_indicator_dept_scope 里的数据是按 deptId 绑定的，
所以这里用 admin token 调用 replace-by-metric 接口重建
"""
import sys, json, requests, pymysql
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://81.71.44.180:8070/dgear'

# 登录
r = requests.post(f'{ROOT}/auth/login', params={'username':'admin','password':'Admin@123'})
token = r.json()['data']['token']
hdr = {'Authorization': f'Bearer {token}', 'Content-Type': 'application/json'}

# 先查当前 rate_incision_infection 的科室绑定
r2 = requests.get(f'{ROOT}/api/indicator-scope/by-metric/rate_incision_infection', headers=hdr)
existing = r2.json().get('data', [])
print(f'当前绑定数量: {len(existing)}')
if existing:
    print('已有绑定，无需恢复')
    sys.exit(0)

# 连数据库直接查所有科室 ID（t_dept 表）
conn = pymysql.connect(host='81.71.44.180', port=3306,
                       user='root', password='Yiguo9527_', db='hos_indicator',
                       charset='utf8mb4')
cur = conn.cursor()

# 查所有科室
cur.execute("SELECT dept_id, dept_name FROM t_dept WHERE status=1 ORDER BY dept_id")
depts = cur.fetchall()
print(f'共找到 {len(depts)} 个科室')
for d in depts:
    print(f'  {d[0]}: {d[1]}')

# 查 rate_surgery_complication 的绑定作参考（如果它没被删）
cur.execute("""
    SELECT dept_id FROM t_indicator_dept_scope 
    WHERE metric_code = 'rate_surgery_complication'
""")
rows = cur.fetchall()
ref_ids = [r[0] for r in rows]
print(f'\nrate_surgery_complication 绑定数: {len(ref_ids)}')

# 用所有科室 ID 恢复 rate_incision_infection 的绑定
all_dept_ids = [d[0] for d in depts]

cur.close()
conn.close()

# 调用 replace-by-metric 接口恢复
payload = {
    'metricCode': 'rate_incision_infection',
    'deptIds': all_dept_ids,
    'isPrimaryOwner': 1
}
r3 = requests.post(f'{ROOT}/api/indicator-scope/replace-by-metric',
                   headers=hdr, json=payload)
print(f'\n恢复结果: {r3.json()}')

# 验证
r4 = requests.get(f'{ROOT}/api/indicator-scope/by-metric/rate_incision_infection', headers=hdr)
print(f'恢复后绑定数量: {len(r4.json().get("data", []))}')
