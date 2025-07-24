@echo off
echo ========================================
echo GitHub Actions Build Script
echo ========================================

REM 设置环境变量
set CONFIGURATION=Release
set PLATFORM=x64

echo Building solution without package signing...
REM 禁用签名，直接构建主项目
msbuild FluentScreenRecorder\FluentScreenRecorder.csproj ^
  /p:Configuration=%CONFIGURATION% ^
  /p:Platform=%PLATFORM% ^
  /p:AppxPackageSigningEnabled=false ^
  /p:GenerateAppxPackageOnBuild=true ^
  /p:UapAppxPackageBuildMode=SideloadOnly ^
  /p:AppxBundle=Never ^
  /p:AppxPackageDir=AppPackages\

echo.
echo Checking for output files...
echo ========================================

REM 查找生成的文件
echo Looking for MSIX/APPX files:
dir /s /b *.msix *.appx 2>nul || echo No MSIX/APPX files found

echo.
echo Looking for EXE files:
dir /s /b *.exe 2>nul || echo No EXE files found

echo.
echo Checking specific locations:
if exist FluentScreenRecorder\AppPackages (
    echo Contents of AppPackages:
    dir FluentScreenRecorder\AppPackages /s
)

if exist FluentScreenRecorder\bin\x64\Release (
    echo Contents of bin\x64\Release:
    dir FluentScreenRecorder\bin\x64\Release /s
)

echo.
echo Build script completed!