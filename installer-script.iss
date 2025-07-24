[Setup]
; 基本信息
AppName=极简录屏
AppVersion=1.0.0
AppVerName=极简录屏 v1.0.0
AppPublisher=极简录屏工作室
AppPublisherURL=https://github.com/your-repo
AppSupportURL=https://github.com/your-repo/issues
AppUpdatesURL=https://github.com/your-repo/releases
DefaultDirName={autopf}\SimpleRecorder
DefaultGroupName=极简录屏
AllowNoIcons=yes
LicenseFile=LICENSE
OutputDir=installer-output
OutputBaseFilename=极简录屏_安装程序_v1.0.0
SetupIconFile=FluentScreenRecorder\Assets\Square44x44Logo.png
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin

; 支持的Windows版本
MinVersion=10.0.17763
OnlyBelowVersion=0

; 安装程序界面
WizardImageFile=installer-banner.bmp
WizardSmallImageFile=installer-icon.bmp

[Languages]
Name: "chinese"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode

[Files]
; 复制应用包文件
Source: "FluentScreenRecorder\AppPackages\*"; DestDir: "{app}\AppPackages"; Flags: ignoreversion recursesubdirs createallsubdirs
; 复制运行时文件
Source: "FluentScreenRecorder\bin\x64\Release\*"; DestDir: "{app}\Runtime"; Flags: ignoreversion recursesubdirs createallsubdirs
; 复制启动器
Source: "launcher.exe"; DestDir: "{app}"; Flags: ignoreversion
; 复制说明文件
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\极简录屏"; Filename: "{app}\launcher.exe"
Name: "{group}\{cm:UninstallProgram,极简录屏}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\极简录屏"; Filename: "{app}\launcher.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\极简录屏"; Filename: "{app}\launcher.exe"; Tasks: quicklaunchicon

[Run]
; 首次安装时的操作
Filename: "{app}\install-uwp-app.bat"; Parameters: ""; WorkingDir: "{app}"; Flags: runhidden waituntilterminated; Description: "安装UWP应用组件"
Filename: "{app}\launcher.exe"; Description: "{cm:LaunchProgram,极简录屏}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
; 卸载时清理UWP应用
Filename: "{app}\uninstall-uwp-app.bat"; Parameters: ""; WorkingDir: "{app}"; Flags: runhidden waituntilterminated

[Code]
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\SimpleRecorder_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
  Result := 0;
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      UnInstallOldVersion();
    end;
  end;
end;