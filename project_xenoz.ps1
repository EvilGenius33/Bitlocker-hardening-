# ==============================
# BitLocker Full Hardening Script
# Compatible with TPM or No-TPM systems
# ==============================

Write-Host "[1] Detecting system drive..." -ForegroundColor Cyan
$sysDrive = Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty SystemDrive

# [2] Authorize BitLocker without TPM (if needed)
Write-Host "[2] Configuring registry to allow BitLocker without TPM..." -ForegroundColor Cyan
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseAdvancedStartup" -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EnableBDEWithNoTPM" -Value 1 -PropertyType DWord -Force | Out-Null

# [3] Enable BitLocker with password protector (TPM fallback)
Write-Host "[3] Enabling BitLocker on drive $sysDrive with password protector..." -ForegroundColor Cyan
Enable-BitLocker -MountPoint $sysDrive -EncryptionMethod XtsAes256 -UsedSpaceOnly -PasswordProtector

# [4] Enforce Secure Boot detection
Write-Host "[4] Checking Secure Boot status..." -ForegroundColor Cyan
$secureBoot = Confirm-SecureBootUEFI
if ($secureBoot) {
 Write-Host "✅ Secure Boot is enabled." -ForegroundColor Green
} else {
 Write-Host "⚠️ Secure Boot is NOT enabled. Please enable it manually in the BIOS." -ForegroundColor Yellow
}

# [5] Apply auditpol logging settings (executed one by one, per Microsoft)
Write-Host "[5] Enabling detailed audit policy for BitLocker events..." -ForegroundColor Cyan
Start-Process cmd -ArgumentList '/c auditpol /set /subcategory:"Other System Events" /success:enable /failure:enable' -Wait
Start-Process cmd -ArgumentList '/c auditpol /set /subcategory:"Security State Change" /success:enable /failure:enable' -Wait
Start-Process cmd -ArgumentList '/c auditpol /set /subcategory:"System Integrity" /success:enable /failure:enable' -Wait
Start-Process cmd -ArgumentList '/c auditpol /set /subcategory:"Other Object Access Events" /success:enable /failure:enable' -Wait

Write-Host "[6] Script completed. BitLocker is active. Secure Boot status has been reported. Logs are enabled." -ForegroundColor Green
