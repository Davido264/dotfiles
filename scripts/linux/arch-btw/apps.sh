#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    telegram-desktop \
    thunderbird \
    bitwarden-bin \
    ghostty \
    libreoffice-fresh \
    libreoffice-fresh-es \
    libreoffice-fresh-en-gb \
    obs-studio \
    okular \
    neovide \
    vesktop-bin \
    scrcpy \
    spotify \
    vlc \
    universal-android-debloater

echo '== [ Install browsers ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    zen-browser-bin \
    $(expac -Ss '%o' zen-browser-bin) \

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    brave-bin \
    $(expac -Ss '%o' brave-bin) \

# krita
# inkscape
# blender
# zoom
# obsidian
