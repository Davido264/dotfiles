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

Write-Output "== [ Enabling WSL ] =="
sudo
{
    Enable-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform" -All -NoRestart;
    Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -All -NoRestart;
    Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All -NoRestart;
}

Write-Output "== [ Updating WSL to v2 ] =="
wsl --update
wsl --set-default-version 2

Write-Output "== [ Installing distros ] =="
@( "Ubuntu" ) | % { wsl --install $_ --no-launch }

Write-Output "== [ Setting default distro (Ubuntu) ] =="
wsl --set-default "Ubuntu"

Write-Output "== [ Enabling net forwarding ] =="
sudo { Get-NetIPInterface | where {$_.InterfaceAlias -eq 'vEthernet (WSL)' -or $_.InterfaceAlias -eq 'vEthernet (Default Switch)'} | Set-NetIPInterface -Forwarding Enabled }
