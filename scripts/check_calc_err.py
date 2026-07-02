"""
检查计算类接口的实际报错，并查询数据库验证数据状态
"""
import sys, json, requests, paramiko
sys.stdout.reconfigure(encoding='utf-8')

HOST = '81.71.44.180'
PORT = 22
USER = 'root'
PASS = 'Yiguo9527_'

ROOT = f'http://{HOST}:8070/dgear'

# ─── 登录 ──────────────────────────────────────────────────────────────────
r = requests.post(f'{ROOT}/auth/login', params={'username':'admin','password':'Admin@123'})
token = r.json()['data']['token']
hdr = {'Authorization': f'Bearer {token}'}

# ─── 1. indicator-item execute (a0106) ────────────────────────────────────
print('=== POST /api/indicator-item/a0106/execute ===')
r = requests.post(f'{ROOT}/api/indicator-item/a0106/execute',
                  params={'startDate':'2020-01-01','endDate':'2020-12-31'},
                  headers=hdr, json={})
print(json.dumps(r.json(), ensure_ascii=False, indent=2))

# ─── 2. indicator-result calculate (GRP_SURGERY) ──────────────────────────
print('\n=== POST /api/indicator-result/calculate (GRP_SURGERY) ===')
r = requests.post(f'{ROOT}/api/indicator-result/calculate',
                  params={'metricCode':'GRP_SURGERY','timeDimension':'YEAR',
                          'startDate':'2020-01-01','endDate':'2020-12-31'},
                  headers=hdr)
print(json.dumps(r.json(), ensure_ascii=False, indent=2))

# ─── 3. dept-drill-down (GRP_SURGERY) ──────────────────────────────────────
print('\n=== POST /api/indicator-result/dept-drill-down (GRP_SURGERY) ===')
r = requests.post(f'{ROOT}/api/indicator-result/dept-drill-down',
                  params={'metricCode':'GRP_SURGERY','timeDimension':'YEAR',
                          'startDate':'2020-01-01','endDate':'2020-12-31'},
                  headers=hdr)
print(json.dumps(r.json(), ensure_ascii=False, indent=2))

# ─── 4. 查服务器日志（最后 80 行含 ERROR/WARN 的行）─────────────────────────
print('\n=== 服务器错误日志 (最近 ERROR) ===')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(HOST, PORT, USER, PASS)
_, out, _ = ssh.exec_command(
    "journalctl -u indicator 2>/dev/null | tail -200 | grep -i 'error\\|exception' | tail -30 "
    "|| find /root /home -name '*.log' 2>/dev/null | head -3 | xargs grep -i 'error\\|exception' 2>/dev/null | tail -30"
)
print(out.read().decode('utf-8', errors='replace'))

# ─── 5. 查 GRP_SURGERY 在数据库的状态 ────────────────────────────────────
print('\n=== 数据库: t_indicator WHERE metric_code=GRP_SURGERY ===')
_, out, _ = ssh.exec_command(
    "mysql -u root -pYiguo9527_ d_hos_claude_0251230 -e "
    "\"SELECT metric_code,metric_name,is_leaf,status,calculation_type,related_items,expression "
    "FROM t_indicator WHERE metric_code='GRP_SURGERY'\\G\" 2>/dev/null"
)
print(out.read().decode('utf-8', errors='replace'))

print('\n=== 数据库: t_indicator_item WHERE item_code=a0106 ===')
_, out, _ = ssh.exec_command(
    "mysql -u root -pYiguo9527_ d_hos_claude_0251230 -e "
    "\"SELECT item_code,item_name,item_type,query_sql,status FROM t_indicator_item WHERE item_code='a0106'\\G\" 2>/dev/null"
)
print(out.read().decode('utf-8', errors='replace'))
ssh.close()
