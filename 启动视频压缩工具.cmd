@echo off
chcp 65001 >nul
title 视频压缩工具
cd /d "%~dp0"

where python3 >nul 2>&1
if %errorlevel% neq 0 (
    where python >nul 2>&1
    if %errorlevel% neq 0 (
        echo 未找到 Python。请安装 Python 3 后重试：https://www.python.org/downloads/
        pause
        exit /b 1
    )
    set PYTHON=python
) else (
    set PYTHON=python3
)

set PORT=8765
:findport
powershell.exe -NoProfile -Command "try { $l = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, %PORT%); $l.Start(); $l.Stop(); exit 0 } catch { exit 1 }"
if %errorlevel% neq 0 (
    if %PORT% geq 8795 (
        echo 本地端口 8765-8795 均被占用，请关闭占用程序后重试。
        pause
        exit /b 1
    )
    set /a PORT+=1
    goto findport
)

set URL=http://127.0.0.1:%PORT%/视频压缩.html
echo 视频压缩工具已启动：%URL%
echo 关闭本窗口即可停止。
echo.

start "" "%URL%"
%PYTHON% -m http.server %PORT% --bind 127.0.0.1