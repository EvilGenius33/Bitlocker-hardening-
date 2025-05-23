# 🔒 BitLocker Full Hardening – Project Xenoz

This PowerShell script transforms default BitLocker into a fully hardened encryption control  
based on real-world post-exploitation scenarios and common adversary tactics (MITRE ATT&CK: T1070, T1202, T1485).

## ✅ Features Included

- Enforces BitLocker on system drive with strong encryption (`XTS-AES256`)
- Supports TPM or fallback to password-only systems
- Allows BitLocker without TPM (via registry hardening)
- Confirms Secure Boot presence (UEFI check)
- Enables audit policy logging for:
  - Other System Events
  - Security State Change
  - System Integrity
  - Object Access
- Can be extended to removable drive encryption, Azure key integration & DMA protection

## 🧰 Requirements

- Run as **Administrator**
- Windows 10/11
- UEFI + Secure Boot recommended for full protection

## 🚀 Usage

```powershell
powershell -ExecutionPolicy Bypass -File .\project_xenoz.ps1
