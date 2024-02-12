# This module is took from Winwal under the MIT License
# Winwal github: https://github.com/scaryrawr/winwal

<#
.DESCRIPTION
    Updates the desktop wallpaper.
#>
function Set-Wallpaper {
    param(
        # Path to image to set as background, if not set current wallpaper is used
        [Parameter(Mandatory = $true)][string]$Image
    )

    # Trigger update of wallpaper
    # modified from https://www.joseespitia.com/2017/09/15/set-wallpaper-powershell-function/
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class PInvoke
{
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo(UInt32 action, UInt32 iParam, String sParam, UInt32 winIniFlags);
}
"@

    # Setting the wallpaper requires an absolute path, so pass image into resolve-path
    [PInvoke]::SystemParametersInfo(0x0014, 0, $($Image | Resolve-Path), 0x0003) -eq 1
}

function Update-WalCommandPrompt {
    Copy-Item -Path "$HOME/.cache/wal/wal-prompt.ini" -Destination "$schemesDir/wal.ini"
    & ColorTool.exe -q -b wal.ini
}

function Update-WalTerminal {
    if (!(Test-Path -Path "$HOME/.cache/wal/windows-terminal.json")) {
        return
    }

    @(
        # Stable
        "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState", 

        # Preview
        "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState"
    ) | ForEach-Object {
        $terminalDir = "$_"
        $terminalProfile = "$terminalDir/settings.json"

        # This version of windows terminal isn't installed
        if (!(Test-Path $terminalProfile)) {
            return
        }

        Copy-Item -Path $terminalProfile -Destination "$terminalDir/settings.json.bak"

        # Load existing profile
        $configData = (Get-Content -Path $terminalProfile | ConvertFrom-Json) | Where-Object { $_ -ne $null }

        # Create a new list to store schemes
        $schemes = New-Object Collections.Generic.List[Object]

        $configData.schemes | Where-Object { $_.name -ne "wal" } | ForEach-Object { $schemes.Add($_) }
        $walTheme = $(Get-Content "$HOME/.cache/wal/windows-terminal.json" | ConvertFrom-Json)
        $schemes.Add($walTheme)

        # Update color schemes
        $configData.schemes = $schemes

        # Set default theme as wal
        $configData.profiles.defaults | Add-Member -MemberType NoteProperty -Name colorScheme -Value 'wal' -Force

        # Set cursor to foreground color
        $configData.profiles.defaults | Add-Member -MemberType NoteProperty -Name cursorColor -Value $walTheme.foreground -Force

        # Write config to disk
        $configData | ConvertTo-Json -Depth 32 | Set-Content -Path $terminalProfile

        # Chezmoi to track new changes
        chezmoi add --template $terminalProfile 
    }
}

function Update-WalTerminalIcons {
    Add-TerminalIconsColorTheme -Path "~/.cache/wal/wal-icons.psd1"
    Set-TerminalIconsTheme -ColorTheme wal
}

function Update-PywalfoxTheme {
    param (
        [ValidateSet('light', 'dark')]$Color
    )
    $file = "$HOME/.cache/wal/colors.json"
    $(Get-Content $file) -replace "\\","/" | Set-Content $file
    if ( -not $Color ) {
        pywalfox update 
    } else {
        pywalfox $Color
    }
}

<#
  .DESCRIPTION
  Updates default system color theme
#>
function Set-ColorTheme {
    param (
        [Parameter(mandatory=$true)]
        [ValidateSet('light', 'dark')]$Color,
        [ValidateSet('wal', 'colorthief', 'colorz', 'haishoku', 'schemer2')]$Backend = 'haishoku'
    )

    $ErrorActionPreference = 'Stop'
  
    $img = (Get-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name Wallpaper).Wallpaper
    $tempImg = "$env:TEMP/$(Split-Path $img -leaf)"
    # Use temp location, default backgrounds are in a write protected directory
    Copy-Item -Path "$img" -Destination $tempImg

    # Check if pywal fox needs to update
    if (Get-Command pywalfox -ErrorAction SilentlyContinue) {
        Update-PywalfoxTheme $Color
    }


    if ($Color -eq 'light') {
        $useLightMode = 1
        wal -n -e -l -s -t -q -i $tempImg --backend $Backend
    }
    else {
        $useLightMode = 0
        wal -n -e -s -t -q -i $tempImg --backend $Backend
    }

    $theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    Set-ItemProperty -Path $theme -Name AppsUseLightTheme -Value $useLightMode
    Set-ItemProperty -Path $theme -Name SystemUsesLightTheme -Value $useLightMode

    # Update Windows Terminal
    Update-WalTerminal | Out-Null

    # Update prompt defaults
    # Update-WalCommandPrompt

    $file = "$HOME/.cache/wal/colors-wal.vim"
    $file_wsl = "$HOME/.cache/wal/colors-wal-wsl.vim"
    dos2unix -n $file $file_wsl *>$null
  
    # Terminal Icons
    # if (Get-Module -ListAvailable -Name Terminal-Icons) {
    #     Update-WalTerminalIcons
    # }
}

<#
.DESCRIPTION
    Updates wal templates and themes using a new image or the existing desktop image
#>
function Update-WalTheme {
    param(
        [ValidateSet('wal', 'colorthief', 'colorz', 'haishoku', 'schemer2')]$Backend = 'haishoku'
    )

    $img = (Get-ItemProperty -Path 'HKCU:/Control Panel/Desktop' -Name Wallpaper).Wallpaper

    $wallpapers = get-childitem "$HOME/Pictures/wallpapers"
    $Image = $wallpapers | select-object -ExpandProperty FullName | fzf.exe 

    if (($Image) -and ($Image -ne "")) {
     $img = $Image
    }

    # Add our templates to wal configuration
    $tempImg = "$env:TEMP/$(Split-Path $img -leaf)"

    # Use temp location, default backgrounds are in a write protected directory
    Copy-Item -Path $img -Destination $tempImg
    
    # Invoke wal with colorthief backend and don't set the wallpaper (wal will fail)
    $light = $(Get-ItemProperty -Path 'HKCU:/SOFTWARE/Microsoft/Windows/CurrentVersion/Themes/Personalize' -Name AppsUseLightTheme).AppsUseLightTheme
    $pywalfoxExists = Get-Command pywalfox -ErrorAction SilentlyContinue
    $pywalfoxBackFile = "$HOME/.cache/wal/colors.json.drk" 
    $pywalfoxFile = "$HOME/.cache/wal/colors.json"

    if ($pywalfoxExists -and ($light -gt 0)) {
        wal -n -e -s -t -q -i  $tempImg --backend $Backend
        Copy-Item $pywalfoxFile $pywalfoxBackFile
    }

    if ($light -gt 0) {
        wal -n -e -l -s -t -q -i $tempImg --backend $Backend
    } else {
        wal -n -e -s -t -q -i  $tempImg --backend $Backend
    }

    # Set the wallpaper
    if ($Image) {
        Set-Wallpaper -Image $Image | Out-Null
    }

    # Update Windows Terminal
    Update-WalTerminal | Out-Null

    # Update prompt defaults
    # Update-WalCommandPrompt

    # Check if pywal fox needs to update
    if ($pywalfoxExists) {

        if (Test-Path $pywalfoxBackFile) {
            $(get-content $pywalfoxBackFile) -replace "\\","/" | set-content $pywalfoxFile 
        } else {
            $(get-content $pywalfoxFile) -replace "\\","/" | set-content $pywalfoxFile
        }

        pywalfox update
        if ($light -gt 0) {
            pywalfox light
        } else {
            pywalfox dark
        }
    }

    $file = "$HOME/.cache/wal/colors-wal.vim"
    $file_wsl = "$HOME/.cache/wal/colors-wal-wsl.vim"
    dos2unix -n $file $file_wsl *>$null

    # Terminal Icons
    if (Get-Module -ListAvailable -Name Terminal-Icons) {
        Update-WalTerminalIcons
    }

    $firefox = "C:\Program Files\Firefox Developer Edition\firefox.exe"
    Copy-Item $HOME/.cache/wal/phone_main.html C:/Users/david/workspaces/personal/html_to_image/index.html -Force
    Copy-Item $HOME/.cache/wal/phone_lockscreen.html C:/Users/david/workspaces/personal/html_to_image/index_2.html -Force
    Start-Process $firefox -ArgumentList '-screenshot','file://C:/Users/david/workspaces/personal/html_to_image/index.html','--window-size="720,1600"' -Wait
    Move-Item screenshot.png "C:/Users/david/workspaces/personal/html_to_image/main.png" -Force
    rclone copy "C:/Users/david/workspaces/personal/html_to_image/main.png" google:/
    Start-Process $firefox -ArgumentList '-screenshot','file://C:/Users/david/workspaces/personal/html_to_image/index_2.html','--window-size="720,1600"' -Wait
    Move-Item screenshot.png "C:/Users/david/workspaces/personal/html_to_image/lockscreen.png" -Force
    rclone copy "C:/Users/david/workspaces/personal/html_to_image/lockscreen.png" google:/
}
