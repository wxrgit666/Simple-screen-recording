# 创建UWP测试证书
Write-Host "Creating UWP test certificate..." -ForegroundColor Cyan

# 创建证书
$cert = New-SelfSignedCertificate `
    -Type Custom `
    -Subject "CN=SimpleRecorder-Studio" `
    -KeyUsage DigitalSignature `
    -FriendlyName "SimpleRecorder Temp Certificate" `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")

# 导出证书
$pwd = ConvertTo-SecureString -String "TempPass123!" -Force -AsPlainText
$pfxPath = "FluentScreenRecorder\SimpleRecorder_TemporaryKey.pfx"

Export-PfxCertificate -Cert $cert -FilePath $pfxPath -Password $pwd

# 保存指纹
$cert.Thumbprint | Out-File -FilePath "cert-thumbprint.txt" -Encoding ASCII

Write-Host "Certificate created successfully!" -ForegroundColor Green
Write-Host "Thumbprint: $($cert.Thumbprint)" -ForegroundColor Yellow
Write-Host "PFX Path: $pfxPath" -ForegroundColor Yellow