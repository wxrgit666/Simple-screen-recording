@echo off
echo 正在安装极简录屏应用组件...

:: 设置路径
set APP_DIR=%~dp0
set PACKAGES_DIR=%APP_DIR%AppPackages

:: 启用开发者模式（如果需要）
echo 检查开发者模式设置...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense 2>nul | find "0x1" >nul
if %errorlevel% neq 0 (
    echo 启用开发者模式...
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d 1 /f >nul 2>&1
)

:: 查找并安装UWP应用包
echo 正在安装应用包...
for /r "%PACKAGES_DIR%" %%i in (Add-AppDevPackage.ps1) do (
    if exist "%%i" (
        echo 找到安装脚本: %%i
        powershell.exe -ExecutionPolicy Bypass -File "%%i" -Force
        goto :installed
    )
)

:: 如果没找到PowerShell脚本，尝试直接安装msix
for /r "%PACKAGES_DIR%" %%i in (*.msix) do (
    if exist "%%i" (
        echo 安装应用包: %%i
        powershell.exe -Command "Add-AppxPackage -Path '%%i' -ForceApplicationShutdown"
        goto :installed
    )
)

echo 未找到应用包文件
exit /b 1

:installed
echo UWP应用组件安装完成
exit /b 0