@echo off
echo Creating temporary certificate for UWP build...

REM 创建临时证书使用 PowerShell
powershell -Command ^
  "$cert = New-SelfSignedCertificate -Type Custom -Subject 'CN=SimpleRecorder-Studio' -KeyUsage DigitalSignature -FriendlyName 'Temp' -CertStoreLocation 'Cert:\CurrentUser\My' -TextExtension @('2.5.29.37={text}1.3.6.1.5.5.7.3.3', '2.5.29.19={text}'); $pwd = ConvertTo-SecureString -String 'TempPass123!' -Force -AsPlainText; Export-PfxCertificate -Cert $cert -FilePath 'FluentScreenRecorder\SimpleRecorder_TemporaryKey.pfx' -Password $pwd; Write-Host ""Certificate Thumbprint: $($cert.Thumbprint)""; $cert.Thumbprint | Out-File -FilePath 'cert-thumbprint.txt'"

echo Certificate created!