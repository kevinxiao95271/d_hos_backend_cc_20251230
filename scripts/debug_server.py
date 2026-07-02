import sys, paramiko, pymysql, requests, json
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://81.71.44.180:8070/dgear'

# ─── 1. 分页接口完整响应 ──────────────────────────────────────────────────
r0 = requests.post(f'{ROOT}/auth/login', params={'username':'admin','password':'Admin@123'})
token = r0.json()['data']['token']
hdr = {'Authorization': f'Bearer {token}'}

print('=== /api/indicator/page (page=1,size=5) ===')
r = requests.get(f'{ROOT}/api/indicator/page', params={'page':1,'size':5}, headers=hdr)
d = r.json()['data']
print(f'  total={d.get("total")} pages={d.get("pages")} records_count={len(d.get("records",[]))}')

print('\n=== /api/indicator/page (current=1,size=5) ===')
r = requests.get(f'{ROOT}/api/indicator/page', params={'current':1,'size':5}, headers=hdr)
d = r.json()['data']
print(f'  total={d.get("total")} pages={d.get("pages")} records_count={len(d.get("records",[]))}')

print('\n=== /api/indicator-item/page ===')
r = requests.get(f'{ROOT}/api/indicator-item/page', params={'current':1,'size':5}, headers=hdr)
d = r.json()['data']
print(f'  total={d.get("total")} pages={d.get("pages")} records_count={len(d.get("records",[]))}')
print(f'  full json keys: {list(d.keys())}')

# ─── 2. 不存在资源返回 ───────────────────────────────────────────────────
print('\n=== /api/indicator/99999 ===')
r = requests.get(f'{ROOT}/api/indicator/99999', headers=hdr)
print(f'  HTTP {r.status_code}, code={r.json().get("code")}, data={r.json().get("data")}')

print('\n=== /api/indicator-item/99999 ===')
r = requests.get(f'{ROOT}/api/indicator-item/99999', headers=hdr)
print(f'  HTTP {r.status_code}, code={r.json().get("code")}, data={r.json().get("data")}')

# ─── 3. 查服务器上运行的 Java 进程端口 ──────────────────────────────────
print('\n=== 服务器 Java 进程 + 端口 ===')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', 22, 'root', 'Yiguo9527_')
_, out, _ = ssh.exec_command("ps aux | grep java | grep -v grep")
procs = out.read().decode('utf-8','replace')
print(procs)
_, out, _ = ssh.exec_command("ss -tlnp | grep java")
ports = out.read().decode('utf-8','replace')
print("监听端口:")
print(ports)

# ─── 4. 日志最近错误 ─────────────────────────────────────────────────────
print('\n=== /root/logs/log_error.log 最近20行 ===')
_, out, _ = ssh.exec_command("tail -20 /root/logs/log_error.log 2>/dev/null")
print(out.read().decode('utf-8','replace'))
ssh.close()

# ─── 5. 检查端口8070的响应特征 ──────────────────────────────────────────
print('\n=== 验证 8070 是我们的应用 ===')
r = requests.get('http://81.71.44.180:8070/dgear/v3/api-docs', timeout=3)
print(f'  /dgear/v3/api-docs → {r.status_code}, title={r.json().get("info",{}).get("title","")}')
