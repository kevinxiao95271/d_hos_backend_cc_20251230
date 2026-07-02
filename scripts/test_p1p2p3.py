import sys, requests, json
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://localhost:8070/dgear'
r = requests.post(ROOT + '/auth/login', params={'username':'admin','password':'Admin@123'})
tok = r.json()['data']['token']
hdr = {'Authorization': 'Bearer ' + tok, 'Content-Type': 'application/json'}

def ok(cond, label):
    print('  [%s] %s' % ('OK' if cond else 'FAIL', label))

# ===================== P1: 数据质检 =====================
print('=== P1: POST /api/data-validation/check ===')
r = requests.post(ROOT + '/api/data-validation/check', headers=hdr,
                  json={'timeDimension': 'YEAR', 'timeValue': '2020'})
d = r.json()
ok(d['code'] == 200, 'check code=200')
data = d.get('data', {})
ok('totalCount' in data, f"totalCount={data.get('totalCount')} passCount={data.get('passCount')} failCount={data.get('failCount')}")
ok('issues' in data, f"issues 条数={len(data.get('issues', []))}")
# 打印前3条
for item in data.get('issues', [])[:3]:
    print(f"    {item.get('metricCode'):30} status={item.get('status'):10} result={item.get('resultValue')} target={item.get('targetValue')}")

print()
print('=== P1: POST /api/data-validation/check (无参) ===')
r2 = requests.post(ROOT + '/api/data-validation/check', headers=hdr, json={})
d2 = r2.json()
ok(d2['code'] == 200, f"无参check totalCount={d2.get('data',{}).get('totalCount')}")

print()
print('=== P1: GET /api/data-validation/history ===')
r3 = requests.get(ROOT + '/api/data-validation/history', headers=hdr)
d3 = r3.json()
ok(d3['code'] == 200, f"history code=200 total={d3.get('data',{}).get('total')}")
for rec in (d3.get('data', {}).get('records', []))[:3]:
    print(f"    {rec.get('timeDimension')}/{rec.get('timeValue'):10} resultCount={rec.get('resultCount')} fail={rec.get('failCount')}")

# ===================== P2: 达标率 =====================
print()
print('=== P2: GET /api/indicator-result/compliance ===')
r4 = requests.get(ROOT + '/api/indicator-result/compliance',
                  headers=hdr, params={'timeDimension':'YEAR','timeValue':'2020'})
d4 = r4.json()
ok(d4['code'] == 200, f"compliance code=200 total={d4.get('data',{}).get('totalCount')} rate={d4.get('data',{}).get('complianceRate')}")
for item in (d4.get('data', {}).get('items', []))[:3]:
    print(f"    {item.get('metricCode'):30} {item.get('complianceStatus'):12} result={item.get('resultValue')} target={item.get('targetValue')}")

# ===================== P3: 数据集管理 =====================
print()
print('=== P3: GET /api/dataset/page ===')
r5 = requests.get(ROOT + '/api/dataset/page', headers=hdr, params={'current':1,'size':5})
d5 = r5.json()
ok(d5['code'] == 200, f"dataset page code=200 total={d5.get('data',{}).get('total')}")
datasets = d5.get('data', {}).get('records', [])
for ds in datasets[:3]:
    print(f"    datasetId={ds.get('datasetId'):20} indicatorCount={ds.get('indicatorCount')}")

print()
print('=== P3: GET /api/dataset/list?type=YEAR ===')
r6 = requests.get(ROOT + '/api/dataset/list', headers=hdr, params={'type':'YEAR'})
d6 = r6.json()
ok(d6['code'] == 200, f"dataset list YEAR count={len(d6.get('data',[]))}")

if datasets:
    ds_id = datasets[0]['datasetId']
    print()
    print(f'=== P3: GET /api/dataset/{ds_id} ===')
    r7 = requests.get(ROOT + '/api/dataset/' + ds_id, headers=hdr)
    d7 = r7.json()
    ok(d7['code'] == 200, f"dataset detail indicatorCount={d7.get('data',{}).get('indicatorCount')}")
