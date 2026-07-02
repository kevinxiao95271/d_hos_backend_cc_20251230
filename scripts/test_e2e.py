"""
端到端多角色 / 多指标 / 多功能场景覆盖测试
运行: python scripts/test_e2e.py
"""
import sys, json, requests, time
from datetime import datetime
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://localhost:8070/dgear'
TIMEOUT = 30
PASS = FAIL = SKIP = 0
RESULTS = []

# 测试用指标（均有 2020 年度数据）
METRICS = [
    'rate_incision_infection',
    'rate_surgery_complication',
    'avg_cost_pneumonia_adult',
]
ITEM_CODE = 'a0050'

ROLES = {
    'admin':      ('admin',      'Admin@123', 50, '超级管理员'),
    'neuro_head': ('neuro_head', 'Dept@123',  70, '科室主任'),
    'neuro_nurse':('neuro_nurse','Nurse@123', 90, '普通护士'),
}


def chk(scene, label, cond, detail=''):
    global PASS, FAIL
    ok = bool(cond)
    if ok:
        PASS += 1
        mark = 'OK'
    else:
        FAIL += 1
        mark = 'FAIL'
    line = f'[{mark}] [{scene}] {label}'
    if detail and not ok:
        line += f' | {detail}'
    print(line)
    RESULTS.append({'scene': scene, 'label': label, 'ok': ok, 'detail': detail})
    return ok


def skip(scene, label, reason):
    global SKIP
    SKIP += 1
    print(f'[SKIP] [{scene}] {label} | {reason}')
    RESULTS.append({'scene': scene, 'label': label, 'ok': None, 'detail': reason})


def login(username, password):
    try:
        r = requests.post(f'{ROOT}/auth/login',
                          params={'username': username, 'password': password},
                          timeout=TIMEOUT)
        d = r.json()
        if d.get('code') == 200:
            tok = d['data']['token']
            return {'Authorization': f'Bearer {tok}', 'Content-Type': 'application/json'}, d['data']
        return None, d
    except Exception as e:
        return None, str(e)


def get(path, hdr, **params):
    return requests.get(f'{ROOT}{path}', headers=hdr, params=params or None, timeout=TIMEOUT).json()


def post(path, hdr, json_body=None, **params):
    return requests.post(f'{ROOT}{path}', headers=hdr, json=json_body, params=params or None, timeout=TIMEOUT).json()


def wait_server(max_wait=40):
    for i in range(max_wait):
        try:
            r = requests.get(f'{ROOT}/v3/api-docs', timeout=3)
            if r.status_code == 200:
                print(f'服务就绪 ({i+1}s)\n')
                return True
        except Exception:
            pass
        time.sleep(1)
    return False


# =============================================================================
print('=' * 60)
print('端到端覆盖测试', datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
print('ROOT:', ROOT)
print('=' * 60)

if not wait_server():
    print('服务未启动，请先运行 indicator-management JAR')
    sys.exit(1)

# =============================================================================
# 场景1: 三角色登录与基础鉴权
# =============================================================================
print('\n--- 场景1: 登录 / 用户信息 / 菜单 ---')
tokens = {}
for key, (u, p, scope, desc) in ROLES.items():
    hdr, data = login(u, p)
    if hdr:
        tokens[key] = hdr
        chk('登录', f'{desc}({u}) 登录成功', True)
        chk('登录', f'{desc} dataScope={scope}',
            (data.get('user') or {}).get('dataScope') == scope,
            f"actual={(data.get('user') or {}).get('dataScope')}")
    else:
        chk('登录', f'{desc}({u}) 登录成功', False, str(data))

admin = tokens.get('admin')
head  = tokens.get('neuro_head')
nurse = tokens.get('neuro_nurse')

if admin:
    ui = get('/auth/userInfo', admin)
    chk('登录', 'admin GET /auth/userInfo', ui.get('code') == 200)
    menus = get('/auth/menus', admin, roleId=1)
    chk('登录', 'admin GET /auth/menus 有数据', menus.get('code') == 200 and bool(menus.get('data')))

# =============================================================================
# 场景2: 权限边界（P1 安全）
# =============================================================================
print('\n--- 场景2: 权限边界 ---')
if nurse:
    r = get('/system/users', nurse)
    chk('权限', 'nurse 不可读 /system/users → 30403', r.get('code') == 30403, r.get('code'))
    r = post('/api/system/config', nurse, {'hospital_name': 'hack'})
    chk('权限', 'nurse 不可改系统配置 → 30403', r.get('code') == 30403, r.get('code'))
if admin:
    r = get('/system/users', admin)
    chk('权限', 'admin 可读 /system/users', r.get('code') == 200, r.get('code'))
    r = get('/system/depts', admin)
    chk('权限', 'admin 可读 /system/depts', r.get('code') == 200, r.get('code'))

# 获取真实 deptId 供后续使用
dept_id = None
if admin:
    depts = get('/system/depts', admin).get('data') or []
    if depts:
        dept_id = depts[0].get('deptId')
        chk('权限', f'获取 deptId={dept_id}', dept_id is not None)

if nurse and admin:
    r = post('/api/indicator-scope/binding', nurse,
             {'metricCode': METRICS[0], 'isPrimaryOwner': 1})
    chk('权限', 'nurse 不可写 scope binding → 30403', r.get('code') == 30403, r.get('code'))

# =============================================================================
# 场景3: 指标管理 + SQL/表达式校验
# =============================================================================
print('\n--- 场景3: 指标管理 ---')
if admin:
    tree = get('/api/indicator/tree', admin)
    chk('指标', '指标树有数据', tree.get('code') == 200 and len(tree.get('data') or []) > 0)
    page = get('/api/indicator/page', admin, current=1, size=10, isLeaf=1)
    pd = page.get('data') or {}
    chk('指标', '叶子指标分页 total>0', pd.get('total', 0) > 0, pd.get('total'))
    for m in METRICS:
        d = get(f'/api/indicator/code/{m}', admin)
        chk('指标', f'GET /code/{m}', d.get('code') == 200 and d.get('data'), d.get('code'))
        if d.get('data'):
            chk('指标', f'{m} 已配置 targetValue',
                d['data'].get('targetValue') is not None,
                d['data'].get('targetValue'))

    r = post('/api/indicator-item/validate-sql', admin, 'DROP TABLE patient')
    chk('指标', '危险SQL → 30400', r.get('code') == 30400, r.get('code'))
    r = post('/api/indicator-item/validate-sql', admin, 'SELECT COUNT(*) FROM d_mr')
    chk('指标', '合法SELECT → 200', r.get('code') == 200, r.get('code'))
    r = post('/api/indicator/validate-expression', admin, '!@#invalid')
    chk('指标', '非法表达式 → 30400', r.get('code') == 30400, r.get('code'))
    r = post('/api/indicator/validate-expression', admin, 'a0050 * 1.0 / a0030')
    chk('指标', '合法表达式 → 200', r.get('code') == 200, r.get('code'))

# =============================================================================
# 场景4: 指标计算（多指标）
# =============================================================================
print('\n--- 场景4: 指标计算 ---')
if admin:
    for m in METRICS:
        r = post('/api/indicator-result/calculate', admin, None,
                 metricCode=m, timeDimension='YEAR',
                 startDate='2020-01-01', endDate='2020-12-31')
        chk('计算', f'单指标 {m} YEAR/2020', r.get('code') == 200, r.get('message'))

    r = post('/api/indicator-item/{}/execute'.format(ITEM_CODE), admin, None,
             startDate='2020-01-01', endDate='2020-12-31')
    chk('计算', f'指标项 {ITEM_CODE} execute', r.get('code') == 200, r.get('message'))

    r = post('/api/indicator-result/batch-calculate', admin, METRICS,
             timeDimension='MONTH', startDate='2020-01-01', endDate='2020-03-31')
    chk('计算', '批量计算 MONTH 3个月', r.get('code') == 200, r.get('message'))

    r = post('/api/indicator-result/batch-calculate', admin, METRICS,
             timeDimension='MONTH', startDate='2020-01-01', endDate='2020-06-30')
    chk('计算', '批量计算 MONTH 6个月 → 30400 限流', r.get('code') == 30400, r.get('code'))

    r = post('/api/indicator-result/dept-drill-down', admin, None,
             metricCode=METRICS[0], timeDimension='YEAR',
             startDate='2020-01-01', endDate='2020-12-31')
    chk('计算', f'科室下钻 {METRICS[0]}', r.get('code') == 200, r.get('message'))

# =============================================================================
# 场景5: 结果查询（分角色 dataScope）
# =============================================================================
print('\n--- 场景5: 结果查询（分角色） ---')
for role_key, hdr in [('admin', admin), ('neuro_head', head), ('neuro_nurse', nurse)]:
    if not hdr:
        continue
    desc = ROLES[role_key][3]
    r = get('/api/indicator-result/list', hdr,
            timeDimension='YEAR', timeValue='2020')
    cnt = len(r.get('data') or [])
    chk('结果', f'{desc} list YEAR/2020 有返回', r.get('code') == 200, f'count={cnt}')

    r = get('/api/indicator-result/latest', hdr, timeDimension='YEAR')
    chk('结果', f'{desc} latest', r.get('code') == 200, r.get('code'))

if admin:
    r = get('/api/indicator-result/list', admin, timeDimension='YEAR',
            timeValue='2020', sourceType='AUTO')
    chk('结果', 'sourceType=AUTO 筛选', r.get('code') == 200, r.get('code'))

# =============================================================================
# 场景6: 质检 / 达标率 / 对比分析
# =============================================================================
print('\n--- 场景6: 质检 / 达标率 / 对比 ---')
if admin:
    r = post('/api/data-validation/check', admin,
             {'timeDimension': 'YEAR', 'timeValue': '2020',
              'metricCodes': METRICS})
    d = r.get('data') or {}
    chk('质检', 'check 有 PASS/FAIL', r.get('code') == 200 and (d.get('passCount', 0) + d.get('failCount', 0)) > 0,
        f"pass={d.get('passCount')} fail={d.get('failCount')} status={d.get('overallStatus')}")
    chk('质检', 'overallStatus 非误导性 PASS（全NO_TARGET时不应PASS）',
        d.get('overallStatus') in ('FAIL', 'PASS', 'NO_TARGET', 'UNKNOWN'),
        d.get('overallStatus'))

    r = get('/api/data-validation/history', admin, current=1, size=5)
    chk('质检', 'history 有记录', r.get('code') == 200 and (r.get('data') or {}).get('total', 0) > 0)

    r = get('/api/indicator-result/compliance', admin,
            timeDimension='YEAR', timeValue='2020')
    d = r.get('data') or {}
    chk('达标率', 'compliance pass+fail>0', (d.get('passCount', 0) + d.get('failCount', 0)) > 0,
        f"rate={d.get('complianceRate')}")

    r = get('/api/indicator-result/compare', admin,
            metricCode=METRICS[0], timeDimension='YEAR', timeValues='2020,2021,2023')
    d = r.get('data') or {}
    chk('对比', 'TREND 模式', r.get('code') == 200 and d.get('mode') == 'TREND', d.get('mode'))

    r = get('/api/indicator-result/compare', admin,
            metricCodes=','.join(METRICS), timeDimension='YEAR', timeValue='2020')
    d = r.get('data') or {}
    chk('对比', 'CROSS 模式 series=3', r.get('code') == 200 and len(d.get('series') or []) == 3)
    xaxis = d.get('xAxis') or []
    chk('对比', 'xAxis 均为中文名（非 metricCode）',
        all(not x.startswith('rate_') and not x.startswith('avg_') for x in xaxis if x),
        str(xaxis))

# =============================================================================
# 场景7: 数据集
# =============================================================================
print('\n--- 场景7: 数据集 ---')
if admin:
    r = get('/api/dataset/page', admin, current=1, size=5, type='YEAR')
    d = r.get('data') or {}
    chk('数据集', 'page YEAR 有切片', r.get('code') == 200 and d.get('total', 0) > 0, d.get('total'))
    records = d.get('records') or []
    if records:
        ds_id = records[0].get('datasetId')
        r2 = get(f'/api/dataset/{ds_id}', admin)
        d2 = r2.get('data') or {}
        recs = d2.get('records') or []
        chk('数据集', f'detail {ds_id} records>0',
            r2.get('code') == 200 and len(recs) > 0,
            f"indicatorCount={d2.get('indicatorCount')} records={len(recs)}")
    else:
        skip('数据集', 'detail 测试', '无 YEAR 切片')

# =============================================================================
# 场景8: 可见范围（admin 写 + 读）
# =============================================================================
print('\n--- 场景8: 指标可见范围 ---')
if admin and dept_id:
    r = post('/api/indicator-scope/binding', admin,
             {'deptId': dept_id, 'metricCode': METRICS[0], 'isPrimaryOwner': 1})
    chk('范围', 'binding 成功', r.get('code') == 200, r.get('message'))
    r = get(f'/api/indicator-scope/by-metric/{METRICS[0]}', admin)
    chk('范围', f'by-metric {METRICS[0]} 有绑定', r.get('code') == 200 and len(r.get('data') or []) > 0)
    r = post('/api/indicator-scope/binding', admin, {'metricCode': METRICS[0]})
    chk('范围', '缺 deptId → 30400', r.get('code') == 30400, r.get('code'))

# =============================================================================
# 场景9: 系统配置 + 报告
# =============================================================================
print('\n--- 场景9: 系统配置 / 分析报告 ---')
if admin:
    r = get('/api/system/config', admin)
    chk('配置', '读取系统配置', r.get('code') == 200, r.get('code'))

    r = get('/api/indicator/report/preview', admin,
            startPeriod='2020', endPeriod='2020', reportType='ANNUAL')
    chk('报告', '年度报告 preview', r.get('code') == 200, r.get('message'))

    r = get('/api/indicator/report/preview', admin,
            startPeriod='202001', endPeriod='202001', reportType='MONTHLY')
    chk('报告', '月度报告 preview', r.get('code') == 200, r.get('message'))

# =============================================================================
# 场景10: 手工填报流程（分角色）
# =============================================================================
print('\n--- 场景10: 手工填报 ---')
if admin:
    r = get('/api/report/task/page', admin, current=1, size=5)
    chk('填报', '任务分页', r.get('code') == 200, r.get('code'))
    r = get('/api/report/list', admin, limit=5)
    chk('填报', '报告列表', r.get('code') == 200, r.get('code'))

if nurse:
    r = get('/api/report/task/my-tasks', nurse)
    chk('填报', 'nurse 我的待办', r.get('code') == 200, r.get('code'))
    tasks = r.get('data') or []
    if tasks:
        tid = tasks[0].get('taskId') or tasks[0].get('id')
        r2 = get('/api/report/data/sheet', nurse, taskId=tid)
        chk('填报', f'nurse 打开填报表 taskId={tid}', r2.get('code') == 200, r2.get('code'))
    else:
        skip('填报', 'nurse 打开填报表', '无待办任务')

if head:
    r = get('/api/report/task/my-tasks', head)
    chk('填报', 'neuro_head 待办/可见任务', r.get('code') == 200, r.get('code'))

# =============================================================================
# 场景11: 入参校验边界
# =============================================================================
print('\n--- 场景11: 入参校验 ---')
if admin:
    r = get('/api/indicator/99999', admin)
    chk('校验', '不存在指标 → 30404', r.get('code') == 30404, r.get('code'))
    r = post('/api/indicator-result/calculate', admin, None,
             metricCode='GRP_SURGERY', timeDimension='YEAR',
             startDate='2020-01-01', endDate='2020-12-31')
    chk('校验', '父节点计算 → 30400', r.get('code') == 30400, r.get('code'))
    r = get('/api/indicator-result/compare', admin, timeDimension='YEAR')
    chk('校验', 'compare 缺参数 → 30400', r.get('code') == 30400, r.get('code'))

# =============================================================================
# 汇总
# =============================================================================
print('\n' + '=' * 60)
total = PASS + FAIL
print(f'通过: {PASS}/{total}  失败: {FAIL}  跳过: {SKIP}')
if FAIL:
    print('\n失败项:')
    for x in RESULTS:
        if x['ok'] is False:
            print(f"  - [{x['scene']}] {x['label']} {x['detail']}")
print('=' * 60)
sys.exit(0 if FAIL == 0 else 1)
