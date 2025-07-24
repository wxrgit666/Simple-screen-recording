@echo off
echo ========================================
echo         极简录屏 应用打包工具
echo ========================================
echo.

:: 设置项目路径
set PROJECT_DIR=%~dp0
set PROJECT_NAME=FluentScreenRecorder
set SOLUTION_FILE=%PROJECT_DIR%FluentScreenRecorder.sln

echo 正在检查环境...

:: 检查MSBuild
where msbuild >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未找到MSBuild，请确保已安装Visual Studio
    echo 你可以通过以下方式安装：
    echo 1. 安装 Visual Studio 2019/2022
    echo 2. 安装 Build Tools for Visual Studio
    pause
    exit /b 1
)

echo MSBuild 检查通过...

:: 清理之前的构建
echo 正在清理之前的构建...
msbuild "%SOLUTION_FILE%" /t:Clean /p:Configuration=Release /p:Platform=x64 /v:minimal

:: 开始构建
echo.
echo ========================================
echo 开始构建应用包...
echo ========================================

:: 构建Release版本
msbuild "%SOLUTION_FILE%" /p:Configuration=Release /p:Platform=x64 /p:GenerateAppxPackageOnBuild=true /p:AppxBundlePlatforms=x64 /v:minimal

if %errorlevel% neq 0 (
    echo.
    echo ❌ 构建失败！请检查错误信息。
    pause
    exit /b 1
)

echo.
echo ========================================
echo ✅ 构建成功！
echo ========================================

:: 查找生成的包
echo 正在查找生成的安装包...

set PACKAGE_DIR=%PROJECT_DIR%%PROJECT_NAME%\bin\x64\Release
set APPPACKAGES_DIR=%PROJECT_DIR%%PROJECT_NAME%\AppPackages

if exist "%APPPACKAGES_DIR%" (
    echo.
    echo 📦 安装包位置: %APPPACKAGES_DIR%
    explorer "%APPPACKAGES_DIR%"
) else if exist "%PACKAGE_DIR%" (
    echo.
    echo 📦 安装包位置: %PACKAGE_DIR%
    explorer "%PACKAGE_DIR%"
) else (
    echo.
    echo ⚠️  未找到安装包，请手动检查以下位置：
    echo    %PACKAGE_DIR%
    echo    %APPPACKAGES_DIR%
)

echo.
echo ========================================
echo 🎉 打包完成！
echo ========================================
echo.
echo 安装说明：
echo 1. 找到生成的 .msix 或 .appx 文件
echo 2. 双击安装包进行安装
echo 3. 如提示需要开发者模式，请在Windows设置中启用
echo.
echo 分发说明：
echo - .msix文件可以直接分发给用户安装
echo - 也可以上传到Microsoft Store
echo.
pause