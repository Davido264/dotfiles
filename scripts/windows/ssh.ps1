Import-Module "$Env:SROOT/utils.psm1"
Import-Module "$Env:SROOT/vars.psm1"
$ErrorActionPreference = "Stop"

if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

Write-Output "== [ Adding ssh key to agent ] =="
sudo {
    Get-Service -Name ssh-agent | Set-Service -StartupType Manual
    Start-Service ssh-agent
}

# ssh-add $(Resolve-Path "$HOME/.ssh/id_rsa")
