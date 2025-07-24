@echo off
echo ========================================
echo           Simple Build Tool
echo ========================================
echo.

echo Checking environment...

:: Check MSBuild
where msbuild >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: MSBuild not found
    echo Please install Visual Studio with UWP workload
    pause
    exit /b 1
)

echo Building UWP application...
msbuild FluentScreenRecorder.sln /p:Configuration=Release /p:Platform=x64 /p:GenerateAppxPackageOnBuild=true /v:minimal

if %errorlevel% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo SUCCESS: Build completed!
echo.
echo Looking for packages...

:: Find and open the package directory
for /d %%i in (FluentScreenRecorder\AppPackages\*) do (
    echo Found package: %%i
    explorer "%%i"
    goto :found
)

echo Package not found in expected location
echo Please check: FluentScreenRecorder\AppPackages\

:found
echo.
echo To install:
echo 1. Find the .msix file in the opened folder
echo 2. Double-click to install
echo 3. Or run Add-AppDevPackage.ps1 script
echo.
pause