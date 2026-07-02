"""
P0 诊断：抓真实 500 错误 + 查服务器日志
"""
import sys, json, requests, paramiko, time
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://81.71.44.180:8070/dgear'

# 登录
r = requests.post(f'{ROOT}/auth/login', params={'username':'admin','password':'Admin@123'})
token = r.json()['data']['token']
hdr = {'Authorization': f'Bearer {token}', 'Content-Type': 'application/json'}

def post(url, params=None, body=None):
    r = requests.post(ROOT + url, params=params, headers=hdr, json=body)
    print(f'\nPOST {url}')
    print(f'params: {params}')
    print(f'status={r.status_code}, body={json.dumps(r.json(), ensure_ascii=False)}')
    return r.json()

def get(url, params=None):
    r = requests.get(ROOT + url, params=params, headers=hdr)
    print(f'\nGET {url}')
    print(f'params: {params}')
    print(f'status={r.status_code}, body={json.dumps(r.json(), ensure_ascii=False)[:300]}')
    return r.json()

print('=== P0: 计算接口 ===')
# 1. indicator-item execute
post('/api/indicator-item/a0050/execute', params={'startDate':'2020-01-01','endDate':'2020-12-31'})
post('/api/indicator-item/a0027/execute', params={'startDate':'2020-01-01','endDate':'2020-12-31'})

# 2. calculate - 用真实叶子节点
post('/api/indicator-result/calculate',
     params={'metricCode':'rate_incision_infection','timeDimension':'YEAR',
             'startDate':'2020-01-01','endDate':'2020-12-31'})

post('/api/indicator-result/calculate',
     params={'metricCode':'rate_surgery_complication','timeDimension':'YEAR',
             'startDate':'2020-01-01','endDate':'2020-12-31'})

# 3. dept-drill-down
post('/api/indicator-result/dept-drill-down',
     params={'metricCode':'rate_incision_infection','timeDimension':'YEAR',
             'startDate':'2020-01-01','endDate':'2020-12-31'})

print('\n=== 分页接口 total 问题 ===')
get('/api/indicator-item/page', params={'current':1,'size':5})
get('/api/indicator/page', params={'page':1,'size':5})

print('\n=== P1: 权限测试 ===')
r2 = requests.post(f'{ROOT}/auth/login', params={'username':'neuro_head','password':'Dept@123'})
if r2.json().get('code') == 200:
    tok2 = r2.json()['data']['token']
    hdr2 = {'Authorization': f'Bearer {tok2}'}
    r3 = requests.get(f'{ROOT}/system/users', headers=hdr2)
    print(f'neuro_head GET /system/users → {r3.status_code} code={r3.json().get("code")}')
else:
    print('neuro_head 登录失败:', r2.json())

print('\n=== 抓服务器日志最近ERROR ===')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('81.71.44.180', 22, 'root', 'Yiguo9527_')
_, out, _ = ssh.exec_command(
    "find /root /home -name '*.log' -newer /tmp 2>/dev/null | head -5; "
    "ps aux | grep java | grep -v grep | awk '{print $NF}'"
)
print(out.read().decode('utf-8','replace'))
# 尝试找 jar 运行目录和日志
_, out2, _ = ssh.exec_command(
    "ls /root/*.log /root/logs/*.log /opt/*.log 2>/dev/null | head -10"
)
print(out2.read().decode('utf-8','replace'))
_, out3, _ = ssh.exec_command(
    "ls /proc/$(ps aux|grep java|grep -v grep|awk '{print $2}'|head -1)/fd 2>/dev/null | head -20"
)
print(out3.read().decode('utf-8','replace'))
ssh.close()
