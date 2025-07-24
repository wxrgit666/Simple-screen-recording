@echo off
echo ========================================
echo Fallback Build Script for GitHub Actions
echo ========================================

echo Building dependencies first...
msbuild ScreenSenderComponent\ScreenSenderComponent.vcxproj /p:Configuration=Release /p:Platform=x64
msbuild CaptureEncoder\CaptureEncoder.csproj /p:Configuration=Release /p:Platform=x64

echo Building main UWP project...
msbuild FluentScreenRecorder\FluentScreenRecorder.csproj ^
  /p:Configuration=Release ^
  /p:Platform=x64 ^
  /p:AppxPackageSigningEnabled=false ^
  /t:Build

echo.
echo Checking for any generated files...
echo ========================================

if exist FluentScreenRecorder\bin\x64\Release (
    echo Contents of FluentScreenRecorder\bin\x64\Release:
    dir FluentScreenRecorder\bin\x64\Release /s
) else (
    echo FluentScreenRecorder\bin\x64\Release not found
)

if exist FluentScreenRecorder\AppPackages (
    echo Contents of FluentScreenRecorder\AppPackages:
    dir FluentScreenRecorder\AppPackages /s
) else (
    echo FluentScreenRecorder\AppPackages not found
)

echo Searching for any exe or dll files...
dir /s *.exe *.dll 2>nul | findstr /i "fluentscreenrecorder simplerecorder"

echo.
echo Fallback build completed!