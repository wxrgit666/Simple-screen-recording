@echo off
chcp 65001 >nul
echo ========================================
echo     SimpleRecorder - Traditional Installer Builder
echo ========================================
echo.

:: Set paths
set PROJECT_DIR=%~dp0
set LAUNCHER_DIR=%PROJECT_DIR%Launcher
set OUTPUT_DIR=%PROJECT_DIR%installer-output
set TEMP_DIR=%PROJECT_DIR%temp-build

:: Clean previous builds
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
mkdir "%OUTPUT_DIR%"
mkdir "%TEMP_DIR%"

echo Step 1/4: Building UWP Application...
echo ========================================

:: Check if MSBuild exists
where msbuild >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: MSBuild not found. Please install Visual Studio.
    pause
    exit /b 1
)

:: Build UWP application
msbuild "%PROJECT_DIR%FluentScreenRecorder.sln" /p:Configuration=Release /p:Platform=x64 /p:GenerateAppxPackageOnBuild=true /v:minimal
if %errorlevel% neq 0 (
    echo ERROR: UWP application build failed!
    pause
    exit /b 1
)
echo SUCCESS: UWP application built successfully

echo.
echo Step 2/4: Building Launcher...
echo ========================================

:: Check .NET SDK
dotnet --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: .NET SDK not found. Please install .NET 6.0 or higher
    echo Download: https://dotnet.microsoft.com/download
    pause
    exit /b 1
)

:: Build launcher
cd "%LAUNCHER_DIR%"
dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -o "%TEMP_DIR%"
if %errorlevel% neq 0 (
    echo ERROR: Launcher build failed!
    cd "%PROJECT_DIR%"
    pause
    exit /b 1
)
cd "%PROJECT_DIR%"
echo SUCCESS: Launcher built successfully

echo.
echo Step 3/4: Preparing installation files...
echo ========================================

:: Copy build files
if exist "FluentScreenRecorder\AppPackages" (
    xcopy "FluentScreenRecorder\AppPackages" "%TEMP_DIR%\AppPackages\" /s /e /i /y >nul
)
if exist "FluentScreenRecorder\bin\x64\Release" (
    xcopy "FluentScreenRecorder\bin\x64\Release" "%TEMP_DIR%\Runtime\" /s /e /i /y >nul
)
copy "install-uwp-app.bat" "%TEMP_DIR%\" >nul 2>&1
copy "uninstall-uwp-app.bat" "%TEMP_DIR%\" >nul 2>&1
copy "README.md" "%TEMP_DIR%\" >nul 2>&1
copy "LICENSE" "%TEMP_DIR%\" >nul 2>&1

echo SUCCESS: Files prepared successfully

echo.
echo Step 4/4: Creating installer...
echo ========================================

:: Check Inno Setup
set INNO_SETUP_PATH=
if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" (
    set "INNO_SETUP_PATH=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
) else if exist "%ProgramFiles%\Inno Setup 6\ISCC.exe" (
    set "INNO_SETUP_PATH=%ProgramFiles%\Inno Setup 6\ISCC.exe"
) else (
    echo.
    echo WARNING: Inno Setup 6 not found
    echo.
    echo Please choose how to create installer:
    echo 1. Download and install Inno Setup 6
    echo 2. Skip this step, create installer manually
    echo 3. Exit
    echo.
    choice /C 123 /M "Please choose"
    
    if errorlevel 3 goto :end
    if errorlevel 2 goto :manual
    if errorlevel 1 goto :download_inno
)

:: Create installer using Inno Setup
echo Creating installer using Inno Setup...
"%INNO_SETUP_PATH%" "%PROJECT_DIR%installer-script.iss"
if %errorlevel% neq 0 (
    echo ERROR: Installer creation failed!
    goto :manual
)

echo SUCCESS: Traditional installer created!
echo.
echo Package location: %OUTPUT_DIR%\SimpleRecorder_Installer_v1.0.0.exe
echo.
echo Now you have a traditional .exe installer!
echo    - Double-click to install
echo    - Support custom installation directory
echo    - Create desktop shortcuts
echo    - Support uninstall
echo.
goto :open_output

:download_inno
echo Downloading Inno Setup 6...
powershell.exe -Command "try { Invoke-WebRequest -Uri 'https://jrsoftware.org/download.php/is.exe' -OutFile '%TEMP%\innosetup.exe' } catch { exit 1 }"
if %errorlevel% neq 0 (
    echo ERROR: Download failed, please download manually
    echo Download URL: https://jrsoftware.org/isdl.php
    goto :manual
)
echo Please install Inno Setup and re-run this script
start "" "%TEMP%\innosetup.exe"
goto :end

:manual
echo.
echo Manual installer creation methods:
echo ========================================
echo.
echo Method 1: Using Inno Setup (Recommended)
echo 1. Download Inno Setup 6: https://jrsoftware.org/isdl.php
echo 2. Re-run this script
echo.
echo Method 2: Using NSIS
echo 1. Download NSIS: https://nsis.sourceforge.io/Download
echo 2. Use provided installer-script.nsi file
echo.
echo Method 3: Package as ZIP archive
echo 1. Compress %TEMP_DIR% folder
echo 2. Tell users to extract and run install-uwp-app.bat
echo.

:open_output
echo Opening output directory...
if exist "%TEMP_DIR%" explorer "%TEMP_DIR%"

:end
echo.
echo ========================================
echo Build completed!
echo ========================================
pause