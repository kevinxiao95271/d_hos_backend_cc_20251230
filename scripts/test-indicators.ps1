# 指标计算API测试脚本 - PowerShell版本
# 测试2023年度指标计算

$BaseUrl = "http://localhost:8080/dgear/api/indicator-result/calculate"
$Year = "2023"
$StartDate = "2023-01-01"
$EndDate = "2023-12-31"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "医疗指标计算API测试 - ${Year}年度" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# 测试函数
function Test-Indicator {
    param (
        [string]$IndicatorName,
        [string]$DisplayName
    )

    Write-Host "【测试】$DisplayName" -ForegroundColor Yellow

    # URL编码
    $EncodedName = [System.Web.HttpUtility]::UrlEncode($IndicatorName)

    # 调用API
    $Url = "${BaseUrl}?metricCode=${EncodedName}&timeDimension=YEAR&startDate=${StartDate}&endDate=${EndDate}"

    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Post -ContentType "application/json"

        if ($Response.code -eq 200) {
            Write-Host "  ✅ 成功: $($Response.message)" -ForegroundColor Green
            Write-Host "  📊 结果: $($Response.data.resultValue)"
            Write-Host "  📌 状态: $($Response.data.calculationStatus)"

            # 解析详细信息
            if ($Response.data.resultJson) {
                $ResultJson = $Response.data.resultJson | ConvertFrom-Json
                Write-Host "  🔍 表达式: $($ResultJson.expression)"
                Write-Host "  📝 指标项值: $($ResultJson.item_values | ConvertTo-Json -Compress)"
            }
        } else {
            Write-Host "  ❌ 失败: $($Response.message)" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ❌ 错误: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

# 加载System.Web程序集用于URL编码
Add-Type -AssemblyName System.Web

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "1. 手术相关指标测试" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Test-Indicator "手术患者并发症发生率" "手术患者并发症发生率"
Test-Indicator "I类切口手术部位感染率" "I类切口手术部位感染率"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "2. 急性心肌梗死指标测试" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Test-Indicator "急性心肌梗死病种例数" "急性心肌梗死病种例数"
Test-Indicator "急性心肌梗死平均住院日" "急性心肌梗死平均住院日"
Test-Indicator "急性心肌梗死次均费用" "急性心肌梗死次均费用"
Test-Indicator "急性心肌梗死病死率" "急性心肌梗死病死率"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "3. 心力衰竭指标测试" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Test-Indicator "心力衰竭病种例数" "心力衰竭病种例数"
Test-Indicator "心力衰竭平均住院日" "心力衰竭平均住院日"
Test-Indicator "心力衰竭次均费用" "心力衰竭次均费用"
Test-Indicator "心力衰竭病死率" "心力衰竭病死率"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "4. 肺炎（住院、成人）指标测试" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Test-Indicator "肺炎（住院、成人）病种例数" "肺炎（住院、成人）病种例数"
Test-Indicator "肺炎（住院、成人）平均住院日" "肺炎（住院、成人）平均住院日"
Test-Indicator "肺炎（住院、成人）次均费用" "肺炎（住院、成人）次均费用"
Test-Indicator "肺炎（住院、成人）病死率" "肺炎（住院、成人）病死率"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "5. 肺炎（住院、儿童）指标测试" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Test-Indicator "肺炎（住院、儿童）病种例数" "肺炎（住院、儿童）病种例数"
Test-Indicator "肺炎（住院、儿童）平均住院日" "肺炎（住院、儿童）平均住院日"
Test-Indicator "肺炎（住院、儿童）次均费用" "肺炎（住院、儿童）次均费用"
Test-Indicator "肺炎（住院、儿童）病死率" "肺炎（住院、儿童）病死率"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "测试完成" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
