@echo off
echo ========================================
echo 医疗指标管理系统 API 自动测试
echo ========================================
echo.

REM 设置基础URL
set BASE_URL=http://localhost:8080/dgear

echo [测试1] 健康检查 - 访问Swagger文档
curl -s -o nul -w "HTTP状态码: %%{http_code}\n" %BASE_URL%/swagger-ui.html
echo.

echo [测试2] 查询指标项列表
curl -s -X GET "%BASE_URL%/api/indicator-item/list" -H "accept: application/json"
echo.
echo.

echo [测试3] 查询指标树形结构
curl -s -X GET "%BASE_URL%/api/indicator/tree" -H "accept: application/json"
echo.
echo.

echo [测试4] 执行指标项查询 - a0050（肺炎病例数）
curl -s -X POST "%BASE_URL%/api/indicator-item/a0050/execute?startDate=2025-01-01&endDate=2025-01-31" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"
echo.
echo.

echo [测试5] 执行指标项查询 - a0052（总床日数）
curl -s -X POST "%BASE_URL%/api/indicator-item/a0052/execute?startDate=2025-01-01&endDate=2025-01-31" -H "accept: application/json" -H "Content-Type: application/json" -d "{}"
echo.
echo.

echo [测试6] 执行指标计算 - 10.3.1（肺炎病例数）
curl -s -X POST "%BASE_URL%/api/indicator-result/calculate?metricCode=10.3.1&timeDimension=MONTH&startDate=2025-01-01&endDate=2025-01-31" -H "accept: application/json"
echo.
echo.

echo [测试7] 执行指标计算 - 10.3.2（平均住院日，带表达式）
curl -s -X POST "%BASE_URL%/api/indicator-result/calculate?metricCode=10.3.2&timeDimension=MONTH&startDate=2025-01-01&endDate=2025-01-31" -H "accept: application/json"
echo.
echo.

echo [测试8] 查询最新计算结果
curl -s -X GET "%BASE_URL%/api/indicator-result/latest?timeDimension=MONTH" -H "accept: application/json"
echo.
echo.

echo [测试9] 批量计算指标（2025年1-3月）
curl -s -X POST "%BASE_URL%/api/indicator-result/batch-calculate?timeDimension=MONTH&startDate=2025-01-01&endDate=2025-03-31" -H "accept: application/json" -H "Content-Type: application/json" -d "[]"
echo.
echo.

echo ========================================
echo 测试完成！
echo ========================================
pause
