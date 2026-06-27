# -*- coding: utf-8 -*-
"""
手工填报子系统 · E2E 自测脚本
分三个角色验证完整流程
"""
import requests, json, sys

BASE = "http://81.71.44.180:8070/dgear"
OK   = "\033[32m[OK]\033[0m"
FAIL = "\033[31m[FAIL]\033[0m"
INFO = "\033[36m[INFO]\033[0m"

def api(method, path, token=None, data=None, params=None):
    h = {"Content-Type": "application/json"}
    if token:
        h["Authorization"] = f"Bearer {token}"
    url = BASE + path
    try:
        r = requests.request(method, url, headers=h,
                             json=data, params=params, timeout=15)
        body = r.json()
        ok = body.get("code") == 200
        symbol = OK if ok else FAIL
        print(f"{symbol} {method} {path}  code={body.get('code')}")
        if not ok:
            print(f"       msg={body.get('message')}")
        return body if ok else None
    except Exception as e:
        print(f"{FAIL} {method} {path}  err={e}")
        return None

# ─── Step 0: 三角色登录 ─────────────────────────────────────
print("\n" + "="*60)
print("【Step 0】三角色登录")
print("="*60)

r = api("POST", "/auth/login", params={"username":"admin","password":"Admin@123"})
admin_token = r["data"]["token"] if r else sys.exit("admin 登录失败")
admin_dept  = r["data"]["user"]["deptId"]
print(f"  admin  deptId={admin_dept} dataScope=50")

r = api("POST", "/auth/login", params={"username":"neuro_head","password":"Dept@123"})
head_token = r["data"]["token"] if r else sys.exit("neuro_head 登录失败")
head_dept  = r["data"]["user"]["deptId"]
print(f"  neuro_head  deptId={head_dept} dataScope=70")

r = api("POST", "/auth/login", params={"username":"neuro_nurse","password":"Nurse@123"})
nurse_token = r["data"]["token"] if r else sys.exit("neuro_nurse 登录失败")
nurse_dept  = r["data"]["user"]["deptId"]
print(f"  neuro_nurse  deptId={nurse_dept} dataScope=90")

# ─── 测试用指标（MANUAL） ────────────────────────────────────
MANUAL_CODES = ["10.3.1", "10.3.2", "10.3.2.1"]
print(f"\n{INFO} MANUAL 指标: {MANUAL_CODES}")
print(f"{INFO} 科室分配: neuro_head(dept={head_dept}) -> {MANUAL_CODES[:2]}")
print(f"{INFO} 科室分配: neuro_nurse(dept={nurse_dept}) -> {MANUAL_CODES[2:]}")

# ─── Step 1: 管理员查看/更新全局配置 ─────────────────────────
print("\n" + "="*60)
print("【Step 1】管理员：查看并更新全局填报配置")
print("="*60)

cfg = api("GET", "/api/report/config", token=admin_token)
if cfg:
    d = cfg["data"]
    print(f"  当前: inputMode={d['inputMode']} reviewMode={d['reviewMode']} versionStrategy={d['versionStrategy']}")

api("PUT", "/api/report/config", token=admin_token, data={
    "inputMode": "NUM_DEN_OR_RESULT",
    "versionStrategy": "VERSIONED",
    "reviewMode": "ADMIN_REVIEW",
    "defaultDeadlineDays": 15,
    "remindBeforeDays": 3,
    "allowResubmit": 1,
    "remark": "E2E测试配置"
})

# ─── Step 2: 管理员创建填报任务（分配2个科室） ───────────────
print("\n" + "="*60)
print("【Step 2】管理员：创建填报任务")
print("="*60)

r = api("POST", "/api/report/task", token=admin_token, data={
    "name": "2026年Q2手工填报-E2E",
    "timeDimension": "QUARTER",
    "startDate": "2026-04-01",
    "endDate": "2026-06-30",
    "deadline": "2026-07-15",
    "remark": "端到端自测",
    "scopes": [
        {"deptId": head_dept,  "deptName": "神经科", "metricCodes": MANUAL_CODES[:2]},
        {"deptId": nurse_dept, "deptName": "神经护士科", "metricCodes": MANUAL_CODES[2:]}
    ]
})
task_id = r["data"]["id"] if r else sys.exit("创建任务失败")
print(f"  taskId = {task_id}")

# ─── Step 3: 查任务详情（草稿状态） ─────────────────────────
print("\n" + "="*60)
print("【Step 3】管理员：查任务详情（DRAFT）")
print("="*60)

r = api("GET", f"/api/report/task/{task_id}", token=admin_token)
if r:
    d = r["data"]
    print(f"  状态: {d['status']}, 科室数: {len(d['scopes'])}")
    for s in d["scopes"]:
        print(f"    科室{s['deptId']}: {s['metricCodes']} fillStatus={s['fillStatus']}")

# ─── Step 4: 发布任务 ─────────────────────────────────────
print("\n" + "="*60)
print("【Step 4】管理员：发布任务")
print("="*60)
api("POST", f"/api/report/task/{task_id}/publish", token=admin_token)

# ─── Step 5: 填报人员A（neuro_head）查看我的任务 ───────────
print("\n" + "="*60)
print("【Step 5】neuro_head（神经科主任）：查看我的任务")
print("="*60)

r = api("GET", "/api/report/task/my-tasks", token=head_token)
if r and r["data"]:
    for t in r["data"]:
        print(f"  taskId={t['taskId']} 名称={t['taskName']} fillStatus={t['fillStatus']} 指标数={t['metricCount']} 超期={t['overdue']}")
else:
    print("  [WARN] 没有返回任务，检查 deptId 是否匹配 scope")

# ─── Step 6: neuro_head 查看填报页 ──────────────────────────
print("\n" + "="*60)
print("【Step 6】neuro_head：查看填报页（指标树+已填内容）")
print("="*60)

r = api("GET", "/api/report/data/sheet", token=head_token, params={"taskId": task_id})
if r:
    d = r["data"]
    print(f"  科室={d['deptName']} fillStatus={d['fillStatus']} inputMode={d['inputMode']}")
    for row in d["rows"]:
        print(f"  指标[{row['metricCode']}] {row['metricName']} result={row['result']}")

# ─── Step 7: neuro_head 填报第1个指标（分子+分母） ──────────
print("\n" + "="*60)
print("【Step 7】neuro_head：填报 10.3.1（分子+分母模式）")
print("="*60)

api("POST", "/api/report/data/save", token=head_token, data={
    "taskId": task_id,
    "metricCode": "10.3.1",
    "inputMode": "NUM_DEN",
    "items": [
        {"itemCode": "num_10_3_1", "itemName": "住院死亡人数", "inputValue": 23},
        {"itemCode": "den_10_3_1", "itemName": "同期出院患者总数", "inputValue": 4561}
    ],
    "remark": "Q2实际统计"
})

# ─── Step 8: neuro_head 填报第2个指标（直填结果） ────────────
print("\n" + "="*60)
print("【Step 8】neuro_head：填报 10.3.2（直填结果模式）")
print("="*60)

api("POST", "/api/report/data/save", token=head_token, data={
    "taskId": task_id,
    "metricCode": "10.3.2",
    "inputMode": "RESULT_ONLY",
    "resultValue": 8.35,
    "remark": "平均住院日科室统计"
})

# ─── Step 9: 再次查看填报页，验证数据已保存 ───────────────────
print("\n" + "="*60)
print("【Step 9】neuro_head：确认已保存数据（重新读取填报页）")
print("="*60)

r = api("GET", "/api/report/data/sheet", token=head_token, params={"taskId": task_id})
if r:
    for row in r["data"]["rows"]:
        items_info = f"  指标项{len(row['items'])}条" if row['items'] else ""
        print(f"  [{row['metricCode']}] result={row['result']}{items_info}")

# ─── Step 10: neuro_head 提交 ────────────────────────────────
print("\n" + "="*60)
print("【Step 10】neuro_head：提交填报")
print("="*60)
api("POST", "/api/report/data/submit", token=head_token, params={"taskId": task_id})

# ─── Step 11: neuro_nurse（普通护士）查看并提交 ───────────────
print("\n" + "="*60)
print("【Step 11】neuro_nurse（普通护士）：查看任务、保存并提交")
print("="*60)

my_tasks = api("GET", "/api/report/task/my-tasks", token=nurse_token)
if my_tasks and my_tasks["data"]:
    print(f"  找到任务数: {len(my_tasks['data'])}")

api("POST", "/api/report/data/save", token=nurse_token, data={
    "taskId": task_id,
    "metricCode": "10.3.2.1",
    "inputMode": "RESULT_ONLY",
    "resultValue": 62.50,
    "remark": "护理统计数据"
})
api("POST", "/api/report/data/submit", token=nurse_token, params={"taskId": task_id})

# ─── Step 12: 管理员查看提交状态 ─────────────────────────────
print("\n" + "="*60)
print("【Step 12】管理员：查看各科室提交状态")
print("="*60)

r = api("GET", f"/api/report/task/{task_id}", token=admin_token)
if r:
    for s in r["data"]["scopes"]:
        print(f"  科室{s['deptId']}: fillStatus={s['fillStatus']} submitTime={s.get('submitTime','')}")

# ─── Step 13: 管理员审核 neuro_head → 通过 ────────────────────
print("\n" + "="*60)
print("【Step 13】管理员：审核 neuro_head → APPROVED")
print("="*60)
api("POST", "/api/report/task/review", token=admin_token, data={
    "taskId": task_id, "deptId": head_dept, "action": "APPROVED", "comment": ""
})

# ─── Step 14: 管理员审核 neuro_nurse → 打回 ──────────────────
print("\n" + "="*60)
print("【Step 14】管理员：审核 neuro_nurse → REJECTED（要求补充）")
print("="*60)
api("POST", "/api/report/task/review", token=admin_token, data={
    "taskId": task_id, "deptId": nurse_dept, "action": "REJECTED",
    "comment": "请提供分子分母原始数据，不接受直接填结果"
})

# ─── Step 15: neuro_nurse 看到打回原因并重新提交 ─────────────
print("\n" + "="*60)
print("【Step 15】neuro_nurse：查看打回原因 → 重新填报 → 再提交")
print("="*60)

r = api("GET", "/api/report/task/my-tasks", token=nurse_token)
if r and r["data"]:
    for t in r["data"]:
        if t["taskId"] == task_id:
            print(f"  fillStatus={t['fillStatus']} 打回原因: {t['reviewComment']}")

api("POST", "/api/report/data/save", token=nurse_token, data={
    "taskId": task_id,
    "metricCode": "10.3.2.1",
    "inputMode": "NUM_DEN",
    "items": [
        {"itemCode": "num_10321", "itemName": "出院占用床日数", "inputValue": 3750},
        {"itemCode": "den_10321", "itemName": "同期出院人数", "inputValue": 60}
    ],
    "remark": "补充分子分母重新提交"
})
api("POST", "/api/report/data/submit", token=nurse_token, params={"taskId": task_id})

# ─── Step 16: 管理员第二次审核 → 通过 ────────────────────────
print("\n" + "="*60)
print("【Step 16】管理员：第二次审核 neuro_nurse → APPROVED")
print("="*60)
api("POST", "/api/report/task/review", token=admin_token, data={
    "taskId": task_id, "deptId": nurse_dept, "action": "APPROVED", "comment": ""
})

# ─── Step 17: 另存为模板 ─────────────────────────────────────
print("\n" + "="*60)
print("【Step 17】管理员：将任务另存为模板")
print("="*60)
r = api("POST", f"/api/report/task/{task_id}/save-as-template",
        token=admin_token, params={"templateName": "神经科Q2标准模板"})
if r:
    print(f"  模板ID = {r['data']}")

# ─── Step 18: 关闭任务 ───────────────────────────────────────
print("\n" + "="*60)
print("【Step 18】管理员：关闭任务")
print("="*60)
api("POST", f"/api/report/task/{task_id}/close", token=admin_token)

# ─── Step 19: 验证 sourceType 筛选 ────────────────────────────
print("\n" + "="*60)
print("【Step 19】验证：/indicator-result/list 的 sourceType 参数")
print("="*60)
r_auto = api("GET", "/api/indicator-result/list", token=admin_token,
             params={"sourceType": "AUTO", "timeDimension": "QUARTER"})
r_manual = api("GET", "/api/indicator-result/list", token=admin_token,
               params={"sourceType": "MANUAL", "timeDimension": "QUARTER"})
if r_auto:  print(f"  AUTO 结果条数: {len(r_auto['data'])}")
if r_manual: print(f"  MANUAL 结果条数: {len(r_manual['data'])}")

# ─── Step 20: neuro_head 验证权限隔离（不能看 nurse 的数据） ──
print("\n" + "="*60)
print("【Step 20】权限验证：neuro_head 只能查自己科室数据")
print("="*60)
r = api("GET", "/api/report/data/sheet", token=head_token,
        params={"taskId": task_id, "deptId": nurse_dept})
if r is None:
    print(f"  {OK} 正确拦截：neuro_head 无法查看 nurse_dept 的数据")
else:
    print(f"  [WARN] 返回了 nurse_dept 数据，需检查权限逻辑")

# ─── 总结 ──────────────────────────────────────────────────
print("\n" + "="*60)
print("【E2E 测试完成】角色-科室-任务关联说明")
print("="*60)
print("""
角色体系:
  ┌────────────────┬──────────┬──────────────────────────────────────────┐
  │ 用户           │ dept_id  │ 如何关联到填报任务                        │
  ├────────────────┼──────────┼──────────────────────────────────────────┤
  │ admin          │ 82       │ dataScope=50，创建任务/发布/审核/看全部    │
  │ neuro_head     │ 1        │ JWT中deptId=1，/my-tasks自动过滤dept_id=1  │
  │ neuro_nurse    │ 108      │ JWT中deptId=108，/my-tasks过滤dept_id=108  │
  └────────────────┴──────────┴──────────────────────────────────────────┘

分配机制（管理员侧）:
  POST /api/report/task 中 scopes[].deptId 指定哪个科室填哪些指标
  → t_report_task_scope 写入 (task_id, dept_id, metric_codes)

填报人员侧发现任务:
  GET /api/report/task/my-tasks
  → 查 t_report_task_scope WHERE dept_id = 当前登录用户.deptId
  → 只返回 PUBLISHED 状态任务
  → 按截止日期紧迫度排序

数据隔离:
  填报数据按 (task_id, dept_id) 隔离存储
  科室只能读写自己的 t_report_data 行
  /api/report/data/sheet 强制使用 UserContext.deptId
""")
