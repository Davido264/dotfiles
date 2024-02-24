#!/usr/bin/sh

if which apt; then
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install git curl
else
    echo '=== [ fast dnf ] ==='
    printf 'max_parallel_downloads=10\nfastestmirror=True\n' | sudo tee -a /etc/dnf/dnf.conf
    sudo dnf upgrade -y --refresh
    sudo dnf update -y
    echo '=== [rpm fusion (free and non-free)] ==='
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y git curl
fi

sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin
chezmoi init --apply Davido264

if [ $? -eq 0 ]; then
    if which apt; then
        sudo apt autoremove -y
    fi
    echo "changing git remote for dotfiles repo"
    cd ~/.local/share/chezmoi
    git remote set-url origin git@github.com:Davido264/dotfiles.git
    cd -
fi

# TODO: setup audio
# TODO: setup fedora and ubuntu 

# TODO: How can I update using chezmoi apply?
	# Environment variable flag :D
	# cron job/scheduled task to set an environment variable or tmp file, when this exists, update, else, install
