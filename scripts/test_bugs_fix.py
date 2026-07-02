import sys, requests, json
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://localhost:8070/dgear'

# login
r = requests.post(ROOT + '/auth/login', params={'username':'admin','password':'Admin@123'})
tok = r.json()['data']['token']
hdr = {'Authorization': 'Bearer ' + tok, 'Content-Type': 'application/json'}

print('=== B1: validate-sql ===')
cases = [
    ('DROP TABLE patient',        False),
    ('DELETE FROM patient',       False),
    ('UPDATE patient SET name=1', False),
    ('SELECT COUNT(*) FROM d_mr', True),
]
for sql, expect_valid in cases:
    resp = requests.post(ROOT + '/api/indicator-item/validate-sql', headers=hdr, json=sql)
    d = resp.json()
    code = d['code']
    valid = (d.get('data') or {}).get('valid', None)
    # After fix: dangerous SQL -> code=30400; valid SQL -> code=200 valid=True
    ok = (code == 30400 and expect_valid == False) or (code == 200 and expect_valid == True and valid == True)
    print('  [%s] %s -> code=%s valid=%s' % ('OK' if ok else 'FAIL', sql[:35], code, valid))

print()
print('=== B2: validate-expression ===')
cases2 = [
    ('!@#invalid%%%', False),
    ('a0050 * 1.0 / a0030', True),
]
for expr, expect_valid in cases2:
    resp = requests.post(ROOT + '/api/indicator/validate-expression', headers=hdr, json=expr)
    d = resp.json()
    code = d['code']
    valid = (d.get('data') or {}).get('valid', None)
    ok = (code == 30400 and not expect_valid) or (code == 200 and expect_valid and valid == True)
    print('  [%s] %r -> code=%s valid=%s' % ('OK' if ok else 'FAIL', expr, code, valid))

print()
print('=== B4: binding missing deptId ===')
resp = requests.post(ROOT + '/api/indicator-scope/binding', headers=hdr,
                     json={'metricCode': 'rate_incision_infection', 'isPrimaryOwner': 1})
d = resp.json()
ok = d['code'] == 30400
print('  [%s] missing deptId -> code=%s msg=%s' % ('OK' if ok else 'FAIL', d['code'], d['message'][:60]))

# real deptId
depts = requests.get(ROOT + '/system/depts', headers=hdr).json()['data']
real_id = depts[0]['deptId'] if depts else 1
resp2 = requests.post(ROOT + '/api/indicator-scope/binding', headers=hdr,
                      json={'deptId': real_id, 'metricCode': 'rate_incision_infection', 'isPrimaryOwner': 1})
d2 = resp2.json()
ok2 = d2['code'] == 200
print('  [%s] real deptId=%s -> code=%s' % ('OK' if ok2 else 'FAIL', real_id, d2['code']))

print()
print('=== B5: batch-calculate month limit ===')
resp = requests.post(ROOT + '/api/indicator-result/batch-calculate',
                     headers=hdr,
                     params={'timeDimension':'MONTH','startDate':'2020-01-01','endDate':'2020-06-30'})
d = resp.json()
ok = d['code'] == 30400 and '月' in d['message']
print('  [%s] 6-month span -> code=%s msg=%s' % ('OK' if ok else 'FAIL', d['code'], d['message'][:80]))

resp2 = requests.post(ROOT + '/api/indicator-result/batch-calculate',
                      headers=hdr,
                      params={'timeDimension':'MONTH','startDate':'2020-01-01','endDate':'2020-03-31'})
d2 = resp2.json()
ok2 = d2['code'] == 200
print('  [%s] 3-month span -> code=%s' % ('OK' if ok2 else 'FAIL', d2['code']))

print()
print('=== B6: system/config auth ===')
r_nurse = requests.post(ROOT + '/auth/login', params={'username':'neuro_nurse','password':'Nurse@123'})
nurse_tok = r_nurse.json()['data']['token']
resp = requests.post(ROOT + '/api/system/config',
                     headers={'Authorization': 'Bearer ' + nurse_tok, 'Content-Type':'application/json'},
                     json={'hospital_name': 'hacker hospital'})
d = resp.json()
ok = d['code'] == 30403
print('  [%s] neuro_nurse POST /config -> code=%s' % ('OK' if ok else 'FAIL', d['code']))

resp_admin = requests.post(ROOT + '/api/system/config', headers=hdr, json={'hospital_name': '测试医院'})
ok2 = resp_admin.json()['code'] == 200
print('  [%s] admin POST /config -> code=%s' % ('OK' if ok2 else 'FAIL', resp_admin.json()['code']))
