#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    telegram-desktop \
    thunderbird \
    bitwarden-bin \
    ghostty \
    zen-browser-bin \
    brave-bin \
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

# Zen extra deps
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    ffmpeg \
    networkmanager \
    libnotify \
    pulse-native-provider \
    speech-dispatcher \
    hunspell-en_US

# krita
# inkscape
# blender
# zoom
# obsidian
