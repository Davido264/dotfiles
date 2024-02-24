winget.exe install --id Git.Git --accept-source-agreements --accept-package-agreements --silent
winget.exe install --id twpayne.chezmoi --accept-source-agreements --accept-package-agreements --silent
chezmoi.exe init --apply Davido264

if ($LASTEXITSTATUS -eq 0) {
    echo "changing git remote for dotfiles repo"
    cd ~/.local/share/chezmoi
    git remote set-url origin git@github.com:Davido264/dotfiles.git
    cd -
}
