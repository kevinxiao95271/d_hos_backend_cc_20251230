import sys, requests, json
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://localhost:8070/dgear'
tok = requests.post(ROOT + '/auth/login', params={'username':'admin','password':'Admin@123'}).json()['data']['token']
hdr = {'Authorization': 'Bearer ' + tok}

print('=== 诊断 P1: dataset detail records ===')
r = requests.get(ROOT + '/api/dataset/YEAR_2020', headers=hdr)
d = r.json().get('data', {})
print('  code     :', r.json()['code'])
print('  datasetId:', d.get('datasetId'))
print('  indicatorCount:', d.get('indicatorCount'))
records = d.get('records', 'KEY_MISSING')
print('  records type  :', type(records).__name__)
print('  records len   :', len(records) if isinstance(records, list) else 'N/A')
print('  records raw   :', str(records)[:200])

print()
print('=== 诊断 P2: compare CROSS xAxis ===')
r2 = requests.get(ROOT + '/api/indicator-result/compare', headers=hdr, params={
    'metricCodes': 'rate_incision_infection,rate_surgery_complication,avg_cost_pneumonia_adult,avg_cost_heart_failure',
    'timeDimension': 'YEAR', 'timeValue': '2020'
})
d2 = r2.json().get('data', {})
print('  xAxis:', d2.get('xAxis'))
print('  series metricCodes:', [s.get('metricCode') for s in d2.get('series', [])])
print('  series metricNames:', [s.get('metricName') for s in d2.get('series', [])])

print()
print('=== 诊断 P3: check overallStatus ===')
r3 = requests.post(ROOT + '/api/data-validation/check', headers=hdr,
                   json={'timeDimension':'YEAR','timeValue':'2020'})
d3 = r3.json().get('data', {})
print('  passCount   :', d3.get('passCount'))
print('  failCount   :', d3.get('failCount'))
print('  noTargetCount:', d3.get('noTargetCount'))
print('  overallStatus:', d3.get('overallStatus'))
