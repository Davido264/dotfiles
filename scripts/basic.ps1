# TODO: See what directories are the equivalents to this in Windows
Write-Output '== [ Creating directories ] =='

Remove-Item "$HOME/Escritorio" -Recurse -Force
Remove-Item "$HOME/Descargas" -Recurse -Force
Remove-Item "$HOME/Plantillas" -Recurse -Force
Remove-Item "$HOME/Público" -Recurse -Force
Remove-Item "$HOME/Documentos" -Recurse -Force
Remove-Item "$HOME/Música" -Recurse -Force
Remove-Item "$HOME/Imágenes" -Recurse -Force
Remove-Item "$HOME/Videos" -Recurse -Force

New-Item -ItemType "directory" "$HOME/Backups"
New-Item -ItemType "directory" "$HOME/Source"
New-Item -ItemType "directory" "$HOME/Desktop"
New-Item -ItemType "directory" "$HOME/Downloads"
New-Item -ItemType "directory" "$HOME/Templates"
New-Item -ItemType "directory" "$HOME/Public"
New-Item -ItemType "directory" "$HOME/Documents"
New-Item -ItemType "directory" "$HOME/Music"
New-Item -ItemType "directory" "$HOME/Pictures"
New-Item -ItemType "directory" "$HOME/Videos"
