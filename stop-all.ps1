# Content Commerce Platform - 停止所有服务脚本

Write-Host "========================================" -ForegroundColor Red
Write-Host "  停止所有服务..." -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

# 停止 Node.js 进程
Write-Host "🛑 停止 Node.js 进程..." -ForegroundColor Yellow
Get-Process -Name node -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "   ✅ Node.js 进程已停止" -ForegroundColor Green

# 停止 Docker 容器
Write-Host "🛑 停止 Docker 容器..." -ForegroundColor Yellow
$dockerDir = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "apps\backend"
Set-Location $dockerDir
docker-compose down
Write-Host "   ✅ Docker 容器已停止" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✅ 所有服务已停止" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "按任意键关闭此窗口..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
