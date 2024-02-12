#Requires -RunAsAdministrator
param (
    [parameter(ParameterSetName="seta")][switch] $init,
    [parameter(ParameterSetName="setb")][switch] $stop,
    [parameter(ParameterSetName="setc")][switch] $show,
    [parameter(ParameterSetName="setc")][switch] $enableWSLNet,
    [switch] $quiet
)

$ErrorActionPreference = "Ignore"

$services = @(
    "vmms" # Hyper-V vm management
    "vmcompute" # Compatibility with windows containers and vms
    # "vmicvmsession" # VM mangement with Powershell
    # "vmicguestinterface" # guest interface
    "HvHost" # host service
    "vmickvpexchange" # data exchange
    "vmicheartbeat" # tick sync
    # "vmicvss" # Hyper-V snapshots
)

if ($init) {
    if ($quiet) {
        get-service -Name $services | start-service *>1 | Out-Null
    } else {
        write-host "Iniciando los servicios de Hyper-V..."
        get-service -Name $services | start-service
        get-service -Name $services | Format-Table -AutoSize
    }
}

if ($stop) {
    if ($quiet) {
        get-service -Name $services | stop-service *>1 | Out-Null
    } else {
        write-host "Deteniendo los servicios de Hyper-V..."
        get-service -Name $services | stop-service
        get-service -Name $services | Format-Table -AutoSize
    }
}

if ($show) {
    get-service -Name $services | Format-Table -AutoSize
}

if ($enableWSLNet) {
    get-netipinterface | Where-Object {$_.InterfaceAlias -eq 'vEthernet (WSL)'} | Select-Object ifIndex,InterfaceAlias,ConnectionState,Forwarding
    get-netipinterface | Where-Object {$_.InterfaceAlias -eq 'vEthernet (WSL)'} | Select-Object ifIndex,InterfaceAlias,ConnectionState,Forwarding
    get-netipinterface | Where-Object {$_.InterfaceAlias -eq 'vEthernet (WSL)' -or $_.InterfaceAlias -eq 'vEthernet (Default Switch)'} | Set-NetIPInterface -Forwarding Enabled -Verbose
}

