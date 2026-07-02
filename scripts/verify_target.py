import sys, requests
sys.stdout.reconfigure(encoding='utf-8')
ROOT = 'http://localhost:8070/dgear'
tok = requests.post(ROOT + '/auth/login', params={'username':'admin','password':'Admin@123'}).json()['data']['token']
hdr = {'Authorization': 'Bearer ' + tok, 'Content-Type': 'application/json'}

for code in ['rate_incision_infection', 'rate_surgery_complication', 'avg_cost_pneumonia_adult']:
    d = requests.get(ROOT + f'/api/indicator/code/{code}', headers=hdr).json().get('data') or {}
    print(f"{code}: target={d.get('targetValue')} dir={d.get('monitorDirection')}")

chk = requests.post(ROOT + '/api/data-validation/check', headers=hdr,
                    json={'timeDimension': 'YEAR', 'timeValue': '2020'}).json()['data']
print(f"\ncheck: {chk.get('overallStatus')} pass={chk.get('passCount')} fail={chk.get('failCount')} monitor={chk.get('monitorCount')}")

cmp = requests.get(ROOT + '/api/indicator-result/compliance', headers=hdr,
                   params={'timeDimension': 'YEAR', 'timeValue': '2020'}).json()['data']
print(f"compliance: {cmp.get('complianceRate')} pass={cmp.get('passCount')} fail={cmp.get('failCount')}")
for item in cmp.get('items') or []:
    if item.get('complianceStatus') in ('PASS', 'FAIL'):
        print(f"  {item['metricCode']:35} {item['complianceStatus']:4} result={item.get('resultValue')} target={item.get('targetValue')}")
