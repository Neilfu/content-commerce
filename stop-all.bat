@echo off
REM Content Commerce Platform - 停止所有服务脚本

echo ========================================
echo   停止所有服务...
echo ========================================
echo.

REM 停止 Node.js 进程
echo [1/2] 停止 Node.js 进程...
taskkill /F /IM node.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo   已停止 Node.js 进程
) else (
    echo   没有运行中的 Node.js 进程
)

REM 停止 Docker 容器
echo [2/2] 停止 Docker 容器...
cd /d %~dp0apps\backend
docker-compose down
echo   已停止 Docker 容器

echo.
echo ========================================
echo   所有服务已停止
echo ========================================
echo.
pause
