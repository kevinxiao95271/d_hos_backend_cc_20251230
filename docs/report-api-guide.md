# 手工填报子系统 · API 接口指引

**Base URL**：`http://81.71.44.180:8070/dgear`  
**认证**：所有接口（除登录外）均需在 Header 中携带 `Authorization: Bearer <token>`  
**统一返回格式**：
```json
{ "code": 200, "message": "操作成功", "data": {...}, "timestamp": 1782529481251 }
```

---

## 目录

| 模块 | 接口数 | 说明 |
|------|--------|------|
| [认证](#一认证) | 1 | 登录获取 Token |
| [全局配置](#二全局填报配置管理员) | 2 | 填报方式、审核流程等可配置项 |
| [填报任务（管理员）](#三填报任务管理管理员) | 8 | 创建/发布/关闭/审核/模板 |
| [填报数据（科室）](#四填报数据操作科室) | 5 | 查看填报页/保存/提交/导入/导出 |
| [指标结果查询（已有）](#五指标结果查询扩展参数) | - | 新增 sourceType 参数 |

---

## 一、认证

### POST /auth/login
登录获取 JWT Token

**请求参数（query params）**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| username | string | ✓ | 用户名 |
| password | string | ✓ | 密码 |

**示例**
```bash
POST /auth/login?username=admin&password=Admin@123
```

**返回 data 结构**
```json
{
  "token": "eyJhbGci...",
  "user": {
    "userId": 3,
    "username": "admin",
    "realName": "系统管理员",
    "deptId": 82,
    "roleId": 1,
    "dataScope": 50
  }
}
```

**角色说明（dataScope）**

| dataScope | 角色 | 测试账号 | 权限说明 |
|-----------|------|----------|----------|
| 50 | 超级管理员 | admin / Admin@123 | 创建任务/发布/审核/跨科室查看 |
| 70 | 科室主任 | neuro_head / Dept@123 | 填报本科室任务，只能看自己科室数据 |
| 90 | 普通医生 | neuro_nurse / Nurse@123 | 填报本科室任务，只能看自己科室数据 |

---

## 二、全局填报配置（管理员）

> 系统只有一行全局配置，任务级可覆盖，不覆盖则继承全局。

### GET /api/report/config
获取当前全局填报配置

**返回 data 示例**
```json
{
  "id": 1,
  "inputMode": "NUM_DEN_OR_RESULT",
  "versionStrategy": "VERSIONED",
  "reviewMode": "ADMIN_REVIEW",
  "defaultDeadlineDays": 15,
  "remindBeforeDays": 3,
  "allowResubmit": 1,
  "remark": "默认配置"
}
```

---

### PUT /api/report/config
更新全局填报配置

**请求 Body**
```json
{
  "inputMode": "NUM_DEN_OR_RESULT",
  "versionStrategy": "VERSIONED",
  "reviewMode": "ADMIN_REVIEW",
  "defaultDeadlineDays": 15,
  "remindBeforeDays": 3,
  "allowResubmit": 1,
  "remark": "说明"
}
```

**字段枚举**

| 字段 | 可选值 | 含义 |
|------|--------|------|
| inputMode | `RESULT_ONLY` | 只填结果值 |
| | `NUM_DEN` | 必须填分子+分母（系统自动算结果） |
| | `NUM_DEN_OR_RESULT` | 灵活：可填分子分母，也可直填结果 |
| versionStrategy | `OVERWRITE` | 同名模板直接覆盖 |
| | `VERSIONED` | 保留历史版本，新建版本号+1 |
| reviewMode | `AUTO_APPROVE` | 提交即审核通过 |
| | `ADMIN_REVIEW` | 需管理员手动审核 |

---

## 三、填报任务管理（管理员）

### POST /api/report/task
创建填报任务，同时分配各科室填报指标

**请求 Body**
```json
{
  "name": "2026年Q2手工填报",
  "timeDimension": "QUARTER",
  "startDate": "2026-04-01",
  "endDate": "2026-06-30",
  "deadline": "2026-07-15",
  "inputMode": null,
  "reviewMode": null,
  "remark": "备注",
  "scopes": [
    {
      "deptId": 1,
      "deptName": "神经科",
      "metricCodes": ["10.3.1", "10.3.2"]
    },
    {
      "deptId": 108,
      "deptName": "护理科",
      "metricCodes": ["10.3.2.1"]
    }
  ]
}
```

> `inputMode` / `reviewMode` 留 null 则继承全局配置

**timeDimension 枚举**：`YEAR` / `QUARTER` / `MONTH`

**返回**：创建好的任务对象（status = `DRAFT`）

---

### POST /api/report/task/from-template/{templateId}
从已有模板一键下发任务（直接复用上次的科室-指标分配）

**Path**：`templateId` — 模板 ID

**请求 Body**：与「创建任务」相同，但 `scopes` 可不传（由模板决定）；若传则覆盖模板分配。

---

### GET /api/report/task/page
分页查询任务列表（管理员用）

**Query 参数**

| 参数 | 类型 | 默认 | 说明 |
|------|------|------|------|
| current | int | 1 | 页码 |
| size | int | 10 | 每页条数 |
| name | string | - | 任务名称（模糊匹配） |
| status | string | - | `DRAFT` / `PUBLISHED` / `CLOSED` |
| timeDimension | string | - | `YEAR` / `QUARTER` / `MONTH` |

---

### GET /api/report/task/{taskId}
查询任务详情（含各科室填报状态）

**返回 data 示例**
```json
{
  "id": 1,
  "name": "2026年Q2手工填报",
  "status": "PUBLISHED",
  "inputMode": "NUM_DEN_OR_RESULT",
  "reviewMode": "ADMIN_REVIEW",
  "deadline": "2026-07-15",
  "scopes": [
    {
      "deptId": 1,
      "deptName": "神经科",
      "metricCodes": ["10.3.1", "10.3.2"],
      "fillStatus": "SUBMITTED",
      "submitTime": "2026-06-27T10:30:00",
      "reviewComment": null
    },
    {
      "deptId": 108,
      "deptName": "护理科",
      "metricCodes": ["10.3.2.1"],
      "fillStatus": "REJECTED",
      "reviewComment": "请补充分子分母原始数据"
    }
  ]
}
```

**fillStatus 状态流转**
```
PENDING → FILLING → SUBMITTED → APPROVED
                              ↘ REJECTED → (科室重填) → SUBMITTED
```

---

### POST /api/report/task/{taskId}/publish
发布任务（DRAFT → PUBLISHED），科室方可见任务并开始填报

---

### POST /api/report/task/{taskId}/close
关闭任务（PUBLISHED → CLOSED）

---

### POST /api/report/task/review
审核科室填报（通过 / 打回）

**请求 Body**
```json
{
  "taskId": 1,
  "deptId": 108,
  "action": "REJECTED",
  "comment": "请补充分子分母原始数据"
}
```

> `action`：`APPROVED`（通过）或 `REJECTED`（打回），打回时 `comment` 必填

---

### POST /api/report/task/{taskId}/save-as-template
将当前任务的科室-指标分配方案另存为模板

**Query**：`templateName=神经科Q2标准模板`

**返回**：新模板 ID（Long）

> 若 `versionStrategy=VERSIONED`，同名旧模板版本号保留，新建 version+1；  
> 若 `versionStrategy=OVERWRITE`，同名旧模板直接删除重建。

---

### GET /api/report/task/template/{templateId}/scopes
查看模板中的科室分配明细（创建下次任务时预览用）

**返回 data**：科室分配列表（deptId、deptName、metricCodes）

---

## 四、填报数据操作（科室）

> **权限规则**：deptId 参数不传时自动取当前登录科室；  
> dataScope ≠ 50 的用户传其他科室 ID 返回 500「无权访问」。

---

### GET /api/report/task/my-tasks
填报人员查看本科室所有待办/进行中任务（**核心入口**）

**无需传参**，自动按登录用户的 deptId 过滤

**返回 data 示例**
```json
[
  {
    "taskId": 1,
    "taskName": "2026年Q2手工填报",
    "timeDimension": "QUARTER",
    "startDate": "2026-04-01",
    "endDate": "2026-06-30",
    "deadline": "2026-07-15",
    "taskStatus": "PUBLISHED",
    "fillStatus": "REJECTED",
    "reviewComment": "请补充分子分母原始数据",
    "inputMode": "NUM_DEN_OR_RESULT",
    "reviewMode": "ADMIN_REVIEW",
    "metricCodes": ["10.3.2.1"],
    "metricCount": 1,
    "submitTime": "2026-06-27T10:30:00",
    "overdue": false
  }
]
```

> 按 `overdue`（是否超期）DESC、`deadline` ASC 排序，超期任务排在最前

---

### GET /api/report/data/sheet
查看填报页面数据（指标树 + 已填内容），打开填报页时调用

**Query 参数**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| taskId | Long | ✓ | 任务 ID |
| deptId | Long | - | 科室 ID（不传取登录科室，超管可指定） |

**返回 data 示例**
```json
{
  "taskId": 1,
  "deptId": 1,
  "deptName": "神经科",
  "fillStatus": "FILLING",
  "inputMode": "NUM_DEN_OR_RESULT",
  "rows": [
    {
      "metricCode": "10.3.1",
      "metricName": "住院死亡率（出院患者）",
      "formula": "num_10_3_1/den_10_3_1*100",
      "inputType": "MANUAL",
      "effectiveInputMode": "NUM_DEN",
      "items": [
        { "itemCode": "num_10_3_1", "itemName": "住院死亡人数", "role": null, "inputValue": 23 },
        { "itemCode": "den_10_3_1", "itemName": "同期出院患者总数", "role": null, "inputValue": 4561 }
      ],
      "numerator": null,
      "denominator": null,
      "result": "0.5043"
    },
    {
      "metricCode": "10.3.2",
      "metricName": "平均住院日",
      "items": [],
      "result": "8.35"
    }
  ]
}
```

> `result` 格式：保留 4 位小数、去尾零（如 `100.1000 → 100.1`，`8.3500 → 8.35`）

---

### POST /api/report/data/save
保存某个指标的填报数据（草稿，可反复调用，幂等覆盖）

**请求 Body — 模式 A：填分子+分母（NUM_DEN）**
```json
{
  "taskId": 1,
  "metricCode": "10.3.1",
  "inputMode": "NUM_DEN",
  "items": [
    { "itemCode": "num_10_3_1", "itemName": "住院死亡人数", "inputValue": 23 },
    { "itemCode": "den_10_3_1", "itemName": "同期出院患者总数", "inputValue": 4561 }
  ],
  "remark": "Q2实际统计"
}
```

> 若指标有表达式，系统自动用 Aviator 计算并写入结果行；无法计算则只保存指标项，结果留空

**请求 Body — 模式 B：直填结果（RESULT_ONLY）**
```json
{
  "taskId": 1,
  "metricCode": "10.3.2",
  "inputMode": "RESULT_ONLY",
  "resultValue": 8.35,
  "remark": "科室统计汇总"
}
```

**请求 Body — 模式 C：灵活模式（NUM_DEN_OR_RESULT，直填结果分支）**
```json
{
  "taskId": 1,
  "metricCode": "10.3.2.1",
  "inputMode": "NUM_DEN_OR_RESULT",
  "resultValue": 62.50
}
```

> - 每次调用以 `(task_id, dept_id, metric_code)` 为原子单位，先删旧数据再写入  
> - 保存后科室填报状态从 `PENDING` 升为 `FILLING`  
> - `APPROVED` 状态下拒绝保存

---

### POST /api/report/data/submit
提交填报（整个任务维度一次性提交，触发审核流程）

**Query 参数**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| taskId | Long | ✓ | 任务 ID |
| deptId | Long | - | 科室 ID（不传取登录科室） |

> 提交后状态变为 `SUBMITTED`，若审核被打回（`REJECTED`），科室可重新保存并再次提交

---

### POST /api/report/data/import
Excel 批量导入填报数据（科室上传已填写的模板文件）

**Query**：`taskId=1`（deptId 可选）

**Content-Type**：`multipart/form-data`（直接上传 xlsx 文件流）

**Excel 列格式**（与导出模板一致）

| 列 | 内容 |
|----|------|
| A | 指标编码 |
| B | 监测指标名称 |
| C | 计算方法（表达式） |
| D | 指标项编码 |
| E | 指标项名称 |
| **F** | **填报值**（用户填入） |
| G | 备注 |

> 结果行：D列为空、E列为`【填报结果】`，F列填结果值

---

### GET /api/report/task/export-template
下载空白填报模板 Excel（科室用于线下填写后导入）

**Query 参数**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| taskId | Long | ✓ | 任务 ID |
| deptId | Long | ✓ | 科室 ID |

**返回**：xlsx 文件流，文件名格式：`{任务名}_{科室名}.xlsx`

---

### GET /api/report/data/export-approved
导出已审核通过的填报结果汇总（管理员用）

**Query**：`taskId=1`

**返回**：xlsx 文件流，包含所有 APPROVED 科室的数据，文件名：`{任务名}_已审核.xlsx`

---

## 五、指标结果查询（扩展参数）

在已有接口基础上新增 `sourceType` 参数，支持前端 Tab 按来源筛选。

### GET /api/indicator-result/list

| 新增参数 | 类型 | 说明 |
|----------|------|------|
| sourceType | string | `AUTO`=只看自动采集指标结果 / `MANUAL`=只看手工填报指标结果 / 不传=全部 |

**示例**
```
GET /api/indicator-result/list?sourceType=MANUAL&timeDimension=QUARTER
GET /api/indicator-result/list?sourceType=AUTO&timeDimension=YEAR
```

### GET /api/indicator-result/latest

同上，支持 `sourceType` 参数。

---

## 六、完整流程示意

```
管理员                                     科室填报人员
  │                                              │
  ├─ GET /api/report/config （查看配置）          │
  ├─ PUT /api/report/config （调整填报方式/审核）  │
  │                                              │
  ├─ POST /api/report/task （创建+分配）          │
  ├─ POST /api/report/task/{id}/publish          │
  │                                              │── GET /api/report/task/my-tasks
  │                                              │       （看待办任务列表）
  │                                              │
  │                                              │── GET /api/report/data/sheet
  │                                              │       （打开填报页，看指标树）
  │                                              │
  │                                              │── GET /api/report/task/export-template
  │                                              │       （可选：下载Excel离线填写）
  │                                              │
  │                                              │── POST /api/report/data/save ×N
  │                                              │       （逐指标保存草稿）
  │                                              │
  │                                              │── POST /api/report/data/import
  │                                              │       （可选：导入Excel）
  │                                              │
  │                                              │── POST /api/report/data/submit
  │                                              │       （整体提交）
  │                                              │
  ├─ GET /api/report/task/{id} （查审核队列）     │
  │                                              │
  ├─ POST /api/report/task/review               │
  │     action=APPROVED → 通过                  │
  │     action=REJECTED → 打回（附原因）  ──────→ │── GET /api/report/task/my-tasks
  │                                              │       （看打回原因）
  │                                              │── POST /api/report/data/save（重填）
  │                                              │── POST /api/report/data/submit（再提交）
  │                                              │
  ├─ POST /api/report/task/review（再次通过）     │
  ├─ POST /api/report/task/{id}/save-as-template │
  ├─ GET  /api/report/data/export-approved       │
  └─ POST /api/report/task/{id}/close            │
```

---

## 七、错误码说明

| code | 含义 |
|------|------|
| 200 | 成功 |
| 400 | 参数校验失败 |
| 4001 | 指标项编码格式非法（只允许字母开头+字母数字） |
| 500 | 业务异常（message 字段有具体原因） |
| 401 | Token 未提供或已过期 |
