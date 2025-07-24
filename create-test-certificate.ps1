# PowerShell脚本：创建UWP测试证书
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "创建UWP应用测试证书" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 创建自签名证书
$cert = New-SelfSignedCertificate `
    -Type Custom `
    -Subject "CN=SimpleRecorder-Studio" `
    -KeyUsage DigitalSignature `
    -FriendlyName "SimpleRecorder Test Certificate" `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")

Write-Host "`n证书创建成功！" -ForegroundColor Green
Write-Host "证书指纹: $($cert.Thumbprint)" -ForegroundColor Yellow

# 导出证书为PFX文件
$pwd = ConvertTo-SecureString -String "SimpleRecorder123!" -Force -AsPlainText
$path = "$PSScriptRoot\SimpleRecorder_TemporaryKey.pfx"

Export-PfxCertificate `
    -Cert $cert `
    -FilePath $path `
    -Password $pwd

Write-Host "`n证书已导出到: $path" -ForegroundColor Green
Write-Host "证书密码: SimpleRecorder123!" -ForegroundColor Yellow

Write-Host "`n下一步操作：" -ForegroundColor Cyan
Write-Host "1. 证书文件已生成：SimpleRecorder_TemporaryKey.pfx"
Write-Host "2. 请更新项目文件中的证书配置"
Write-Host "3. 证书指纹: $($cert.Thumbprint)"

# 将证书信息保存到文本文件
@"
证书信息
========================================
证书文件: SimpleRecorder_TemporaryKey.pfx
证书密码: SimpleRecorder123!
证书指纹: $($cert.Thumbprint)
证书主题: CN=SimpleRecorder-Studio
"@ | Out-File -FilePath "$PSScriptRoot\certificate-info.txt" -Encoding UTF8

Write-Host "`n证书信息已保存到: certificate-info.txt" -ForegroundColor Green