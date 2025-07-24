@echo off
echo ========================================
echo Debug Build Script - Find All Issues
echo ========================================

echo Step 1: Clean previous builds
if exist FluentScreenRecorder\bin rmdir /s /q FluentScreenRecorder\bin
if exist FluentScreenRecorder\obj rmdir /s /q FluentScreenRecorder\obj
if exist FluentScreenRecorder\AppPackages rmdir /s /q FluentScreenRecorder\AppPackages

echo Step 2: Try multiple build approaches
echo.
echo === Attempt 1: Direct UWP build ===
msbuild FluentScreenRecorder\FluentScreenRecorder.csproj /p:Configuration=Release /p:Platform=x64 /p:AppxPackageSigningEnabled=false

echo.
echo === Attempt 2: Force package generation ===
msbuild FluentScreenRecorder\FluentScreenRecorder.csproj /p:Configuration=Release /p:Platform=x64 /p:AppxPackageSigningEnabled=false /p:GenerateAppxPackageOnBuild=true /p:AppxPackageDir=AppPackages\

echo.
echo === Attempt 3: Build with verbose output ===
msbuild FluentScreenRecorder\FluentScreenRecorder.csproj /p:Configuration=Release /p:Platform=x64 /p:AppxPackageSigningEnabled=false /v:detailed

echo.
echo Step 3: Comprehensive file search
echo ========================================

echo Searching entire directory for ANY build outputs...
echo.
echo === All EXE files ===
dir /s *.exe 2>nul

echo.
echo === All DLL files ===
dir /s *.dll 2>nul | findstr /v "packages nuget"

echo.
echo === All APPX/MSIX files ===
dir /s *.appx *.msix 2>nul

echo.
echo === All folders named 'bin' ===
dir /s /ad bin 2>nul

echo.
echo === All folders named 'AppPackages' ===
dir /s /ad AppPackages 2>nul

echo.
echo === Contents of FluentScreenRecorder directory ===
if exist FluentScreenRecorder (
    dir FluentScreenRecorder /s | more
) else (
    echo FluentScreenRecorder directory not found!
)

echo.
echo Debug build script completed!
echo ========================================