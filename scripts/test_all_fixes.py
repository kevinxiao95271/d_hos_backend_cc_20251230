"""
全量回归测试：P0/P1/P2 所有修复点
"""
import sys, json, requests
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://81.71.44.180:8070/dgear'
PASS = 0; FAIL = 0

def chk(label, cond, actual=''):
    global PASS, FAIL
    if cond:
        print(f'  ✓ {label}')
        PASS += 1
    else:
        print(f'  ✗ {label}  |  实际={actual}')
        FAIL += 1

def login(u, p):
    r = requests.post(f'{ROOT}/auth/login', params={'username':u,'password':p})
    d = r.json()
    if d.get('code') == 200:
        return {'Authorization': f'Bearer {d["data"]["token"]}'}
    return None

admin = login('admin','Admin@123')
head  = login('neuro_head','Dept@123')
nurse = login('neuro_nurse','Nurse@123')

print('\n=== P2c: 分页 total 修复 ===')
r = requests.get(f'{ROOT}/api/indicator/page', params={'current':1,'size':10}, headers=admin)
d = r.json()['data']
chk('indicator/page total>0', d.get('total',0) > 0, d.get('total'))
chk('indicator/page pages>0', d.get('pages',0) > 0, d.get('pages'))
chk('indicator/page records<=size', len(d.get('records',[])) <= 10, len(d.get('records',[])))

r = requests.get(f'{ROOT}/api/indicator-item/page', params={'current':1,'size':10}, headers=admin)
d = r.json()['data']
chk('indicator-item/page total>0', d.get('total',0) > 0, d.get('total'))
chk('indicator-item/page records<=10', len(d.get('records',[])) <= 10, len(d.get('records',[])))

print('\n=== P2b: 不存在资源返回 404 ===')
r = requests.get(f'{ROOT}/api/indicator/99999', headers=admin)
chk('GET /api/indicator/99999 code=404', r.json().get('code') == 404, r.json().get('code'))

r = requests.get(f'{ROOT}/api/indicator-item/99999', headers=admin)
chk('GET /api/indicator-item/99999 code=404', r.json().get('code') == 404, r.json().get('code'))

print('\n=== P2a: 入参校验 → 缺必填参数返回 400 ===')
# 缺 startDate/endDate（required=true 参数）
r = requests.post(f'{ROOT}/api/indicator-item/a0050/execute', headers=admin)
chk('execute 缺 startDate → 400', r.json().get('code') == 400, r.json().get('code'))

# 日期格式错误
r = requests.post(f'{ROOT}/api/indicator-result/calculate', headers=admin,
                  params={'metricCode':'rate_incision_infection','timeDimension':'YEAR',
                          'startDate':'invalid-date','endDate':'2020-12-31'})
chk('calculate 日期格式错 → 400', r.json().get('code') == 400, r.json().get('code'))

# 父节点 GRP_SURGERY → 400
r = requests.post(f'{ROOT}/api/indicator-result/calculate', headers=admin,
                  params={'metricCode':'GRP_SURGERY','timeDimension':'YEAR',
                          'startDate':'2020-01-01','endDate':'2020-12-31'})
chk('calculate 父节点 GRP_SURGERY → 400', r.json().get('code') == 400, r.json().get('code'))

print('\n=== P0: 计算接口正常工作（叶子节点） ===')
r = requests.post(f'{ROOT}/api/indicator-result/calculate', headers=admin,
                  params={'metricCode':'rate_incision_infection','timeDimension':'YEAR',
                          'startDate':'2020-01-01','endDate':'2020-12-31'})
chk('calculate rate_incision_infection → 200', r.json().get('code') == 200, r.json().get('code'))

r = requests.post(f'{ROOT}/api/indicator-result/calculate', headers=admin,
                  params={'metricCode':'rate_surgery_complication','timeDimension':'YEAR',
                          'startDate':'2020-01-01','endDate':'2020-12-31'})
chk('calculate rate_surgery_complication → 200', r.json().get('code') == 200, r.json().get('code'))

r = requests.post(f'{ROOT}/api/indicator-item/a0050/execute', headers=admin,
                  params={'startDate':'2020-01-01','endDate':'2020-12-31'})
chk('execute a0050 → 200', r.json().get('code') == 200, r.json().get('code'))

r = requests.post(f'{ROOT}/api/indicator-result/dept-drill-down', headers=admin,
                  params={'metricCode':'rate_incision_infection','timeDimension':'YEAR',
                          'startDate':'2020-01-01','endDate':'2020-12-31'})
chk('dept-drill-down → 200', r.json().get('code') == 200, r.json().get('code'))

print('\n=== P1a: 低权限不能访问 /system/users ===')
r = requests.get(f'{ROOT}/system/users', headers=head)
chk('neuro_head GET /system/users → 403', r.json().get('code') == 403, r.json().get('code'))

r = requests.get(f'{ROOT}/system/users', headers=nurse)
chk('neuro_nurse GET /system/users → 403', r.json().get('code') == 403, r.json().get('code'))

# 超管可以访问
r = requests.get(f'{ROOT}/system/users', headers=admin)
chk('admin GET /system/users → 200', r.json().get('code') == 200, r.json().get('code'))

print('\n=== P1b: 低权限不能删除 indicator-scope ===')
r = requests.delete(f'{ROOT}/api/indicator-scope/by-metric/rate_incision_infection', headers=head)
chk('neuro_head DELETE scope → 403', r.json().get('code') == 403, r.json().get('code'))

r = requests.delete(f'{ROOT}/api/indicator-scope/by-metric/rate_incision_infection', headers=nurse)
chk('neuro_nurse DELETE scope → 403', r.json().get('code') == 403, r.json().get('code'))

# 验证数据未被删除（scope 绑定仍存在）
r = requests.get(f'{ROOT}/api/indicator-scope/by-metric/rate_incision_infection', headers=admin)
cnt = len(r.json().get('data', []))
chk('rate_incision_infection scope 绑定已恢复 (>0条)', cnt > 0, cnt)

print(f'\n=== 汇总: 通过={PASS}  失败={FAIL} ===')
