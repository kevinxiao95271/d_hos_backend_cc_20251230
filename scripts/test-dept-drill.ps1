# 测试科室下钻API - 肺炎（住院、成人）次均费用

$url = "http://localhost:8080/dgear/api/indicator-result/dept-drill-down"
$params = @{
    metricCode = "肺炎（住院、成人）次均费用"
    timeDimension = "YEAR"
    startDate = "2020-01-01"
    endDate = "2020-12-31"
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "科室下钻API测试 - 肺炎(住院、成人)次均费用" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "请求参数:" -ForegroundColor Yellow
$params | Format-Table -AutoSize

Write-Host "`n发送请求..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri $url -Method POST -Body $params -ContentType "application/x-www-form-urlencoded; charset=UTF-8"

    Write-Host "`n响应结果:" -ForegroundColor Green
    Write-Host "  返回码: $($response.code)"
    Write-Host "  消息: $($response.message)"
    Write-Host "  科室数: $($response.data.Count)"

    if ($response.data.Count -gt 0) {
        Write-Host "`n前10个科室数据:" -ForegroundColor Yellow
        $response.data | Select-Object -First 10 | ForEach-Object {
            Write-Host "`n科室: $($_.deptName) ($($_.deptCode))" -ForegroundColor Cyan
            Write-Host "  结果值: $($_.resultValue) 元"

            # 解析JSON查看明细
            $json = $_.resultJson | ConvertFrom-Json
            Write-Host "  指标项明细:"
            $json.item_values | Format-List
        }
    }

    Write-Host "`n所有科室汇总:" -ForegroundColor Yellow
    $response.data | Select-Object deptName, resultValue | Format-Table -AutoSize

} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
