# My dotfiles

## Installation guide (Windows)
1. `shutdown /r /fw /f /t 0` to Reboot into BIOS and turn on virtualization
2. Disable UAC for less interaction with the OS (Optional)
3. Install git `winget install --id Git.Git --interactive`
4. Install chezmoi with `winget install --id twpayne.chezmoi`
5. `chezmoi init --apply Davido264`
6. Reenable UAC (If you have done step 2)

### WSL
To enable systemd, go to (or create) `/etc/wsl.conf`, its contents must be
```
[boot]
systemd=true
```
Then `wsl --shutdown` to stop WSL vms and then enter to WSL again


## Installation guide (Open Suse WSL)
1. Update system `sudo zypper update -y`
2. Install git and chezmoi `sudo zypper install -y chezmoi git`
3. `chezmoi init --apply Davido264`

## Installation guide (Kali WSL)
1. Update system `sudo apt update -y && sudo apt upgrade -y`
2. Install git `sudo apt install -y git`
3. Download chezmoi `curl -sLO <chezmoi github url deb>`
4. Install chezmoi `sudo dpkg --install <downloaded .deb package>` 
5. `chezmoi init --apply Davido264`
