Import-Module "$Env:SROOT/utils.psm1"
Import-Module "$Env:SROOT/vars.psm1"
$ErrorActionPreference = "Stop"

if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

where.exe scoop *>$Null

if ($LASTEXITCODE -eq 1)
{
    Write-Output "== [ Installing scoop ] =="
    Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
    $Env:Path = $Env:Path + ";$HOME\scoop\shims"
}

scoop bucket add extras
scoop bucket add nonportable
scoop bucket add sysinternal

if ($Env:WINDOWS_DEV -eq 1)
{
    scoop bucket add java
    scoop bucket add scoop-clojure https://github.com/littleli/scoop-clojure
}

WingetInstallPackage -Package Git.Git
