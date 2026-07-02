import sys, requests, json
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://localhost:8070/dgear'
tok = requests.post(ROOT + '/auth/login', params={'username':'admin','password':'Admin@123'}).json()['data']['token']
hdr = {'Authorization': 'Bearer ' + tok}

def ok(cond, label): print('  [%s] %s' % ('OK' if cond else 'FAIL', label))

print('=== 模式一：趋势对比（单指标 x 多时间段）===')
r = requests.get(ROOT + '/api/indicator-result/compare', headers=hdr, params={
    'metricCode': 'rate_incision_infection',
    'timeDimension': 'YEAR',
    'timeValues': '2020,2021,2022,2023'
})
d = r.json()
ok(d['code'] == 200, f'code=200')
data = d.get('data', {})
ok(data.get('mode') == 'TREND', f"mode={data.get('mode')}")
ok(len(data.get('xAxis',[])) == 4, f"xAxis={data.get('xAxis')}")
series = data.get('series', [])
ok(len(series) == 1, f"series 条数={len(series)}")
if series:
    s = series[0]
    print(f"  指标: {s['metricCode']} - {s['metricName']}")
    for pt in s.get('data', []):
        print(f"    {pt['timeValue']}: {pt['resultValue']}")

print()
print('=== 模式二：横向对比（多指标 x 单时间段）===')
r2 = requests.get(ROOT + '/api/indicator-result/compare', headers=hdr, params={
    'metricCodes': 'rate_incision_infection,rate_surgery_complication,avg_cost_pneumonia_adult',
    'timeDimension': 'YEAR',
    'timeValue': '2020'
})
d2 = r2.json()
ok(d2['code'] == 200, f'code=200')
data2 = d2.get('data', {})
ok(data2.get('mode') == 'CROSS', f"mode={data2.get('mode')}")
series2 = data2.get('series', [])
ok(len(series2) == 3, f"series 条数={len(series2)}")
print(f"  xAxis={data2.get('xAxis')}")
for s in series2:
    val = s['data'][0]['resultValue'] if s.get('data') else None
    print(f"    {s['metricCode']:40} value={val}")

print()
print('=== 错误参数校验 ===')
r3 = requests.get(ROOT + '/api/indicator-result/compare', headers=hdr, params={
    'metricCode': 'rate_incision_infection', 'timeDimension': 'YEAR'
    # 缺 timeValues
})
ok(r3.json()['code'] == 30400, f"缺参数 -> code={r3.json()['code']}")
