@echo off
echo 正在卸载极简录屏应用组件...

:: 卸载UWP应用
echo 卸载UWP应用...
powershell.exe -Command "Get-AppxPackage | Where-Object {$_.Name -like '*SimpleRecorder*'} | Remove-AppxPackage" 2>nul

:: 清理注册表项（如果有）
echo 清理注册表...
reg delete "HKEY_CURRENT_USER\Software\SimpleRecorder" /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\SimpleRecorder" /f >nul 2>&1

echo 应用组件卸载完成
exit /b 0