#!/usr/bin/sh

if which apt; then
    sudo apt update -y && sudo apt upgrade -y
    sudo apt install git curl
    sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin
else
    sudo dnf update -y
    sudo dnf install git curl
fi
chezmoi init --apply Davido264

if which apt; then
    sudo apt autoremove -y
fi

# TODO: setup audio
# TODO: setup fedora and ubuntu 

# TODO: How can I update using chezmoi apply?
	# Environment variable flag :D
	# cron job/scheduled task to set an environment variable or tmp file, when this exists, update, else, install
