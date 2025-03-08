Import-Module "$Env:SROOT/utils.psm1"
Import-Module "$Env:SROOT/vars.psm1"
$ErrorActionPreference = "Stop"

if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

if ($Global:WINDOWS_DEV -eq 0)
{
    return
}

if (-not $(Test-Path "$HOME/.local/share/nvim-data")) 
{
    mkdir "$HOME/.local/share/nvim-data"
}

ScoopInstall-Package -Package make
WingetInstall-Package -Package Git.Git
WingetInstall-Package -Package Kitware.CMake

where.exe pnpm
if ($LASTEXITCODE -eq 1)
{
    Invoke-WebRequest -useb https://get.pnpm.io/install.ps1 | Invoke-Expression
    pnpm env use --global latest
}

WingetInstall-Package -Package gerardog.gsudo
WingetInstall-Package -Package Microsoft.PowerShell
sudo { pwsh -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted" }

WingetInstall-Package -Package Microsoft.VisualStudioCode
WingetInstall-Package -Package Microsoft.VisualStudio.2022.BuildTools
WingetInstall-Package -Package GitHub.cli
WingetInstall-Package -Package GLab.GLab
WingetInstall-Package -Package RedHat.Podman
WingetInstall-Package -Package WerWolv.ImHex
# WiresharkFoundation.Wireshark
# Hashicorp.Vagrant
# Cloudflare.cloudflared
# scoop flyctl
ScoopInstall-Package -Package vcredist2022
ScoopInstall-Package -Package aws
ScoopInstall-Package -Package llvm
ScoopInstall-Package -Package rustup
ScoopInstall-Package -Package go
ScoopInstall-Package -Package openjdk
ScoopInstall-Package -Package python
ScoopInstall-Package -Package dotnet-sdk
ScoopInstall-Package -Package gcc
ScoopInstall-Package -Package android-clt

sdkmanager 'tools'
sdkmanager 'platform-tools' 'platforms;android-24' 'build-tools;24.0.0' 'ndk-bundle' 'add-ons;addon-google_apis-google-24' 'extras;google;google_play_services' 'emulator'

rustup toolchain install stable-msvc
rustup toolchain install stable-gnu
rustup target add x86_64-pc-windows-msvc
rustup target add x86_64-pc-windows-gnu

python -m ensurepip
python -m pip install -U requests beautifulsoup4 matplotlib pandas ipykernel pdoc3

pnpm install -g vite create-vite commitizen cz-conventional-changelog yarn
