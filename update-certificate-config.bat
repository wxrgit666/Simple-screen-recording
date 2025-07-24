@echo off
echo ========================================
echo 更新项目证书配置
echo ========================================

echo 请按以下步骤操作：
echo.
echo 1. 首先运行PowerShell脚本创建证书：
echo    powershell -ExecutionPolicy Bypass -File create-test-certificate.ps1
echo.
echo 2. 记下生成的证书指纹
echo.
echo 3. 手动更新FluentScreenRecorder.csproj中的以下行：
echo    ^<PackageCertificateKeyFile^>SimpleRecorder_TemporaryKey.pfx^</PackageCertificateKeyFile^>
echo    ^<PackageCertificateThumbprint^>替换为实际的证书指纹^</PackageCertificateThumbprint^>
echo.
echo 4. 然后可以运行构建脚本

pause