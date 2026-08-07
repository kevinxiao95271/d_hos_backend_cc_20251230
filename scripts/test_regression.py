"""
回归测试脚本 - 验证本次修复的全部问题点
"""
import sys, json, requests, time
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://81.71.44.180:8070/dgear'
BASE = ROOT + '/api'

OK, FAIL = 0, 0
results = []

def check(label, cond, detail=''):
    global OK, FAIL
    if cond:
        OK += 1
        results.append(f'  ✓  {label}')
    else:
        FAIL += 1
        results.append(f'  ✗  {label}  ({detail})')

# ─── 登录 ───────────────────────────────────────────────────────────────────
print('\n[1] 登录')
r = requests.post(f'{ROOT}/auth/login', params={'username':'admin','password':'Admin@123'})
data = r.json()
check('admin 登录 200', data.get('code') == 200, str(data.get('code')))
token = data.get('data', {}).get('token', '')
check('拿到 token', bool(token))

# 错误密码应返回 401
r2 = requests.post(f'{ROOT}/auth/login', params={'username':'admin','password':'wrong'})
d2 = r2.json()
check('错误密码返回 401 (非500)', d2.get('code') == 30401, str(d2.get('code')))

hdr = {'Authorization': f'Bearer {token}'}

# ─── Swagger ────────────────────────────────────────────────────────────────
print('\n[2] Swagger')
r = requests.get(f'{ROOT}/v3/api-docs')
check('GET /v3/api-docs 可访问', r.status_code == 200, str(r.status_code))
check('/v3/api-docs 返回 JSON', 'paths' in r.json(), str(r.text[:80]))

# ─── A类: auth 接口 ──────────────────────────────────────────────────────────
print('\n[3] Auth 接口')
r = requests.get(f'{ROOT}/auth/userInfo', headers=hdr)
d = r.json()
check('GET /auth/userInfo 200', d.get('code') == 200, str(d.get('code')))
check('userInfo 含 username', 'username' in (d.get('data') or {}))

r = requests.get(f'{ROOT}/auth/menus', headers=hdr, params={'roleId': 1})
d = r.json()
check('GET /auth/menus 返回 Result 格式', isinstance(d, dict) and 'code' in d, str(type(d)))

# GET /auth/login 应返回 405
r = requests.get(f'{ROOT}/auth/login')
d = r.json()
check('GET /auth/login 返回 405 (非500)', d.get('code') == 30405, str(d.get('code')))

# ─── A类: system 别名 ────────────────────────────────────────────────────────
print('\n[4] System 别名路径')
for path, label in [
    ('/system/users',  'GET /system/users'),
    ('/system/depts',  'GET /system/depts'),
    ('/system/roles',  'GET /system/roles'),
]:
    r = requests.get(f'{ROOT}{path}', headers=hdr)
    d = r.json()
    check(f'{label} 200', d.get('code') == 200, str(d.get('code')))

# ─── A类: stub 接口 ──────────────────────────────────────────────────────────
print('\n[5] Stub 接口')
stubs = [
    ('POST', f'{BASE}/data-validation/check',   'POST /api/data-validation/check',   None),
    ('GET',  f'{BASE}/data-validation/history', 'GET /api/data-validation/history',  None),
    ('GET',  f'{BASE}/data-entry/list',          'GET /api/data-entry/list',           None),
    ('GET',  f'{BASE}/data-entry/page',          'GET /api/data-entry/page',           None),
    ('GET',  f'{BASE}/dataset/list',             'GET /api/dataset/list',              None),
    ('GET',  f'{BASE}/dataset/page',             'GET /api/dataset/page',              None),
    ('GET',  f'{BASE}/report/list',              'GET /api/report/list',               None),
    ('GET',  f'{BASE}/report/page',              'GET /api/report/page',               None),
]
for method, url, label, body in stubs:
    if method == 'GET':
        r = requests.get(url, headers=hdr)
    else:
        r = requests.post(url, headers=hdr, json=body or {})
    d = r.json()
    check(f'{label} 200', d.get('code') == 200, str(d.get('code')))

# ─── B类: 计算接口错误码应为 4xx 而非 500 ──────────────────────────────────
print('\n[6] B类计算接口（用不存在的指标码，应返回 30400/30404 而非 500）')
r = requests.post(f'{BASE}/indicator-result/calculate',
                  params={'metricCode':'NO_EXIST','timeDimension':'MONTH',
                          'startDate':'2020-01-01','endDate':'2020-01-31'},
                  headers=hdr)
d = r.json()
check('不存在指标计算 → 4xx 非500', d.get('code') in (30400, 30404, 4040), str(d.get('code')) + ' ' + str(d.get('message')))

r = requests.post(f'{BASE}/indicator-result/dept-drill-down',
                  params={'metricCode':'NO_EXIST','timeDimension':'MONTH',
                          'startDate':'2020-01-01','endDate':'2020-01-31'},
                  headers=hdr)
d = r.json()
check('不存在指标下钻 → 4xx 非500', d.get('code') in (30400, 30404, 4040), str(d.get('code')) + ' ' + str(d.get('message')))

# ─── 原有正常接口验证（回归） ─────────────────────────────────────────────
print('\n[7] 回归：原有正常接口')
for path, label in [
    ('/api/indicator/page', 'GET /api/indicator/page'),
    ('/api/indicator/tree', 'GET /api/indicator/tree'),
    ('/api/indicator-result/latest', 'GET /api/indicator-result/latest'),
    ('/api/indicator-scope/by-dept/1', 'GET /api/indicator-scope/by-dept/1'),
    ('/system/dept/tree', 'GET /system/dept/tree'),
    ('/system/user/list', 'GET /system/user/list'),
]:
    r = requests.get(f'{ROOT}{path}', headers=hdr)
    d = r.json()
    check(f'{label} 200', d.get('code') == 200, str(d.get('code')))

# ─── 统计 ─────────────────────────────────────────────────────────────────
print('\n' + '='*55)
print(f'结果: 正常 {OK} / 失败 {FAIL} / 总计 {OK+FAIL}')
print('='*55)
for line in results:
    print(line)
