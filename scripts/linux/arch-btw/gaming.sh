#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

# TODO: test this 2 commands
grep -qxF "[multilib]" /etc/pacman.conf || sudo sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
grep -qxF "Include = /etc/pacman.d/mirrorlist" /etc/pacman.conf || sudo sed -i 's/#Include\s*=\s*\/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf

case "$VENDOR" in
"GenuineIntel")
    vulkan_intel='vulkan-intel'
    vulkan_intel32='lib32-vulkan-intel'
    ;;
"AuthenticAMD")
    vulkan_intel='vulkan-radeon'
    vulkan_intel32='lib32-vulkan-radeon'
    ;;
*) echo "WTF" && exit 1 ;;
esac

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    pipewire-pulse \
    lib32-gnutls \
    lib32-sdl2 \
    samba \
    vulkan-headers \
    vulkan-icd-loader \
    vulkan-validation-layers \
    vulkan-tools \
    libadwaita \
    "$vulkan_intel" \
    "$vulkan_intel32" \
    mangohud \
    wine

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    lutris \
    prismlauncher \
    osu-lazer-bin

mkdir -p "$HOME/.local/share/icons/lutris"

curl -sSLo "$HOME/.local/share/icons/lutris/an-anime-game-launcher.png" \
    'https://raw.githubusercontent.com/an-anime-team/an-anime-game-launcher/main/assets/images/icon.png'

hash="e2e7bfcf3c09773042372baa158119233d5c2157321f08725ff8c0c313eef774 $HOME/.local/share/icons/lutris/an-anime-game-launcher.png"
if ! sha256sum -c <<<$hash; then
    echo 'installing icon'
fi

# TODO: Install SSF2 (maybe via pkgbuild)
