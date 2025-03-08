Import-Module "$Env:SROOT/utils.psm1"
Import-Module "$Env:SROOT/vars.psm1"
$ErrorActionPreference = "Stop"

if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

WingetInstall-Package -Package Git.Git

WingetInstall-Package -Package gerardog.gsudo
gsudo config CacheMode auto
gsudo cache on

WingetInstall-Package -Package Starship.Starship
WingetInstall-Package -Package sharkdp.bat
WingetInstall-Package -Package junegunn.fzf
WingetInstall-Package -Package sharkdp.fd # find
WingetInstall-Package -Package jqlang.jq

WingetInstall-Package -Package ripgrep
ScoopInstall-Package -Package tree-sitter
WingetInstall-Package -Package Neovim.Neovim

ScoopInstall-Package -Package neo-cowsay
ScoopInstall-Package -Package fastfetch

if (-not $(Test-Path "$HOME\Documents\Powershell\Modules\cmatrix.psm1"))
{
    if (-not $(Test-Path \"$HOME\Documents\PowerShell\Modules\"))
    {
        New-Item -ItemType "directory" "$HOME\Documents\PowerShell\Modules"
    }

    Invoke-WebRequest https://raw.githubusercontent.com/matriex/cmatrix/master/cmatrix.psm1 -OutFile "$HOME\Documents\PowerShell\Modules\cmatrix.psm1"
}

where.exe 7z *> $Null

if ($LASTEXITCODE -eq 1)
{
    ScoopInstall-Package -Package 7zip
    sudo { reg import "$HOME\scoop\apps\7zip\current\install-context.reg" }
}

WingetInstall-Package -Package JohnMacFarlane.Pandoc
WingetInstall-Package -Package MiKTeX.MiKTeX
ScoopInstall-Package -Package ffmpeg
ScoopInstall-Package -Package scrcpy
ScoopInstall-Package -Package yt-dlp

ScoopInstall-Package -Package clink
clink.cmd autorun install

ScoopInstall-Package -Package dos2unix
ScoopInstall-Package -Package file
ScoopInstall-Package -Package charm-gum
ScoopInstall-Package -Package less
ScoopInstall-Package -Package rammap
ScoopInstall-Package -Package autoruns
ScoopInstall-Package -Package regjump

ScoopInstall-Package -Package rclone
