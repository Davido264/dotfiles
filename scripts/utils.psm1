function WingetInstall-Package([string]$Package) {
  winget list --id $Package *>$null
  if ($LASTEXITCODE -eq 0) { return }
  winget install --id $Package --accept-source-agreements --accept-package-agreements --silent
}

function ScoopInstall-Package([string]$Package) {
  $InstalledPackage = $(scoop.ps1 list $Package) 6> $null
  if ($InstalledPackage -eq $null) { scoop.ps1 install $Package }
}

function Clean-Enviroment([string]$Target) {
  $ExistingPath = [Environment]::GetEnvironmentVariable("PATH", $Target)
  $PathArray = $ExistingPath -split ";"
  $UniquePaths = [System.Collections.Generic.HashSet[string]]::new($PathArray, [StringComparer]::OrdinalIgnoreCase)
  $NewPath = $UniquePaths -join ";"
  [Environment]::SetEnvironmentVariable("PATH", $NewPath, $Target)
}


Export-ModuleMember -Function WingetInstall-Package
Export-ModuleMember -Function ScoopInstall-Package
Export-ModuleMember -Function Clean-Enviroment
