# ============================================================
# 手工填报子系统 · E2E 自测脚本（PowerShell）
# 分角色覆盖完整流程：
#   角色A（管理员）：配置 → 创建任务 → 发布 → 审核
#   角色B（感染科填报员）：查看任务 → 保存草稿 → 提交
#   角色C（心内科填报员）：查看任务 → 导入Excel → 提交
# ============================================================

$BASE = "http://localhost:8070/dgear"
$HEADERS = @{ "Content-Type" = "application/json" }

function Invoke-API {
    param($Method, $Path, $Body = $null, $Token = $null)
    $h = @{ "Content-Type" = "application/json" }
    if ($Token) { $h["Authorization"] = "Bearer $Token" }
    $uri = "$BASE$Path"
    try {
        if ($Body) {
            $r = Invoke-RestMethod -Method $Method -Uri $uri -Headers $h -Body ($Body | ConvertTo-Json -Depth 10)
        } else {
            $r = Invoke-RestMethod -Method $Method -Uri $uri -Headers $h
        }
        Write-Host "[OK] $Method $Path" -ForegroundColor Green
        return $r
    } catch {
        Write-Host "[FAIL] $Method $Path => $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

Write-Host "`n===== 【步骤0】获取 Token（三个角色） =====" -ForegroundColor Cyan

$adminLogin = Invoke-API "POST" "/api/auth/login" @{ username="admin_test"; password="Test1234!" }
$infectLogin = Invoke-API "POST" "/api/auth/login" @{ username="filler_infect"; password="Test1234!" }
$cardLogin   = Invoke-API "POST" "/api/auth/login" @{ username="filler_card"; password="Test1234!" }

$adminToken  = $adminLogin.data.token
$infectToken = $infectLogin.data.token
$cardToken   = $cardLogin.data.token

Write-Host "  Admin Token: $($adminToken.Substring(0,20))..."
Write-Host "  Infect Token: $($infectToken.Substring(0,20))..."
Write-Host "  Card Token: $($cardToken.Substring(0,20))..."

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤1】管理员：查看并更新全局填报配置 =====" -ForegroundColor Cyan

$config = Invoke-API "GET" "/api/report/config" -Token $adminToken
Write-Host "  当前配置: inputMode=$($config.data.inputMode), reviewMode=$($config.data.reviewMode)"

# 改为允许"分子+分母或直填结果"，管理员人工审核
$configUpdate = Invoke-API "PUT" "/api/report/config" @{
    inputMode           = "NUM_DEN_OR_RESULT"
    versionStrategy     = "VERSIONED"
    reviewMode          = "ADMIN_REVIEW"
    defaultDeadlineDays = 15
    remindBeforeDays    = 3
    allowResubmit       = 1
    remark              = "E2E测试配置"
} -Token $adminToken

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤2】管理员：查询可用的MANUAL指标 =====" -ForegroundColor Cyan

$indicatorList = Invoke-API "GET" "/api/indicator/list?status=1&pageSize=50" -Token $adminToken
$manualCodes = @()
if ($indicatorList.data.records) {
    $manualCodes = ($indicatorList.data.records | Where-Object { $_.inputType -eq "MANUAL" } | Select-Object -First 3).metricCode
}

# 如果没有MANUAL指标，使用占位编码（测试环境需先执行 testdata.sql）
if ($manualCodes.Count -eq 0) {
    Write-Host "  [警告] 未找到MANUAL类型指标，使用占位编码进行后续流程测试" -ForegroundColor Yellow
    $manualCodes = @("MANUAL_TEST_01", "MANUAL_TEST_02", "MANUAL_TEST_03")
}
Write-Host "  MANUAL指标编码: $($manualCodes -join ', ')"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤3】管理员：创建填报任务（分配给2个科室） =====" -ForegroundColor Cyan

$createTask = Invoke-API "POST" "/api/report/task" @{
    name            = "2026年Q2手工填报任务-E2E测试"
    timeDimension   = "QUARTER"
    startDate       = "2026-04-01"
    endDate         = "2026-06-30"
    deadline        = "2026-07-15"
    inputMode       = $null   # 继承全局配置
    reviewMode      = $null   # 继承全局配置
    remark          = "端到端自测任务"
    scopes = @(
        @{
            deptId     = 101
            deptName   = "感染科"
            metricCodes = @($manualCodes[0], $manualCodes[1])
        },
        @{
            deptId     = 102
            deptName   = "心内科"
            metricCodes = @($manualCodes[2])
        }
    )
} -Token $adminToken

$taskId = $createTask.data.id
Write-Host "  创建任务ID: $taskId"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤4】管理员：查看任务详情（草稿状态） =====" -ForegroundColor Cyan

$detail = Invoke-API "GET" "/api/report/task/$taskId" -Token $adminToken
Write-Host "  状态: $($detail.data.status)"
Write-Host "  科室数: $($detail.data.scopes.Count)"
$detail.data.scopes | ForEach-Object {
    Write-Host "    - $($_.deptName): 指标$($_.metricCodes.Count)个, 填报状态=$($_.fillStatus)"
}

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤5】管理员：发布任务 =====" -ForegroundColor Cyan

Invoke-API "POST" "/api/report/task/$taskId/publish" -Token $adminToken | Out-Null
Write-Host "  任务已发布"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤6】感染科填报员：查看我的任务列表 =====" -ForegroundColor Cyan

$myTasks = Invoke-API "GET" "/api/report/task/my-tasks" -Token $infectToken
Write-Host "  我的任务数量: $($myTasks.data.Count)"
$myTasks.data | ForEach-Object {
    Write-Host "    任务[$($_.taskId)] $($_.taskName) | 截止$($_.deadline) | 填报状态=$($_.fillStatus) | 超期=$($_.overdue)"
}

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤7】感染科填报员：查看填报页面（获取指标树） =====" -ForegroundColor Cyan

$fillSheet = Invoke-API "GET" "/api/report/data/sheet?taskId=$taskId" -Token $infectToken
Write-Host "  科室: $($fillSheet.data.deptName), 填报方式: $($fillSheet.data.inputMode)"
Write-Host "  指标行数: $($fillSheet.data.rows.Count)"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤8】感染科填报员：保存第1个指标（分子+分母模式） =====" -ForegroundColor Cyan

$saveResult1 = Invoke-API "POST" "/api/report/data/save" @{
    taskId     = $taskId
    metricCode = $manualCodes[0]
    inputMode  = "NUM_DEN"
    items = @(
        @{ itemCode = "item_numerator";   itemName = "分子（感染率相关）"; inputValue = 45 }
        @{ itemCode = "item_denominator"; itemName = "分母（总例数）";     inputValue = 1200 }
    )
    remark = "Q2实际数据"
} -Token $infectToken

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤9】感染科填报员：保存第2个指标（直填结果模式） =====" -ForegroundColor Cyan

$saveResult2 = Invoke-API "POST" "/api/report/data/save" @{
    taskId      = $taskId
    metricCode  = $manualCodes[1]
    inputMode   = "RESULT_ONLY"
    resultValue = 92.35
    remark      = "根据科室统计汇总"
} -Token $infectToken

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤10】感染科填报员：确认页面数据已保存（重新读取） =====" -ForegroundColor Cyan

$fillSheet2 = Invoke-API "GET" "/api/report/data/sheet?taskId=$taskId" -Token $infectToken
$fillSheet2.data.rows | ForEach-Object {
    Write-Host "  指标[$($_.metricCode)]: result=$($_.result), 指标项数=$($_.items.Count)"
}

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤11】感染科填报员：提交填报 =====" -ForegroundColor Cyan

Invoke-API "POST" "/api/report/data/submit?taskId=$taskId" -Token $infectToken | Out-Null
Write-Host "  感染科已提交"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤12】心内科填报员：查看我的任务并保存 =====" -ForegroundColor Cyan

$myTasksCard = Invoke-API "GET" "/api/report/task/my-tasks" -Token $cardToken
Write-Host "  心内科任务数: $($myTasksCard.data.Count)"

Invoke-API "POST" "/api/report/data/save" @{
    taskId      = $taskId
    metricCode  = $manualCodes[2]
    inputMode   = "RESULT_ONLY"
    resultValue = 78.54
    remark      = "心内科Q2填报"
} -Token $cardToken | Out-Null

Invoke-API "POST" "/api/report/data/submit?taskId=$taskId" -Token $cardToken | Out-Null
Write-Host "  心内科已提交"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤13】管理员：查看任务详情（确认两个科室均已提交） =====" -ForegroundColor Cyan

$detail2 = Invoke-API "GET" "/api/report/task/$taskId" -Token $adminToken
$detail2.data.scopes | ForEach-Object {
    Write-Host "  $($_.deptName): 状态=$($_.fillStatus), 提交时间=$($_.submitTime)"
}

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤14】管理员：审核感染科（通过） =====" -ForegroundColor Cyan

Invoke-API "POST" "/api/report/task/review" @{
    taskId = $taskId
    deptId = 101
    action = "APPROVED"
    comment = ""
} -Token $adminToken | Out-Null
Write-Host "  感染科：已通过"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤15】管理员：审核心内科（打回，要求补充分子分母） =====" -ForegroundColor Cyan

Invoke-API "POST" "/api/report/task/review" @{
    taskId  = $taskId
    deptId  = 102
    action  = "REJECTED"
    comment = "请补充分子分母原始数据，不接受直接填报结果"
} -Token $adminToken | Out-Null
Write-Host "  心内科：已打回"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤16】心内科填报员：查看被打回任务（确认能看到打回原因） =====" -ForegroundColor Cyan

$myTasksCard2 = Invoke-API "GET" "/api/report/task/my-tasks" -Token $cardToken
$myTasksCard2.data | ForEach-Object {
    Write-Host "  [$($_.taskId)] 状态=$($_.fillStatus), 打回原因=$($_.reviewComment)"
}

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤17】心内科填报员：重新填报（分子+分母）并提交 =====" -ForegroundColor Cyan

Invoke-API "POST" "/api/report/data/save" @{
    taskId     = $taskId
    metricCode = $manualCodes[2]
    inputMode  = "NUM_DEN"
    items = @(
        @{ itemCode = "num_card"; itemName = "心脏相关分子"; inputValue = 180 }
        @{ itemCode = "den_card"; itemName = "总例数";       inputValue = 229 }
    )
    remark = "补充分子分母后重新提交"
} -Token $cardToken | Out-Null

Invoke-API "POST" "/api/report/data/submit?taskId=$taskId" -Token $cardToken | Out-Null
Write-Host "  心内科重新提交完成"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤18】管理员：审核心内科（第二次，通过） =====" -ForegroundColor Cyan

Invoke-API "POST" "/api/report/task/review" @{
    taskId  = $taskId
    deptId  = 102
    action  = "APPROVED"
    comment = ""
} -Token $adminToken | Out-Null
Write-Host "  心内科：第二次审核通过"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤19】管理员：将任务另存为模板 =====" -ForegroundColor Cyan

$tplResult = Invoke-API "POST" "/api/report/task/$taskId/save-as-template?templateName=Q2标准手工填报模板" -Token $adminToken
Write-Host "  模板ID: $($tplResult.data)"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【步骤20】验证：指标结果查询支持 sourceType 筛选 =====" -ForegroundColor Cyan

$autoResults  = Invoke-API "GET" "/api/indicator-result/list?sourceType=AUTO&timeDimension=QUARTER"  -Token $adminToken
$manualResults = Invoke-API "GET" "/api/indicator-result/list?sourceType=MANUAL&timeDimension=QUARTER" -Token $adminToken
Write-Host "  AUTO指标结果数: $($autoResults.data.Count)"
Write-Host "  MANUAL指标结果数: $($manualResults.data.Count)"

# ─────────────────────────────────────────────────────────────
Write-Host "`n===== 【完成】全流程 E2E 测试结束 =====" -ForegroundColor Green
Write-Host @"

角色-任务关联总结：
  ┌────────────────┬──────────┬──────────────────────────────────────────────────┐
  │ 用户           │ 科室     │ 如何关联到填报任务                               │
  ├────────────────┼──────────┼──────────────────────────────────────────────────┤
  │ admin_test     │ 质控管理 │ dataScope=50，可创建/发布/审核任何任务           │
  │ filler_infect  │ 感染科   │ JWT携带deptId=101，/my-tasks自动过滤该科室任务   │
  │ filler_card    │ 心内科   │ JWT携带deptId=102，/my-tasks自动过滤该科室任务   │
  └────────────────┴──────────┴──────────────────────────────────────────────────┘

分配机制：
  管理员创建任务时，在 scopes[] 里指定 deptId+metricCodes
  → t_report_task_scope 记录一条 (task_id, dept_id, metric_codes)
  → 该科室所有用户登录后调 /my-tasks 即可看到（以 UserContext.deptId 过滤）
  → 数据隔离：各科室只能读写自己的填报数据
"@
