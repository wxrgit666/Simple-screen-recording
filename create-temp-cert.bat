@echo off
echo Creating temporary certificate for UWP build...

REM 使用独立的PowerShell脚本文件来避免引号转义问题
powershell -ExecutionPolicy Bypass -File create-certificate.ps1

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Certificate creation failed!
    exit /b 1
)

echo Certificate created successfully!