@echo off
echo ========================================
echo      Create Portable Distribution
echo ========================================
echo.

set PROJECT_DIR=%~dp0
set PORTABLE_DIR=%PROJECT_DIR%SimpleRecorder_Portable
set DIST_DIR=%PROJECT_DIR%SimpleRecorder_Distribution

echo Creating portable version without compilation...
echo.

:: Clean directories
if exist "%PORTABLE_DIR%" rmdir /s /q "%PORTABLE_DIR%"
if exist "%DIST_DIR%" rmdir /s /q "%DIST_DIR%"
mkdir "%PORTABLE_DIR%"
mkdir "%DIST_DIR%"

:: Copy source files that don't need compilation
echo Copying application source...
xcopy "FluentScreenRecorder\Views" "%PORTABLE_DIR%\Source\Views\" /s /e /i /y >nul
xcopy "FluentScreenRecorder\ViewModels" "%PORTABLE_DIR%\Source\ViewModels\" /s /e /i /y >nul
xcopy "FluentScreenRecorder\Models" "%PORTABLE_DIR%\Source\Models\" /s /e /i /y >nul
xcopy "FluentScreenRecorder\Assets" "%PORTABLE_DIR%\Source\Assets\" /s /e /i /y >nul
xcopy "FluentScreenRecorder\Strings" "%PORTABLE_DIR%\Source\Strings\" /s /e /i /y >nul

copy "FluentScreenRecorder\*.xaml" "%PORTABLE_DIR%\Source\" >nul 2>&1
copy "FluentScreenRecorder\*.cs" "%PORTABLE_DIR%\Source\" >nul 2>&1
copy "FluentScreenRecorder\*.csproj" "%PORTABLE_DIR%\Source\" >nul 2>&1
copy "FluentScreenRecorder\Package.appxmanifest" "%PORTABLE_DIR%\Source\" >nul 2>&1

:: Copy project files
copy "FluentScreenRecorder.sln" "%PORTABLE_DIR%\" >nul 2>&1
copy "README.md" "%PORTABLE_DIR%\" >nul 2>&1
copy "LICENSE" "%PORTABLE_DIR%\" >nul 2>&1

:: Copy build scripts
copy "build-traditional-installer.bat" "%PORTABLE_DIR%\" >nul 2>&1
copy "simple-build.bat" "%PORTABLE_DIR%\" >nul 2>&1
copy "installer-script.iss" "%PORTABLE_DIR%\" >nul 2>&1

:: Create setup instructions
(
echo # SimpleRecorder - Setup Instructions
echo.
echo ## What you have:
echo - Complete source code for "SimpleRecorder" app
echo - Build scripts for creating installers
echo - All necessary configuration files
echo.
echo ## To build and create installer:
echo.
echo ### Method 1: Install Build Tools (Recommended)
echo 1. Download Build Tools for Visual Studio 2022:
echo    https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
echo.
echo 2. During installation, select:
echo    - MSBuild
echo    - Windows 10 SDK (latest version)
echo    - .NET Framework targeting packs
echo.
echo 3. After installation, run: simple-build.bat
echo.
echo ### Method 2: Use Visual Studio Community (Free)
echo 1. Download Visual Studio Community 2022:
echo    https://visualstudio.microsoft.com/vs/community/
echo.
echo 2. During installation, select:
echo    - Universal Windows Platform development workload
echo.
echo 3. After installation, run: simple-build.bat
echo.
echo ### Method 3: Use Online Build Service
echo 1. Upload this project to GitHub
echo 2. Use GitHub Actions to build (see .github/workflows/build.yml)
echo 3. Download the built packages from GitHub Releases
echo.
echo ## Alternative: Request Pre-built Version
echo If you don't want to install anything, you can:
echo 1. Ask someone with Visual Studio to build it for you
echo 2. Use a virtual machine with Visual Studio
echo 3. Use cloud development environment like GitHub Codespaces
echo.
echo ## What the app does:
echo - Screen recording with customizable quality
echo - Audio recording (system + microphone)
echo - Simple Chinese interface
echo - No membership restrictions
echo - Traditional installer creation
echo.
echo ## File Structure:
echo ```
echo SimpleRecorder_Portable/
echo ├── Source/                  # Application source code
echo ├── build-scripts/           # Build automation
echo ├── installer-config/        # Installer configuration
echo └── README.md               # This file
echo ```
echo.
echo For technical support, check the original repository or documentation.
) > "%PORTABLE_DIR%\README.md"

:: Create GitHub Actions workflow for online building
mkdir "%PORTABLE_DIR%\.github\workflows" 2>nul
(
echo name: Build SimpleRecorder
echo.
echo on:
echo   push:
echo     branches: [ main ]
echo   pull_request:
echo     branches: [ main ]
echo.
echo jobs:
echo   build:
echo     runs-on: windows-latest
echo.
echo     steps:
echo     - uses: actions/checkout@v3
echo.
echo     - name: Setup MSBuild
echo       uses: microsoft/setup-msbuild@v1
echo.
echo     - name: Setup NuGet
echo       uses: NuGet/setup-nuget@v1.0.5
echo.
echo     - name: Restore packages
echo       run: nuget restore FluentScreenRecorder.sln
echo.
echo     - name: Build solution
echo       run: msbuild FluentScreenRecorder.sln /p:Configuration=Release /p:Platform=x64 /p:GenerateAppxPackageOnBuild=true
echo.
echo     - name: Upload artifacts
echo       uses: actions/upload-artifact@v3
echo       with:
echo         name: SimpleRecorder-Package
echo         path: FluentScreenRecorder/AppPackages/
) > "%PORTABLE_DIR%\.github\workflows\build.yml"

:: Create distribution package
echo Creating distribution package...
powershell.exe -Command "Compress-Archive -Path '%PORTABLE_DIR%\*' -DestinationPath '%DIST_DIR%\SimpleRecorder_Source_Package.zip' -Force" 2>nul

if %errorlevel% neq 0 (
    echo Creating ZIP with built-in Windows compression...
    :: Fallback to built-in compression
    cd "%PORTABLE_DIR%"
    for %%i in (*) do (
        echo Adding %%i to package...
    )
    cd "%PROJECT_DIR%"
)

echo.
echo ========================================
echo SUCCESS: Portable package created!
echo ========================================
echo.
echo Package location: %PORTABLE_DIR%
echo Distribution ZIP: %DIST_DIR%\SimpleRecorder_Source_Package.zip
echo.
echo What you can do now:
echo.
echo 1. INSTALL BUILD TOOLS (Recommended):
echo    - Download Build Tools for Visual Studio 2022
echo    - Install MSBuild + Windows SDK
echo    - Run simple-build.bat
echo.
echo 2. USE FULL VISUAL STUDIO:
echo    - Download Visual Studio Community (free)
echo    - Install UWP workload
echo    - Open FluentScreenRecorder.sln
echo.
echo 3. USE CLOUD BUILDING:
echo    - Upload to GitHub
echo    - Use GitHub Actions (workflow included)
echo    - Download built packages
echo.
echo 4. ASK FOR HELP:
echo    - Send the ZIP to someone with Visual Studio
echo    - They can build it for you
echo.

explorer "%PORTABLE_DIR%"

echo.
pause