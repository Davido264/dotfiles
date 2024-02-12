param (
    [boolean] $WingetUnknown
)

Begin {
    $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
    sudo { Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0 } 
    sudo { Get-Service wuauserv | Set-Service -StartupType Manual | Start-Service } 
    Import-Module "$HOME/bin/envs.psm1"
}
Process {
    Write-Output "Updating all winget apps"
    if ($WingetUnknown) {
        winget upgrade --all --silent --include-unknown
    } else {
        winget upgrade --all --silent
    }

    refreshenv

    Write-Output "Updating all scoop apps"
    sudo { scoop update "android-clt" }
    scoop update *

    refreshenv

    Write-Output "Updating rustup"
    rustup update stable

    refreshenv

    Write-Output "Updating Clink"
    clink update

    refreshenv

    Write-Output "Updating node packages"
    pnpm update -g

    refreshenv

    Write-Output "Updating pip"
    python -m pip install --upgrade pip

    refreshenv

    Write-Output "Reinstalling android sdks"
    sdkmanager "platform-tools" `
        "platforms;android-24" `
        "build-tools;24.0.0" `
        "ndk-bundle" `
        "add-ons;addon-google_apis-google-24" `
        "extras;google;google_play_services" `
        "emulator" `
        "extras;google;Android_Emulator_Hypervisor_Driver"

    refreshenv

    Write-Output "Updating WSL"
    wsl --update

    refreshenv

    Write-Output "Updating Powershell modules"
    Update-Module

    refreshenv

    sudo {
        Import-Module PSWindowsUpdate
        Write-Output "Searching for System Updates"
        if((Get-WUList -MicrosoftUpdate).Count -gt 0) {
            Write-Output "System Updates found..."
            Install-WindowsUpdate -MicrosoftUpdate -AcceptAll
        }
    }
}
End {
    sudo { Stop-Service -Force -Name wuauserv -PassThru | Set-Service -StartupType Disabled } 
    sudo { Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 5 } 
    Restart-Computer -Force
}
