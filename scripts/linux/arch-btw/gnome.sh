#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    baobab \
    gnome-backgrounds \
    gnome-calendar \
    gnome-characters \
    gnome-color-manager \
    gnome-control-center \
    gnome-disk-utility \
    gnome-font-viewer \
    gnome-keyring \
    gnome-logs \
    gnome-menus \
    gnome-session \
    gnome-settings-daemon \
    gnome-system-monitor \
    gnome-shell \
    gnome-user-share \
    libgnome-keyring \
    simple-scan \
    snapshot \
    gnome-tweaks \
    xdg-desktop-portal-gnome \
    gnome-shell-extension-fullscreen-to-new-workspace-git \
    gnome-shell-extension-caffeine-git

echo '== [ Nautilus packages ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    nautilus \
    loupe \
    sushi \
    gvfs \
    gvfs-afc \
    gvfs-mtp \
    gvfs-nfs \
    gvfs-smb \
    gvfs-dnssd \
    gvfs-wsdd

if ! command -v gdm sddm >/dev/null; then
    paru -S --needed --noconfirm --noupgrademenu --skipreview gdm
    sudo systemctl enable --now gdm
fi


# Not Included
# - decibels (audio player)
# - evince (pdf viewer)
# - gnome-software
# - gnome-calculator
# - gnome-clocks
# - gnome-connections
# - gnome-console
# - gnome-contacts
# - gnome-maps
# - gnome-music
# - gnome-remote-desktop
# - gnome-software
# - gnome-text-editor
# - gnome-tour
# - gnome-user-docs
# - gnome-weather
# - grilo-plugins
# - malcontent
# - tecla
# - orca
# - rygel
# - totem
# - tracker3-miners
# - yelp
