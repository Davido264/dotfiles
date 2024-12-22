$ErrorActionPreference = "Stop"

# powershell will only run on windows btw
$Global:OS = 'windows'

$Global:REPO_DIR = if ($Env:CHEZMOI_SOURCE_DIR)
{
    $Env:CHEZMOI_SOURCE_DIR
}
else
{
    Split-Path -Parent (Split-Path -Parent (Get-Item -Path $MyInvocation.MyCommand.Path).FullName)
}

$Global:VENDOR = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty Manufacturer

$Global:VERBOSE = if ($Env:CHEZMOI_SOURCE_DIR)
{
    $Env:CHEZMOI_VERBOSE
}
else if ($env:CHEZMOI_SOURCE_DIR)
{
    $Env:VERBOSE
}
else
{
    0
}

$Global:WINDOWS_DEV = if ($Env:WINDOWS_DEV)
{
    $Env:WINDOWS_DEV
}
else
{
    0
}

$Global:WINDOWS_MUSIC = if ($Env:WINDOWS_MUSIC)
{
    $Env:WINDOWS_MUSIC
}
else
{
    0
}

$Global:CODESPACES = if ($Env:CODESPACES)
{
    $True
}
else
{
    $False
}


if (Test-Path "$SROOT\windows\env_vars.ps1")
{
    . "$SROOT\windows\env_vars.ps1"
}

Export-ModuleMember -Variable OS, REPO_DIR, VENDOR, VERBOSE, WINDOWS_DEV, WINDOWS_MUSIC
