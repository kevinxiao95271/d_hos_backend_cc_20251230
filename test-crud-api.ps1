# 指标项和指标CRUD接口测试脚本
$baseUrl = "http://localhost:8080/dgear"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "开始测试指标项和指标CRUD接口" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 测试1: 新增指标项 (POST)
Write-Host "测试1: 新增指标项 (POST /api/indicator-item)" -ForegroundColor Yellow
$newItem = @{
    itemCode = "test_item_001"
    itemName = "测试指标项001"
    itemType = "COLLECTED"
    dataSource = "D_MR"
    querySql = "SELECT COUNT(*) AS result_value FROM d_mr WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN #{startDate} AND #{endDate}"
    unit = "人"
    status = 1
    sortOrder = 999
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator-item" -Method Post -Body $newItem -ContentType "application/json"
Write-Host "响应: $($response | ConvertTo-Json -Depth 3)" -ForegroundColor Green
$itemId = $response.data.id
Write-Host "新增成功，ID: $itemId`n" -ForegroundColor Green

# 测试2: 查询指标项详情 (GET)
Write-Host "测试2: 查询指标项详情 (GET /api/indicator-item/$itemId)" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator-item/$itemId" -Method Get
Write-Host "查询成功: $($response.data.itemName)`n" -ForegroundColor Green

# 测试3: 更新指标项 (PUT)
Write-Host "测试3: 更新指标项 (PUT /api/indicator-item/$itemId)" -ForegroundColor Yellow
$updateItem = @{
    itemCode = "test_item_001"
    itemName = "测试指标项001-已更新"
    itemType = "COLLECTED"
    dataSource = "D_MR"
    querySql = "SELECT COUNT(*) AS result_value FROM d_mr WHERE STR_TO_DATE(B15, '%Y/%m/%d') BETWEEN #{startDate} AND #{endDate}"
    unit = "人"
    status = 1
    sortOrder = 999
    remark = "这是更新后的备注"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator-item/$itemId" -Method Put -Body $updateItem -ContentType "application/json"
Write-Host "更新成功: $($response.data.itemName)`n" -ForegroundColor Green

# 测试4: 分页查询指标项 (GET)
Write-Host "测试4: 分页查询指标项 (GET /api/indicator-item/page)" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator-item/page?current=1&size=5" -Method Get
Write-Host "查询成功，共 $($response.data.total) 条记录`n" -ForegroundColor Green

# 测试5: 新增指标 (POST)
Write-Host "测试5: 新增指标 (POST /api/indicator)" -ForegroundColor Yellow
$newIndicator = @{
    metricCode = "99.1"
    metricName = "测试指标001"
    parentCode = "99"
    indicatorLevel = 2
    isLeaf = 1
    metricType = "QUANTITATIVE"
    calculationType = "ITEM"
    relatedItems = '["test_item_001"]'
    unit = "人"
    supportDeptDrill = 0
    status = 1
    sortOrder = 999
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator" -Method Post -Body $newIndicator -ContentType "application/json"
Write-Host "响应: $($response | ConvertTo-Json -Depth 3)" -ForegroundColor Green
$indicatorId = $response.data.id
Write-Host "新增成功，ID: $indicatorId`n" -ForegroundColor Green

# 测试6: 查询指标详情 (GET)
Write-Host "测试6: 查询指标详情 (GET /api/indicator/$indicatorId)" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator/$indicatorId" -Method Get
Write-Host "查询成功: $($response.data.metricName)`n" -ForegroundColor Green

# 测试7: 更新指标 (PUT)
Write-Host "测试7: 更新指标 (PUT /api/indicator/$indicatorId)" -ForegroundColor Yellow
$updateIndicator = @{
    metricCode = "99.1"
    metricName = "测试指标001-已更新"
    parentCode = "99"
    indicatorLevel = 2
    isLeaf = 1
    metricType = "QUANTITATIVE"
    calculationType = "ITEM"
    relatedItems = '["test_item_001"]'
    unit = "人"
    supportDeptDrill = 0
    status = 1
    sortOrder = 999
    remark = "这是更新后的指标备注"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator/$indicatorId" -Method Put -Body $updateIndicator -ContentType "application/json"
Write-Host "更新成功: $($response.data.metricName)`n" -ForegroundColor Green

# 测试8: 查询指标树形结构 (GET)
Write-Host "测试8: 查询指标树形结构 (GET /api/indicator/tree)" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator/tree" -Method Get
Write-Host "查询成功，共 $($response.data.Count) 个顶级节点`n" -ForegroundColor Green

# 测试9: 分页查询指标 (GET)
Write-Host "测试9: 分页查询指标 (GET /api/indicator/page)" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator/page?current=1&size=5" -Method Get
Write-Host "查询成功，共 $($response.data.total) 条记录`n" -ForegroundColor Green

# 测试10: 删除指标 (DELETE)
Write-Host "测试10: 删除指标 (DELETE /api/indicator/$indicatorId)" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator/$indicatorId" -Method Delete
Write-Host "删除成功`n" -ForegroundColor Green

# 测试11: 删除指标项 (DELETE)
Write-Host "测试11: 删除指标项 (DELETE /api/indicator-item/$itemId)" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$baseUrl/api/indicator-item/$itemId" -Method Delete
Write-Host "删除成功`n" -ForegroundColor Green

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "所有测试完成！" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
