# Encoding
[console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# COMMMON
$isNonInteractive = ([Environment]::GetCommandLineArgs().Contains('-NonInteractive')) -or ([Environment]::CommandLine -match '\.ps1') -or (-not [Environment]::UserInteractive) -or ([Environment]::CommandLine -match '-c|-command')

if ($isNonInteractive) {
    return
} 

# Starship
& Invoke-Expression (&starship init powershell)

# Modules
Import-Module "$HOME/bin/winwal.psm1"

# Alias
Set-Alias grep rg
Set-Alias touch New-Item
Set-Alias open Start-Process
Set-Alias bash "C:\Program Files\Git\bin\bash"
Set-Alias which where.exe 

# Envs
$env:HOSTS = "$env:SystemRoot\system32\drivers\etc\hosts"
$env:SSH_CONFIG = "$env:ProgramData\ssh\sshd_config"
$ENV:SHELL = "Windows Powershell"
