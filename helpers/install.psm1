function winget-install([string]$app) {
  write-output "Ensuring $app is installed"
  winget list --id $app *>$null
  if ($LASTEXITCODE -eq 0) { return }
  winget install --id $app --accept-source-agreements --accept-package-agreements --silent
}

function scoop-install([string]$app) {
  write-output "Ensuring $app is installed"
  $installed_app = $(scoop.ps1 list $app) 6> $null
  if ($installed_app -eq $null) { scoop.ps1 install $app }
}

function clean-enviroment([string]$target) {
  $existingPath = [Environment]::GetEnvironmentVariable("PATH", $target)
  $pathArray = $existingPath -split ";"
  $uniquePaths = [System.Collections.Generic.HashSet[string]]::new($pathArray, [StringComparer]::OrdinalIgnoreCase)
  $newPath = $uniquePaths -join ";"
  [Environment]::SetEnvironmentVariable("PATH", $newPath, $target)
}


Export-ModuleMember -Function winget-install
Export-ModuleMember -Function scoop-install
Export-ModuleMember -Function clean-enviroment
