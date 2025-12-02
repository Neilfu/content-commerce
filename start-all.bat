@echo off
REM Content Commerce Platform - 一键启动脚本 (批处理版本)
REM 此脚本将在独立的命令提示符窗口中启动所有服务

echo ========================================
echo   Content Commerce Platform 启动中...
echo ========================================
echo.

REM 获取脚本所在目录
set ROOT_DIR=%~dp0

REM 启动 Docker 服务
echo [1/4] 启动 Docker 服务 (PostgreSQL ^& Redis)...
start "Docker Services" cmd /k "cd /d %ROOT_DIR%apps\backend && docker-compose up"
timeout /t 5 /nobreak >nul

REM 启动 Medusa 后端
echo [2/4] 启动 Medusa 后端 (端口 9000)...
start "Medusa Backend" cmd /k "cd /d %ROOT_DIR%apps\backend\my-medusa-store && npm run dev"
timeout /t 3 /nobreak >nul

REM 启动 Strapi CMS
echo [3/4] 启动 Strapi CMS (端口 1337)...
start "Strapi CMS" cmd /k "cd /d %ROOT_DIR%apps\backend\strapi-cms && npm run dev"
timeout /t 3 /nobreak >nul

REM 启动前端
echo [4/4] 启动前端应用 (端口 3000)...
start "Frontend App" cmd /k "cd /d %ROOT_DIR%apps\web && npm run dev"

echo.
echo ========================================
echo   所有服务启动完成！
echo ========================================
echo.
echo 服务访问地址：
echo   前端应用:    http://localhost:3000
echo   Medusa API:  http://localhost:9000
echo   Strapi CMS:  http://localhost:1337
echo   PostgreSQL:  localhost:5432
echo   Redis:       localhost:6379
echo.
echo 提示：每个服务都在独立的命令窗口中运行
echo       关闭窗口即可停止对应服务
echo.
pause
