#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

if command -v yay ; then
    sudo pacman -R yay
fi

sudo pacman -S --noconfirm --needed base-devel bat
mkdir -p ~/Source/tools/paru
git clone --depth 1 https://aur.archlinux.org/paru.git ~/Source/tools/paru

(
    cd ~/Source/tools/paru || exit 1
    makepkg -si
    paru --gendb
)

