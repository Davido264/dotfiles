#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    telegram-desktop \
    thunderbird \
    mpv \
    alacritty \
    libreoffice-fresh \
    libreoffice-fresh-es \
    libreoffice-fresh-en-gb \
    obs-studio \
    okular \
    neovide \
    vesktop-bin \
    scrcpy \
    spotify \
    universal-android-debloater

    # krita
    # inkscape
    # blender
    # zoom
    # obsidian
    # drawio-bin
