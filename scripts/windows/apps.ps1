Import-Module "$Env:SROOT/utils.psm1"
Import-Module "$Env:SROOT/vars.psm1"
$ErrorActionPreference = "Stop"

if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

WingetInstall-Package -Package WhatsApp.WhatsApp
WingetInstall-Package -Package Microsoft.WindowsTerminal

WingetInstall-Package -Package ripgrep
ScoopInstall-Package -Package tree-sitter
WingetInstall-Package -Package Neovim.Neovim
