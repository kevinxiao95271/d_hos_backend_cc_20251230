import sys, requests, json
sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://localhost:8070/dgear'
r = requests.post(f'{ROOT}/auth/login', params={'username':'admin','password':'Admin@123'})
tok = r.json()['data']['token']
hdr = {'Authorization': f'Bearer {tok}', 'Content-Type': 'application/json'}

print('=== B1: validate-sql 危险SQL ===')
for sql in ['DROP TABLE patient', 'DELETE FROM patient', 'UPDATE patient SET name=1', 'SELECT COUNT(*) FROM d_mr']:
    r = requests.post(f'{ROOT}/api/indicator-item/validate-sql', headers=hdr, json=sql)
    d = r.json()
    print(f'  SQL={sql[:30]!r:35} code={d["code"]} valid={d.get("data",{}).get("valid")}')

print('\n=== B2: validate-expression ===')
for expr in ['!@#非法表达式%%%', 'a0050 * 1.0 / a0030', '']:
    r = requests.post(f'{ROOT}/api/indicator/validate-expression', headers=hdr, json=expr)
    d = r.json()
    print(f'  expr={expr!r:25} code={d["code"]} valid={d.get("data",{}).get("valid")}')

print('\n=== B3: indicator/save isLeaf=1 ===')
body = {
    "metricCode": "test_leaf_999",
    "metricName": "测试叶子指标",
    "isLeaf": 1,
    "metricType": "QUANTITATIVE",
    "calculationType": "EXPRESSION",
    "expression": "a0029 * 1.0 / a0030",
    "relatedItems": "[\"a0029\",\"a0030\"]",
    "status": 1
}
r = requests.post(f'{ROOT}/api/indicator/save', headers=hdr, json=body)
print(f'  isLeaf=1 EXPRESSION → code={r.json()["code"]} msg={r.json()["message"]}')

body2 = {**body, "metricCode": "test_nonleaf_999", "metricName": "测试非叶子", "isLeaf": 0, "calculationType": "NONE"}
r2 = requests.post(f'{ROOT}/api/indicator/save', headers=hdr, json=body2)
print(f'  isLeaf=0 NONE       → code={r2.json()["code"]} msg={r2.json()["message"]}')

# 清理测试数据
for code in ['test_leaf_999', 'test_nonleaf_999']:
    rr = requests.get(f'{ROOT}/api/indicator/code/{code}', headers=hdr)
    if rr.json()['code'] == 200 and rr.json().get('data'):
        iid = rr.json()['data']['id']
        requests.delete(f'{ROOT}/api/indicator/{iid}', headers=hdr)

print('\n=== B4: indicator-scope/binding ===')
# 先查一个真实 deptId
depts = requests.get(f'{ROOT}/system/depts', headers=hdr).json()['data']
real_dept_id = depts[0]['deptId'] if depts else None
print(f'  真实 deptId={real_dept_id}')
r = requests.post(f'{ROOT}/api/indicator-scope/binding', headers=hdr,
                  json={"deptId": real_dept_id, "metricCode": "rate_incision_infection", "isPrimaryOwner": 1})
print(f'  真实deptId绑定 → code={r.json()["code"]} msg={r.json()["message"]}')

r2 = requests.post(f'{ROOT}/api/indicator-scope/binding', headers=hdr,
                   json={"deptId": 1001, "metricCode": "rate_incision_infection", "isPrimaryOwner": 1})
print(f'  fake deptId=1001 → code={r2.json()["code"]} msg={r2.json()["message"]}')

print('\n=== B6: system/config 权限 ===')
r_nurse = requests.post(f'{ROOT}/auth/login', params={'username':'neuro_nurse','password':'Nurse@123'})
nurse_tok = r_nurse.json()['data']['token']
r = requests.post(f'{ROOT}/api/system/config', headers={'Authorization': f'Bearer {nurse_tok}',
    'Content-Type':'application/json'}, json={"hospital_name": "黑客医院"})
print(f'  neuro_nurse POST /api/system/config → code={r.json()["code"]}')
