#!/usr/bin/sh

sudo apt update -y && sudo apt upgrade -y
sudo apt install git
sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin
chezmoi init --apply Davido264
sudo apt autoremove -y

# TODO: setup audio

# TODO: How can I update using chezmoi apply?
	# Environment variable flag :D
	# cron job/scheduled task to set an environment variable or tmp file, when this exists, update, else, install
