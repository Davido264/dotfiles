if ($Global:VERBOSE -eq 1)
{
    Set-PSDebug -Trace 1
}

Write-Output "`nCreating a restore point"

sudo
{
    Enable-ComputerRestore -Drive "C:\";
    Checkpoint-Computer -Description "Debloat apps and disable task and services" -RestorePointType "APPLICATION_UNINSTALL"
}

Write-Output "`nUninstall Cortana"
sudo { winget uninstall --id 9NFFX4SZZ23L }

Write-Output "`nDebloating"
sudo
{
    @(
        # Unnecessary Windows 10 AppX Apps
        "Microsoft.3DBuilder"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.AppConnector"
        "Microsoft.BingFinance"
        "Microsoft.BingNews"
        "Microsoft.BingSports"
        "Microsoft.BingTranslator"
        "Microsoft.BingWeather"
        "Microsoft.BingFoodAndDrink"
        "Microsoft.BingHealthAndFitness"
        "Microsoft.BingTravel"
        "Microsoft.MinecraftUWP"
        "Microsoft.WindowsReadingList"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.News"
        "Microsoft.Office.Lens"
        "Microsoft.Office.Sway"
        "Microsoft.Office.OneNote"
        "Microsoft.OneConnect"
        "Microsoft.People"
        "Microsoft.Print3D"
        "Microsoft.SkypeApp"
        "Microsoft.Wallet"
        "Microsoft.Whiteboard"
        "microsoft.windowscommunicationsapps"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsPhone"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.ConnectivityStore"
        "Microsoft.CommsPhone"
        "Microsoft.MixedReality.Portal"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
        "Microsoft.GetHelp"
        "Microsoft.MicrosoftOfficeHub"
        "*Microsoft.Advertising.Xaml*"
        "*Microsoft.MSPaint*"
        "*Microsoft.MicrosoftStickyNotes*"
        "Microsoft.ScreenSketch"
        "Microsoft.WindowsFeedbackHub"
        #   "Microsoft.XboxApp"
        #   "Microsoft.XboxGameOverlay"
        #   "Microsoft.XboxGamingOverlay"
        #   "Microsoft.XboxIdentityProvider"
        #   "Microsoft.XboxSpeechToTextOverlay"
        #   "Microsoft.Xbox.TCUI"
        "Microsoft.549981C3F5F10" # Cortana

        # Sponsored Windows 10 AppX Apps
        # Add sponsored/featured apps to remove in the "*AppName*" format
        "*EclipseManager*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        "*Duolingo-LearnLanguagesforFree*"
        "*PandoraMediaInc*"
        "*CandyCrush*"
        "*BubbleWitch3Saga*"
        "*Wunderlist*"
        "*Flipboard*"
        "*Twitter*"
        "*Facebook*"
        "*Royal Revolt*"
        "*Sway*"
        "*Speed Test*"
        "*Dolby*"
        "*Viber*"
        "*ACGMediaPlayer*"
        "*Netflix*"
        "*OneCalendar*"
        "*LinkedInforWindows*"
        "*HiddenCityMysteryofShadows*"
        "*Hulu*"
        "*HiddenCity*"
        "*AdobePhotoshopExpress*"
        "*HotspotShieldFreeVPN*"
        "*Microsoft 365*"
        "*Disney*"
        "*Spotify*"
        "*Messenger*"

        #Optional: Typically not removed but you can if you need to
        # "*Microsoft.Windows.Photos*"
        # "*Microsoft.WindowsCalculator*"
        # "*Microsoft.WindowsStore*"
        # "Microsoft.WindowsAlarms"
        # "Microsoft.WindowsCamera"
        # "Microsoft.YourPhone"
    ) | % {
        Get-AppxPackage -Name $_ | Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $_ | Remove-AppxProvisionedPackage -Online
    }
}

Write-Output "`nSetting unnecesary services to disabled"
sudo
{
    @(
        "WerSvc" # send os errors to Microsoft
        "wisvc" # Windows insider
        "dmwappushservice" # WAP routing service (telemetry)
        "DiagTrack" # Telemetry for UX
        "WpcMonSvc" # Parental control
        #    "XboxGipSvc" # Xbox periferics management
        #    "XboxNetApiSvc" # Xbox Live net service
        #    "XblAuthManager" # Xbox auth
        #    "XblGameSave" # Xbox saved game state
        "WSearch" # Windows Search
        "MapsBroker" # Downloaded Maps Manager
        "diagsvc" # Diagnostic service for Microsoft's official support (only for retail licenses)
        "DPS" # Diagnostic service (Solucionador de problemas)
        "Fax" # Fax
        "fhsvc" # Fax
        "WbioSrvc" # Biometrics service
        "BDESVC" # Bitlocker Drive Encryption Service
        "RetailDemo" # Wanna try retail? 7u7
        "SEMgrSvc" # NFC Payments
        "diagnosticshub.standardcollector.service"
        "WalletService" # wallets?
        "BcastDVRUserService_48486de" # Broadcast videogames
        "edgeupdate" # Microsoft Edge Update
        "edgeupdatem"  # Microsoft Edge Update
        "gupdate" # google apps update
        "gupdatem" # google apps update 
        "PhoneSvc" # Telefony service
        "WMPNetworkSvc" # Windows Media player over the net
        "SCPolicySvc" # Authentication with and ID card
        "SCardSvr" # more ID card stuff
        "VacSvc" # volume for mixed reality (vr i think)
        "MixedRealityOpenXRSvc" # mixed reality (vr i think)
        "RmSvc" # Radio and plane mode
        "wuauserv" # Windows Update
    ) | % {
        Get-Service -Name $_ -ErrorAction SilentlyContinue | Stop-Service -Force -Passthru -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -Passthru 
    }
}

Write-Output "`nSetting not too necesary services to manual"
sudo
{
    @(
        "TabletInputService" # Touch screen
        "lfsvc" # Geolocalization
        "RemoteRegistry" # Remote changing registry
        "Spooler" # Cola de Impresion
        "PrintNotify" # Printer Notifications
        "vmicguestinterface" # Hyper-V guest service
        "HvHost" # Hyper-V host service
        "vmickvpexchange" # Hyper-V data exchange
        "vmicheartbeat" # Hyper-V tick sync
        "vmcompute" # Compatibility with windows containers and vms
        "vmicvmsession" # Hyper-V VM mangement with Powershell
        "vmms" # Hyper-V vm management service
        "vmicvss" # Hyper-V snapshots service
        # "FrameServer" # Windows camera
        # "TokenBroker" # Online Accounts
    ) | % {
        Get-Service -Name $_ -ErrorAction SilentlyContinue | Stop-Service -Force -Passthru -ErrorAction SilentlyContinue | Set-Service -StartupType Manual -Passthru
    }
}


Write-Output "`nDisabling scheduled tasks"
sudo
{
  @(
        @{Name = "Consolidator" ; Path = "\Microsoft\Windows\Customer Experience Improvement Program\"}
        @{Name = "UsbCeip" ; Path = "\Microsoft\Windows\Customer Experience Improvement Program\"}
        @{Name = "Microsoft-Windows-DiskDiagnosticDataCollector" ; Path = "\Microsoft\Windows\DiskDiagnostic\"}
        @{Name = "Microsoft-Windows-DiskDiagnosticResolver" ; Path = "\Microsoft\Windows\DiskDiagnostic\"}
        @{Name = "DmClient" ; Path = "\Microsoft\Windows\Feedback\Siuf\"}
        @{Name = "DmClientOnScenarioDownload" ; Path = "\Microsoft\Windows\Feedback\Siuf\"}
        @{Name = "QueueReporting" ; Path = "\Microsoft\Windows\Windows Error Reporting\"}
        @{Name = "Firefox Default Browser Agent 308046B0AF4A39CB" ; Path = "\Mozilla\"} # Mozilla Updates
        @{Name = "Scheduled Start" ; Path = "\Microsoft\Windows\WindowsUpdate\"} # Windows Update
        @{Name = "MicrosoftEdgeUpdateTaskMachineUA" ; Path = "\"} # MS Edge Update
        @{Name = "MicrosoftEdgeUpdateTaskMachineCore" ; Path = "\"} # MS Edge Update
        @{Name = "GoogleUpdateTaskMachineUA" ; Path = "\"} # Google Chrome/Drive Update
        @{Name = "GoogleUpdateTaskMachineCore" ; Path = "\"} # Google Chrome/Drive Update
        @{Name = "Office Automatic Updates 2.0" ; Path = "\Microsoft\Office"} # MS Office Update
        @{Name = "Office ClickToRun Service Monitor" ; Path = "\Microsoft\Office"} # MS Office Click to Run 
        @{Name = "Office Feature Updates" ; Path = "\Microsoft\Office"} # MS Office Update
        @{Name = "Office Feature Updates Logon" ; Path = "\Microsoft\Office"} # MS Office Update
        @{Name = "Office Performance Monitor" ; Path = "\Microsoft\Office"} # MS Office Monitor 
        @{Name = "Office Serviceability Manager" ; Path = "\Microsoft\Office"} # MS Office Update
        @{Name = "Firefox Background Update 308046B0AF4A39CB" ; Path = "\Mozilla"} # Firefox Update
        @{Name = "Firefox Background Update 308046B0AF4A39CB" ; Path = "\Mozilla"} # Firefox Update
    ) | % {
      Get-ScheduledTask -TaskName $_.Name -TaskPath $_.Path -ErrorAction SilentlyContinue | Disable-ScheduledTask 
    }
}
