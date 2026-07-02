import sys, requests
sys.stdout.reconfigure(encoding='utf-8')
ROOT = 'http://localhost:8070/dgear'
tok = requests.post(ROOT + '/auth/login', params={'username':'admin','password':'Admin@123'}).json()['data']['token']
hdr = {'Authorization': 'Bearer ' + tok}

# 查 avg_cost_heart_failure 的指标信息
r = requests.get(ROOT + '/api/indicator/code/avg_cost_heart_failure', headers=hdr)
print('avg_cost_heart_failure in t_indicator:', r.json())
