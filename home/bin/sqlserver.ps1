#Requires -RunAs

Param (
    [parameter(ParameterSetName="seta")][switch] $init,
    [parameter(ParameterSetName="setb")][switch] $stop,
    [parameter(ParameterSetName="setc")][switch] $show,
    [parameter(ParameterSetName="setc")][switch] $disableOnStartup,
    [switch] $quiet
)

$names = @(
    "MSSQLSERVER"
    "MSSQL`$REMIX"
    "SQLAgent`$REMIX"
    "SQLBrowser"
    "SQLSERVERAGENT"
    "SQLServerReportingServices"
    "SQLTELEMETRY"
    "SQLTELEMETRY`$REMIX"
    "SQLWriter"
    "postgresql-x64-16"
)

if ($init) {
    if ($quiet) {
        get-service -Name $names | start-service *>1 | Out-Null
    } else {
        write-host "Iniciando los servicios de SqlServer y Postgresql..."
        get-service -Name $names | start-service
        get-service -Name $names | Format-Table -AutoSize
    }
}

if ($stop) {
    if ($quiet) {
        get-service -Name $names | stop-service -Force *>1 | Out-Null
    } else {
        write-host "Deteniendo los servicios de SqlServer..."
        get-service -Name $names | stop-service -Force
        get-service -Name $names | Format-Table -AutoSize
    }
}

if ($show) {
    get-service -Name $names | Format-Table -AutoSize
}

if ($disableOnStartup) {
    if ($quiet) {
        get-service -Name $names | set-service -StartupType Manual *>1 | Out-Null
    } else {
        write-host "Deshabilitando el inicio automático de los servicios de SqlServer y Postgresql..."
        get-service -Name $names | set-service -StartupType Manual
        get-service -Name $names | Select-Object Status,StartType,Name | Format-Table -AutoSize
    }
}
