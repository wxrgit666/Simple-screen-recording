@echo off
echo ========================================
echo    创建极简录屏一键安装包
echo ========================================
echo.

:: 设置路径
set PROJECT_DIR=%~dp0
set PACKAGE_DIR=%PROJECT_DIR%极简录屏_安装包
set OUTPUT_DIR=%PROJECT_DIR%极简录屏_发布

:: 创建安装包目录
if exist "%PACKAGE_DIR%" rmdir /s /q "%PACKAGE_DIR%"
mkdir "%PACKAGE_DIR%"

:: 复制安装文件
echo 正在打包安装文件...
xcopy "%PROJECT_DIR%FluentScreenRecorder\AppPackages\*" "%PACKAGE_DIR%\" /s /e /y >nul

:: 创建简化的安装脚本
echo 创建一键安装脚本...
(
echo @echo off
echo echo ========================================
echo echo          极简录屏 - 一键安装
echo echo ========================================
echo echo.
echo echo 正在安装极简录屏应用...
echo echo 如果是首次安装UWP应用，可能需要启用开发者模式
echo echo.
echo pause
echo.
echo :: 查找PowerShell安装脚本
echo for /r %%i in ^(Add-AppDevPackage.ps1^) do ^(
echo     if exist "%%i" ^(
echo         echo 找到安装脚本: %%i
echo         powershell.exe -ExecutionPolicy Bypass -File "%%i"
echo         goto :found
echo     ^)
echo ^)
echo.
echo echo 未找到安装脚本，尝试直接安装msix文件...
echo for /r %%i in ^(*.msix^) do ^(
echo     if exist "%%i" ^(
echo         echo 安装: %%i
echo         start "" "%%i"
echo         goto :found
echo     ^)
echo ^)
echo.
echo echo 未找到安装文件，请手动安装。
echo goto :end
echo.
echo :found
echo echo.
echo echo 安装完成！你可以在开始菜单中找到"极简录屏"应用。
echo.
echo :end
echo pause
) > "%PACKAGE_DIR%\安装极简录屏.bat"

:: 创建说明文件
(
echo # 极简录屏 - 安装说明
echo.
echo ## 🚀 快速安装
echo 1. 双击运行 "安装极简录屏.bat"
echo 2. 按提示操作即可
echo.
echo ## ⚠️ 首次安装注意事项
echo 如果是第一次安装UWP应用，Windows可能会提示：
echo - 启用开发者模式
echo - 安装应用包证书
echo.
echo 请按照提示操作，这是正常的安全检查。
echo.
echo ## 📱 使用方法
echo 安装完成后，可以在以下位置找到应用：
echo - 开始菜单搜索 "极简录屏"
echo - 开始菜单的应用列表中
echo.
echo ## 🔧 卸载方法
echo 在设置 ^> 应用 ^> 极简录屏 ^> 卸载
echo.
echo ## 💡 技术支持
echo 如遇问题，请检查：
echo 1. Windows版本是否为 Windows 10 1809+ 或 Windows 11
echo 2. 是否启用了开发者模式
echo 3. 是否有足够的磁盘空间
) > "%PACKAGE_DIR%\安装说明.txt"

echo.
echo ========================================
echo ✅ 安装包创建完成！
echo ========================================
echo.
echo 📦 安装包位置: %PACKAGE_DIR%
echo.
echo 包含文件：
echo ├── 安装极简录屏.bat     # 一键安装脚本
echo ├── 安装说明.txt         # 用户说明
echo ├── SimpleRecorder.App_1.0.0.0_x64.msix
echo ├── Dependencies/
echo └── Add-AppDevPackage.ps1
echo.
echo 🎯 分发方式：
echo 1. 压缩整个文件夹分发
echo 2. 告诉用户运行 "安装极简录屏.bat"
echo.

:: 打开文件夹
explorer "%PACKAGE_DIR%"

pause