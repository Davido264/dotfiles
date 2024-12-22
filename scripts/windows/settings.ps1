Import-Module "$Env:SROOT/utils.psm1"
Import-Module "$Env:SROOT/vars.psm1"
$ErrorActionPreference = "Stop"

if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

Write-Output "== [ Importing registries ] =="
sudo
{
    # TODO: include tweaks.reg here
    reg import "$Global:REPO_DIR/res/windows/tweaks.reg"
}

Write-Output "== [ Setting Event viewer to log dropped packages ] =="
sudo
{
    auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:disable /failure:enable
}

if ($Env:WINDOWS_DEV -eq 1)
{
    Write-Output "`nEnabling Group Policies"
    Get-ChildItem $Env:SystemRoot\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum,$Env:SystemRoot\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum | Select-Object -ExpandProperty FullName | sudo { $input | % { Dism /online /norestart /add-package:$_ }}

    Write-Output "`nEnabling Hyper-V"
    Get-ChildItem $env:SystemRoot\servicing\Packages\*Hyper-V*.mum | Select-Object -ExpandProperty FullName | sudo { $input | % { Dism /online /norestart /add-package:$_ }}
    sudo { Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL /norestart }
}
