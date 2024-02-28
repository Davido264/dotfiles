function setenv ([string]$key, [string]$value = $null)
{
  if(-not($key))
  { 
    Throw “You must supply a value for -key”
  }

  [Environment]::SetEnvironmentVariable($key,$value,'User')
  Set-Item -Path "Env:$($key)" -Value $value
  Update-SessionEnvironment
}

function Remove-RepeatedDirs() 
{
  $Env:PATH = ( ( ( Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH ).Path -split  ';' | Select-Object -Unique ) -join ';' )
  
  [Environment]::SetEnvironmentVariable("PATH",$Env:PATH,'User')
  [Environment]::SetEnvironmentVariable("PATH",$Env:PATH,'Machine')
}

# All functions bellow are from Chocolatey, a package manager for windows
# https://github.com/chocolatey/choco
# Copyright © 2017 - 2021 Chocolatey Software, Inc.
# Copyright © 2015 - 2017 RealDimensions Software, LLC
# Copyright © 2011 - 2015 RealDimensions Software, LLC & original authors/contributors from https://github.com/chocolatey/chocolatey
function Get-EnvironmentVariable
{
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [Parameter(Mandatory=$true)][string] $Name,
    [Parameter(Mandatory=$true)][System.EnvironmentVariableTarget] $Scope,
    [Parameter(Mandatory=$false)][switch] $PreserveVariables = $false,
    [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
  )

  # Do not log function call, it may expose variable names
  ## Called from chocolateysetup.psm1 - wrap any Write-Host in try/catch

  [string] $MACHINE_ENVIRONMENT_REGISTRY_KEY_NAME = "SYSTEM\CurrentControlSet\Control\Session Manager\Environment\";
  [Microsoft.Win32.RegistryKey] $win32RegistryKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($MACHINE_ENVIRONMENT_REGISTRY_KEY_NAME)
  if ($Scope -eq [System.EnvironmentVariableTarget]::User)
  {
    [string] $USER_ENVIRONMENT_REGISTRY_KEY_NAME = "Environment";
    [Microsoft.Win32.RegistryKey] $win32RegistryKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($USER_ENVIRONMENT_REGISTRY_KEY_NAME)
  } elseif ($Scope -eq [System.EnvironmentVariableTarget]::Process)
  {
    return [Environment]::GetEnvironmentVariable($Name, $Scope)
  }

  [Microsoft.Win32.RegistryValueOptions] $registryValueOptions = [Microsoft.Win32.RegistryValueOptions]::None

  if ($PreserveVariables)
  {
    Write-Verbose "Choosing not to expand environment names"
    $registryValueOptions = [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames
  }

  [string] $environmentVariableValue = [string]::Empty

  try
  {
    #Write-Verbose "Getting environment variable $Name"
    if ($null -ne $win32RegistryKey)
    {
      # Some versions of Windows do not have HKCU:\Environment
      $environmentVariableValue = $win32RegistryKey.GetValue($Name, [string]::Empty, $registryValueOptions)
    }
  } catch
  {
    Write-Debug "Unable to retrieve the $Name environment variable. Details: $_"
  } finally
  {
    if ($null -ne $win32RegistryKey)
    {
      $win32RegistryKey.Close()
    }
  }

  if ( $null -eq $environmentVariableValue -or $environmentVariableValue -eq '')
  {
    $environmentVariableValue = [Environment]::GetEnvironmentVariable($Name, $Scope)
  }

  return $environmentVariableValue
}
function Get-EnvironmentVariableNames([System.EnvironmentVariableTarget] $Scope)
{
  # Do not log function call

  # HKCU:\Environment may not exist in all Windows OSes (such as Server Core).
  switch ($Scope)
  {
    'User'
    {
      Get-Item 'HKCU:\Environment' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property
    }
    'Machine'
    {
      Get-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' | Select-Object -ExpandProperty Property
    }
    'Process'
    {
      Get-ChildItem Env:\ | Select-Object -ExpandProperty Key
    }
    default
    {
      throw "Unsupported environment scope: $Scope"
    }
  }
}

function refreshenv
{
  $userName = $env:USERNAME
  $architecture = $env:PROCESSOR_ARCHITECTURE
  $psModulePath = $env:PSModulePath

  $ScopeList = 'Process', 'Machine'
  if ('SYSTEM', "${env:COMPUTERNAME}`$" -notcontains $userName)
  {
    $ScopeList += 'User'
  }

  foreach ($Scope in $ScopeList)
  {
    Get-EnvironmentVariableNames -Scope $Scope |
      ForEach-Object {
        Set-Item "Env:$_" -Value (Get-EnvironmentVariable -Scope $Scope -Name $_)
      }
  }

  $paths = 'Machine', 'User' |
    ForEach-Object {
      (Get-EnvironmentVariable -Name 'PATH' -Scope $_) -split ';'
    } |
    Select-Object -Unique
  $Env:PATH = $paths -join ';'

  $env:PSModulePath = $psModulePath

  if ($userName)
  {
    $env:USERNAME = $userName;
  }
  if ($architecture)
  {
    $env:PROCESSOR_ARCHITECTURE = $architecture;
  }
}
