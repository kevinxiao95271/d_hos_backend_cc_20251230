# 部署脚本 - PowerShell
$server = "81.71.44.180"
$user = "root"
$password = "Yiguo_9527"
$deployPath = "/opt/indicator-management"
$localPath = "deploy\release"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "医院指标管理系统 - 自动部署脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 使用 plink 和 pscp (PuTTY工具)
# 如果没有安装，使用 SSH.NET 库

Write-Host "[1/5] 检查服务器连接..." -ForegroundColor Yellow

# 方式1: 使用 WinSCP 或 plink
# 方式2: 使用 OpenSSH (需要手动输入密码)

Write-Host "请使用以下命令手动上传文件:" -ForegroundColor Green
Write-Host ""
Write-Host "cd $localPath" -ForegroundColor White
Write-Host "scp -o StrictHostKeyChecking=no *.jar *.sh ${user}@${server}:${deployPath}/" -ForegroundColor White
Write-Host ""
Write-Host "密码: $password" -ForegroundColor Red
Write-Host ""
Write-Host "上传完成后，运行以下命令启动应用:" -ForegroundColor Green
Write-Host "ssh ${user}@${server}" -ForegroundColor White
Write-Host "cd $deployPath && chmod +x *.sh && ./start.sh" -ForegroundColor White
Write-Host ""

# 如果安装了 WinSCP，可以使用自动化
$winscpPath = "C:\Program Files (x86)\WinSCP\WinSCP.com"
if (Test-Path $winscpPath) {
    Write-Host "检测到 WinSCP，正在自动上传..." -ForegroundColor Green

    $scriptContent = @"
open scp://${user}:${password}@${server}
cd $deployPath
lcd $localPath
put *.jar
put *.sh
chmod 755 *.sh
call ./start.sh
exit
"@

    $scriptContent | & $winscpPath /command /log="winscp.log"

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "部署成功！" -ForegroundColor Green
        Write-Host "应用已启动，请查看日志：ssh ${user}@${server} 'tail -f ${deployPath}/logs/application.log'" -ForegroundColor Cyan
    }
} else {
    Write-Host "提示: 安装 WinSCP 可以实现自动化部署" -ForegroundColor Yellow
}
