#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

echo '== [ Remove yay if present ] =='
command -v yay && sudo pacman -R yay --noconfirm

echo '== [ Install paru if not present ] =='
if ! command -v paru; then
    sudo pacman -S --noconfirm --needed base-devel bat
    mkdir -p ~/Source/tools/paru
    git clone --depth 1 https://aur.archlinux.org/paru.git ~/Source/tools/paru

    (
        cd ~/Source/tools/paru || exit 1
        makepkg -si --needed --noconfirm
        paru --gendb
    )
fi

echo '== [ Install expac (utility to extract package information) ] =='
sudo pacman -S --noconfirm --needed expac
