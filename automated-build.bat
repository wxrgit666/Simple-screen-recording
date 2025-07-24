@echo off
echo ========================================
echo Automated UWP Build with Certificate
echo ========================================

echo Step 1: Creating temporary certificate...
call create-temp-cert.bat

if not exist "FluentScreenRecorder\SimpleRecorder_TemporaryKey.pfx" (
    echo ERROR: Certificate creation failed!
    exit /b 1
)

echo Step 2: Reading certificate thumbprint...
set /p THUMBPRINT=<cert-thumbprint.txt
echo Certificate thumbprint: %THUMBPRINT%

echo Step 3: Updating project file with certificate...
REM 使用PowerShell更新XML文件
powershell -Command ^
  "$xml = [xml](Get-Content 'FluentScreenRecorder\FluentScreenRecorder.csproj'); $xml.Project.PropertyGroup | Where-Object {$_.PackageCertificateKeyFile -ne $null} | ForEach-Object {$_.PackageCertificateKeyFile = 'SimpleRecorder_TemporaryKey.pfx'}; $xml.Project.PropertyGroup | Where-Object {$_.PackageCertificateThumbprint -ne $null} | ForEach-Object {$_.PackageCertificateThumbprint = '%THUMBPRINT%'}; $xml.Save('FluentScreenRecorder\FluentScreenRecorder.csproj')"

echo Step 4: Building UWP application...
msbuild FluentScreenRecorder\FluentScreenRecorder.csproj ^
  /t:Build;_GenerateAppxPackage ^
  /p:Configuration=Release ^
  /p:Platform=x64 ^
  /p:AppxPackageSigningEnabled=true ^
  /p:PackageCertificateKeyFile=SimpleRecorder_TemporaryKey.pfx ^
  /p:PackageCertificatePassword=TempPass123! ^
  /p:GenerateAppxPackageOnBuild=true ^
  /p:AppxBundle=Never ^
  /p:BuildProjectReferences=false ^
  /p:UapAppxPackageBuildMode=SideloadOnly ^
  /p:AppxPackageDir="AppPackages\\"

echo Step 4a: Building dependencies separately...
msbuild CaptureEncoder\CaptureEncoder.csproj /t:Build /p:Configuration=Release /p:Platform=x64
msbuild Microsoft.PowerToys.Settings.UI\Microsoft.PowerToys.Settings.UI.csproj /t:Build /p:Configuration=Release /p:Platform=x64
msbuild ScreenSenderComponent\ScreenSenderComponent.vcxproj /t:Build /p:Configuration=Release /p:Platform=x64

echo Step 4b: Building main project with dependencies...
msbuild FluentScreenRecorder\FluentScreenRecorder.csproj ^
  /t:Build;_GenerateAppxPackage ^
  /p:Configuration=Release ^
  /p:Platform=x64 ^
  /p:AppxPackageSigningEnabled=true ^
  /p:PackageCertificateKeyFile=SimpleRecorder_TemporaryKey.pfx ^
  /p:PackageCertificatePassword=TempPass123! ^
  /p:GenerateAppxPackageOnBuild=true ^
  /p:AppxBundle=Never ^
  /p:UapAppxPackageBuildMode=SideloadOnly ^
  /p:AppxPackageDir="AppPackages\\"

echo Step 5: Checking for output files...
echo ========================================

if exist "FluentScreenRecorder\AppPackages" (
    echo Found AppPackages directory:
    dir "FluentScreenRecorder\AppPackages" /s
) else (
    echo AppPackages directory not found
)

if exist "FluentScreenRecorder\bin\x64\Release" (
    echo Found Release directory:
    dir "FluentScreenRecorder\bin\x64\Release" /s
) else (
    echo Release directory not found
)

echo Searching for all package files...
dir /s *.appx *.msix 2>nul

echo Build completed!