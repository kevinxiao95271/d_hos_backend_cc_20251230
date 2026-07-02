#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""指标监测报告接口自测脚本"""
import sys, requests, json, os

sys.stdout.reconfigure(encoding='utf-8')

ROOT = 'http://81.71.44.180:8070/dgear'
BASE = ROOT + '/api'  # 新接口带 /api 前缀
OUT_DIR = r'd:\iCode\cursor\d_hos_backend_cc_20251230\target'

def ok(label, code, expected=200):
    status = '[OK]' if code == expected else '[FAIL]'
    print(f'{status} {label} code={code}')
    return code == expected

# ─── 1. 登录 ──────────────────────────────────────────────────────────────
r = requests.post(ROOT+'/auth/login', params={'username': 'admin', 'password': 'Admin@123'})
d = r.json()
token = d.get('data', {}).get('token', '')
ok('POST /auth/login', d.get('code'))
H = {'Authorization': 'Bearer ' + token}

print()

# ─── 2. 系统配置 ──────────────────────────────────────────────────────────
r = requests.get(BASE+'/system/config', headers=H)
d = r.json()
ok('GET /system/config', d.get('code'))
for c in d.get('data', []):
    print(f'  {c["configKey"]:25} = {c["configValue"]}')

# 更新医院名称
r = requests.post(BASE+'/system/config', headers=H,
                  json={'hospital_name': '灵山县中医医院', 'hospital_level': '三级中医医院'})
ok('POST /system/config (update hospital_name)', r.json().get('code'))
print()

# ─── 3. 报告预览 - 2020年度 ────────────────────────────────────────────────
print('=== 年度报告预览 (2020) ===')
r = requests.get(BASE+'/indicator/report/preview',
                 params={'startPeriod': '2020', 'endPeriod': '2020', 'reportType': 'ANNUAL'},
                 headers=H)
d = r.json()
ok('GET /indicator/report/preview ANNUAL 2020', d.get('code'))
if d.get('code') == 200:
    data = d.get('data', {})
    meta = data.get('meta', {})
    summary = data.get('summary', {})
    indicators = data.get('indicators', [])
    print(f'  医院: {meta.get("hospitalName")}')
    print(f'  周期: {meta.get("periodDesc")}')
    print(f'  指标总数: {summary.get("totalCount")}  达标: {summary.get("compliantCount")}  未达标: {summary.get("nonCompliantCount")}  其他: {summary.get("otherCount")}')
    print(f'  详情指标数: {len(indicators)}')
    if indicators:
        s0 = indicators[0]
        print(f'  首个指标: {s0.get("metricCode")} {s0.get("metricName")}')
        bi = s0.get('basicInfo', {})
        print(f'    当前值={bi.get("currentValue")}  目标值={bi.get("targetValue")}  方向={bi.get("direction")}')
        print(f'    趋势数据条数: {len(s0.get("trendData",[]))}')
        print(f'    科室监测条数: {len(s0.get("deptData",[]))}')
print()

# ─── 4. 报告预览 - 月度（2020-01 ~ 2020-03） ─────────────────────────────
print('=== 月度报告预览 (202001-202003) ===')
r = requests.get(BASE+'/indicator/report/preview',
                 params={'startPeriod': '202001', 'endPeriod': '202003', 'reportType': 'MONTHLY'},
                 headers=H)
d = r.json()
ok('GET /indicator/report/preview MONTHLY 202001-202003', d.get('code'))
if d.get('code') == 200:
    data = d.get('data', {})
    summary = data.get('summary', {})
    indicators = data.get('indicators', [])
    print(f'  周期: {data.get("meta",{}).get("periodDesc")}')
    print(f'  指标总数: {summary.get("totalCount")}  其他: {summary.get("otherCount")}')
    # 找有数据的指标
    with_data = [i for i in indicators if i.get('trendData')]
    print(f'  有趋势数据的指标: {len(with_data)}')
    for ind in with_data[:3]:
        print(f'    {ind["metricCode"]} {ind["metricName"][:20]}  趋势={len(ind.get("trendData",[]))}期')
print()

# ─── 5. 导出年度Word报告 ──────────────────────────────────────────────────
print('=== 导出年度Word报告 (2020) ===')
r = requests.get(BASE+'/indicator/report/export',
                 params={'startPeriod': '2020', 'endPeriod': '2020', 'reportType': 'ANNUAL'},
                 headers=H, stream=True)
if r.status_code == 200:
    ct = r.headers.get('Content-Type', '')
    cd = r.headers.get('Content-Disposition', '')
    print(f'  Content-Type: {ct}')
    print(f'  Content-Disposition: {cd[:80]}')
    out_path = os.path.join(OUT_DIR, '年度报告_2020.docx')
    with open(out_path, 'wb') as f:
        for chunk in r.iter_content(8192):
            f.write(chunk)
    size = os.path.getsize(out_path)
    ok('GET /indicator/report/export ANNUAL 2020', 200)
    print(f'  文件大小: {size} bytes  保存至: {out_path}')
else:
    ok('GET /indicator/report/export ANNUAL 2020', r.status_code)
    print(f'  错误: {r.text[:200]}')
print()

# ─── 6. 导出月度Word报告 ─────────────────────────────────────────────────
print('=== 导出月度Word报告 (202001-202003) ===')
r = requests.get(BASE+'/indicator/report/export',
                 params={'startPeriod': '202001', 'endPeriod': '202003', 'reportType': 'MONTHLY'},
                 headers=H, stream=True)
if r.status_code == 200:
    out_path = os.path.join(OUT_DIR, '月度报告_202001-202003.docx')
    with open(out_path, 'wb') as f:
        for chunk in r.iter_content(8192):
            f.write(chunk)
    size = os.path.getsize(out_path)
    ok('GET /indicator/report/export MONTHLY 202001-202003', 200)
    print(f'  文件大小: {size} bytes  保存至: {out_path}')
else:
    ok('GET /indicator/report/export MONTHLY 202001-202003', r.status_code)
    try:
        print(f'  错误: {r.json()}')
    except:
        print(f'  错误: {r.text[:200]}')
print()

print('=== 自测完成 ===')
