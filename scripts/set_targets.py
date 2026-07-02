import sys, requests
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://localhost:8070/dgear'
tok = requests.post(ROOT + '/auth/login', params={'username':'admin','password':'Admin@123'}, timeout=30).json()['data']['token']
hdr = {'Authorization': 'Bearer ' + tok, 'Content-Type': 'application/json'}

# 1. 分页拉取全部叶子指标
leaf_inds = []
page = 1
while True:
    r = requests.get(ROOT + '/api/indicator/page', headers=hdr,
                     params={'current': page, 'size': 100, 'isLeaf': 1}, timeout=30)
    data = r.json().get('data') or {}
    records = data.get('records') or []
    leaf_inds.extend(records)
    if page >= data.get('pages', 1):
        break
    page += 1
print(f'叶子指标共 {len(leaf_inds)} 个')

# 2. 2020 年度结果
results = requests.get(ROOT + '/api/indicator-result/list', headers=hdr,
                       params={'timeDimension': 'YEAR', 'timeValue': '2020'}, timeout=30).json().get('data') or []
result_map = {r['metricCode']: r['resultValue'] for r in results if r.get('resultValue') is not None}
print(f'2020 年有结果: {len(result_map)} 个')

# 3. 演示用：几个关键指标写死目标值，便于看到 PASS/FAIL 对比
EXPLICIT = {
    'rate_incision_infection':   (0.001,  'DECREASE'),
    'rate_surgery_complication': (0.005,  'DECREASE'),
    'avg_cost_pneumonia_adult':  (5000,   'DECREASE'),
    'avg_cost_heart_failure':    (8000,   'DECREASE'),
}

def guess_target(code, name, rv):
    if code in EXPLICIT:
        return EXPLICIT[code]
    if rv is None:
        return None, 'MONITOR'
    decrease_kw = ['感染', '并发症', '死亡', '不良', '费用', '成本', '时长', '等待']
    increase_kw = ['满意', '覆盖', '完成', '正确', '治愈', '好转']
    if any(k in (name or '') for k in decrease_kw):
        return round(float(rv) * 0.8, 4), 'DECREASE'
    if any(k in (name or '') for k in increase_kw):
        return round(float(rv) * 1.1, 4), 'INCREASE'
    return float(rv), 'MONITOR'

updated = 0
for ind in leaf_inds:
    code = ind['metricCode']
    rv = result_map.get(code)
    target, direction = guess_target(code, ind.get('metricName'), rv)
    if target is None:
        continue

    body = {
        'id': ind['id'],
        'metricCode': code,
        'metricName': ind['metricName'],
        'parentCode': ind.get('parentCode'),
        'isLeaf': ind.get('isLeaf', 1),
        'metricType': ind.get('metricType', 'QUANTITATIVE'),
        'calculationType': ind.get('calculationType') or 'ITEM',
        'expression': ind.get('expression'),
        'relatedItems': ind.get('relatedItems'),
        'unit': ind.get('unit'),
        'status': ind.get('status', 1),
        'sortOrder': ind.get('sortOrder'),
        'metricPool': ind.get('metricPool'),
        'inputType': ind.get('inputType') or 'AUTO',
        'metricCategory': ind.get('metricCategory') or '医疗质量',
        'targetValue': target,
        'monitorDirection': direction,
    }
    resp = requests.post(ROOT + '/api/indicator/save', headers=hdr, json=body, timeout=30).json()
    if resp.get('code') == 200:
        updated += 1
        if code in EXPLICIT or updated <= 8:
            print(f'  OK {code:35} target={target} dir={direction}')
    else:
        print(f'  FAIL {code}: {resp.get("message")}')

print(f'\n共更新 {updated} 个指标')

# 4. 验证质检
print('\n=== 质检验证 YEAR/2020 ===')
chk = requests.post(ROOT + '/api/data-validation/check', headers=hdr,
                    json={'timeDimension': 'YEAR', 'timeValue': '2020'}, timeout=30).json().get('data', {})
print(f"  overallStatus={chk.get('overallStatus')} pass={chk.get('passCount')} fail={chk.get('failCount')} noTarget={chk.get('noTargetCount')}")

print('\n=== 达标率 YEAR/2020 ===')
cmp = requests.get(ROOT + '/api/indicator-result/compliance', headers=hdr,
                   params={'timeDimension': 'YEAR', 'timeValue': '2020'}, timeout=30).json().get('data', {})
print(f"  complianceRate={cmp.get('complianceRate')} pass={cmp.get('passCount')} fail={cmp.get('failCount')}")
for item in (cmp.get('items') or [])[:6]:
    if item.get('complianceStatus') in ('PASS', 'FAIL'):
        print(f"    {item['metricCode']:35} {item['complianceStatus']:6} result={item.get('resultValue')} target={item.get('targetValue')}")
