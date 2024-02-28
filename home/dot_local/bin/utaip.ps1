#Requires -RunAsAdministrator

function restore_configs() {
    $networkInterface = Get-NetAdapter | Where-Object { $_.Name -eq "Ethernet" } | Select-Object -ExpandProperty Name
    $gateway = Get-NetRoute -InterfaceAlias $networkInterface -AddressFamily IPv4 -DestinationPrefix "0.0.0.0/0" | Select-Object NextHop

    $ip = Get-NetIPAddress -InterfaceAlias $networkInterface -AddressFamily IPv4 | Select-Object IPAddress
    Remove-NetIPAddress -IPAddress $ip -Confirm

    Set-DnsClientServerAddress -InterfaceAlias $networkInterface -ResetServerAddresses
    # netsh.exe interface ipv4 set address name=Ethernet source=dhcp > $null
    # netsh.exe interface ipv4 set dns name=Ethernet source=dhcp > $null

    Disable-NetAdapter -Name $networkInterface -Confirm
    Enable-NetAdapter -Name $networkInterface
    Write-Output "Done!"
}

function set_configs($ip) {
    $ip = "192.168.1.100"
    $gateway = $($ip -replace '\.[0-9]+$',".1")

    $networkInterface = Get-NetAdapter | Where-Object { $_.Name -eq "Ethernet" } | Select-Object -ExpandProperty Name

    New-NetIPAddress -InterfaceAlias $networkInterface -IPAddress $ip -PrefixLength 24 -DefaultGateway $gateway
    Set-DnsClientServerAddress -InterfaceAlias $networkInterface -ServerAddresses "10.102.12.2"

    Disable-NetAdapter -Name $networkInterface -Confirm
    Enable-NetAdapter -Name $networkInterface



#  netsh.exe interface ipv4 set address `
#    name=Ethernet `
#    source=static `
#    address=$ip `
#    mask=255.255.255.0 `
#    gateway=$($ip -replace '\.[0-9]+$',".1") `
#    store=active  > $null
#
#  netsh.exe interface ipv4 set dns `
#    name=Ethernet `
#    source=static `
#    address=10.102.12.2 `
#    validate=no > $null

  Write-Output "Done!"
}


if ($args.Length -le 0) {
  restore_configs
} else {
  set_configs $args[0]
}

