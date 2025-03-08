Import-Module "$Env:SROOT/utils.psm1"
Import-Module "$Env:SROOT/vars.psm1"
$ErrorActionPreference = "Stop"

if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

scoop bucket add nerd-fonts

ScoopInstall-Package -Package JetBrainsMono-NF
ScoopInstall-Package -Package SourceCodePro-NF
ScoopInstall-Package -Package Mononoki-NF
