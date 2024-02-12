#Requires -RunAsAdministrator
Write-Output "Cleaning Recycle Bin"
Clear-RecycleBin -DriveLetter C -Force

Write-Output "Cleaning Scoop apps"
scoop.ps1 cleanup *

Write-Output "Removing items older than 7 days in Downloads folder"
Get-ChildItem $HOME/Downloads | Where-Object LastWriteTime -lt (get-date).AddDays(-7) | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Write-Output "Removing items older than 1 days in TEMP folder"
Get-ChildItem $env:TEMP | Where-Object LastWriteTime -lt (get-date).AddDays(-1) | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Write-Output "Removing all items in Desktop"
Get-ChildItem $HOME/Desktop | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Write-Output "Executing Disk clean"
Start-Process -FilePath CleanMgr.exe -Verb RunAs -ArgumentList '/sagerun:2' -Wait
Restart-Computer -Force
