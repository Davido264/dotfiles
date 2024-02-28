@echo off
pwsh -noprofile -c "Import-Module %~dp0\winwal.psm1; Update-WalTheme %*"
