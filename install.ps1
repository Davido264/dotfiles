winget.exe install --id Git.Git --accept-source-agreements --accept-package-agreements --silent
winget.exe install --id twpayne.chezmoi --accept-source-agreements --accept-package-agreements --silent
winget.exe install --id Python.Python.3.12 --accept-source-agreements --accept-package-agreements --silent

chezmoi.exe init Davido264

python -m ensurepip
python -m pip install -r ~/.local/share/chezmoi/requirements.txt

chezmoi apply

if ($LASTEXITSTATUS -eq 0) {
    echo "changing git remote for dotfiles repo"
    cd ~/.local/share/chezmoi
    git remote set-url origin git@github.com:Davido264/dotfiles.git
    cd -
}
