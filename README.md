# My dotfiles

## Installation guide (Windows)
1. `shutdown /r /fw /f /t 0` to Reboot into BIOS and turn on virtualization (optional if will be used for dev)
2. Disable UAC for less interactive installation
3. On a powershell terminal, type `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`
3. `Invoke-RestMethod -Uri https://raw.githubusercontent.com/Davido264/dotfiles/main/install.ps1 | Invoke-Expression` 
4. Reenable UAC (If you have done step 2)

### WSL
To enable systemd, go to (or create) `/etc/wsl.conf`, its contents must be
```
[boot]
systemd=true
```
Then `wsl --shutdown` to stop WSL vms and then enter to WSL again

---

## Installation guide (Linux or WSL)
1. Update system `sudo apt update -y && sudo apt upgrade -y`
2. `curl -sSL https://raw.githubusercontent.com/Davido264/dotfiles/main/install.sh | sh`
