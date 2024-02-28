param (
  [switch] $nonWindows
)

if ($nonWindows) {
  $choice = $(ls $HOME/bin,$HOME/.local/share/chezmoi/home/.chezmoiscripts/non-windows/**/*,$HOME/.local/share/chezmoi/home/.chezmoiscripts/non-windows | where extension -notin @(".cmd",".ps1",".vbs",".bat",".psm1",".psd1") | select -expandproperty fullname | fzf)  
} else {
  $choice = $(ls $HOME/bin,$HOME/.local/share/chezmoi/home/.chezmoiscripts/windows/**/*,$HOME/.local/share/chezmoi/home/.chezmoiscripts/windows | where extension -notin @(".sh","",".bash",".zsh") | select -expandproperty fullname | fzf)  
}

if (-not $choice) {
  return;
}

$managed = $(chezmoi managed $choice)

if ($managed) {
  chezmoi edit --apply $choice
} else {
  nvim $choice
}

