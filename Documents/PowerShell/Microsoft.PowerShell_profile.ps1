# Encoding
[console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

& Invoke-Expression (&starship init powershell)

# Workspaces and J.D integration
function wcd([string]$id) {
    if (-not $id) {
        $path = $(ws -p)
    } else {
        $path = $(ws $id -p)
    }
    set-location $path
}

function wls([string]$id) {
    if (-not $id) {
        $path = $(ws -p)
    } else {
        $path = $(ws $id -p)
    }
    get-childitem $path
}

# Modules
Import-Module "$HOME/bin/envs.psm1"

# Alias
Set-Alias grep rg
Set-Alias touch New-Item
Set-Alias open Start-Process
Set-Alias bash "C:\Program Files\Git\bin\bash"
Set-Alias android-studio "C:\Program Files\Android\Android Studio\bin\studio64.exe"
Set-Alias visual-studio "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
Set-Alias which where.exe

# Envs
$env:HOSTS = "$env:SystemRoot\system32\drivers\etc\hosts"
$env:SSH_CONFIG = "$env:ProgramData\ssh\sshd_config"
$env:SHELL = "Powershell Core"
