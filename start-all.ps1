# Content Commerce Platform - 一键启动脚本
# 此脚本将在独立的 PowerShell 窗口中启动所有服务

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Content Commerce Platform 启动中..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 获取脚本所在目录
$rootDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 定义服务路径
$webDir = Join-Path $rootDir "apps\web"
$medusaDir = Join-Path $rootDir "apps\backend\my-medusa-store"
$strapiDir = Join-Path $rootDir "apps\backend\strapi-cms"
$dockerDir = Join-Path $rootDir "apps\backend"

# 检查目录是否存在
$directories = @(
    @{Name="前端"; Path=$webDir},
    @{Name="Medusa"; Path=$medusaDir},
    @{Name="Strapi"; Path=$strapiDir}
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir.Path)) {
        Write-Host "❌ 错误: $($dir.Name) 目录不存在: $($dir.Path)" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ 所有目录检查通过" -ForegroundColor Green
Write-Host ""

# 启动 Docker 服务（PostgreSQL 和 Redis）
Write-Host "🐳 启动 Docker 服务 (PostgreSQL & Redis)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$dockerDir'; docker-compose up" -WindowStyle Normal
Write-Host "   ⏳ 等待 5 秒让数据库服务启动..." -ForegroundColor Gray
Start-Sleep -Seconds 5

# 启动 Medusa 后端
Write-Host "🛍️  启动 Medusa 后端 (端口 9000)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$medusaDir'; Write-Host 'Medusa 后端启动中...' -ForegroundColor Cyan; npm run dev" -WindowStyle Normal
Write-Host "   ⏳ 等待 3 秒..." -ForegroundColor Gray
Start-Sleep -Seconds 3

# 启动 Strapi CMS
Write-Host "📝 启动 Strapi CMS (端口 1337)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$strapiDir'; Write-Host 'Strapi CMS 启动中...' -ForegroundColor Cyan; npm run dev" -WindowStyle Normal
Write-Host "   ⏳ 等待 3 秒..." -ForegroundColor Gray
Start-Sleep -Seconds 3

# 启动前端
Write-Host "🌐 启动前端应用 (端口 3000)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$webDir'; Write-Host '前端应用启动中...' -ForegroundColor Cyan; npm run dev" -WindowStyle Normal

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✅ 所有服务启动完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "服务访问地址：" -ForegroundColor Cyan
Write-Host "  🌐 前端应用:    http://localhost:3000" -ForegroundColor White
Write-Host "  🛍️  Medusa API:  http://localhost:9000" -ForegroundColor White
Write-Host "  📝 Strapi CMS:  http://localhost:1337" -ForegroundColor White
Write-Host "  🗄️  PostgreSQL:  localhost:5432" -ForegroundColor White
Write-Host "  🔴 Redis:       localhost:6379" -ForegroundColor White
Write-Host ""
Write-Host "提示：每个服务都在独立的 PowerShell 窗口中运行" -ForegroundColor Yellow
Write-Host "      关闭窗口即可停止对应服务" -ForegroundColor Yellow
Write-Host ""
Write-Host "按任意键关闭此窗口..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
