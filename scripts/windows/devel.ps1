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

ScoopInstallPackage -Package make
WingetInstallPackage -Package Git.Git
WingetInstallPackage -Package Kitware.CMake

where.exe pnpm
if ($LASTEXITCODE -eq 1)
{
    Invoke-WebRequest -useb https://get.pnpm.io/install.ps1 | Invoke-Expression
    pnpm env use --global latest
}

WingetInstallPackage -Package gerardog.gsudo
WingetInstallPackage -Package Microsoft.PowerShell
gsudo { pwsh -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted" }

WingetInstallPackage -Package Microsoft.VisualStudioCode
WingetInstallPackage -Package Microsoft.VisualStudio.2022.BuildTools
WingetInstallPackage -Package GitHub.cli
WingetInstallPackage -Package GLab.GLab
WingetInstallPackage -Package RedHat.Podman
WingetInstallPackage -Package WerWolv.ImHex
# WiresharkFoundation.Wireshark
# Hashicorp.Vagrant
# Cloudflare.cloudflared
# scoop flyctl
ScoopInstallPackage -Package vcredist2022
ScoopInstallPackage -Package aws
ScoopInstallPackage -Package llvm
ScoopInstallPackage -Package rustup
ScoopInstallPackage -Package go
ScoopInstallPackage -Package openjdk
ScoopInstallPackage -Package python
ScoopInstallPackage -Package dotnet-sdk
ScoopInstallPackage -Package gcc
ScoopInstallPackage -Package android-clt

sdkmanager 'tools'
sdkmanager 'platform-tools' 'platforms;android-24' 'build-tools;24.0.0' 'ndk-bundle' 'add-ons;addon-google_apis-google-24' 'extras;google;google_play_services' 'emulator'

rustup toolchain install stable-msvc
rustup toolchain install stable-gnu
rustup target add x86_64-pc-windows-msvc
rustup target add x86_64-pc-windows-gnu

python -m ensurepip
python -m pip install -U requests beautifulsoup4 matplotlib pandas ipykernel pdoc3

pnpm install -g vite create-vite commitizen cz-conventional-changelog yarn

[Environment]::SetEnvironmentVariable("JAVA_HOME", "$HOME\scoop\apps\openjdk\current", [EnvironmentVariableTarget]::User)
