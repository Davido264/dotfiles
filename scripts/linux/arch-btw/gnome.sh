#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

paru -S --needed --noconfirm --noupgrade --skipreview \
    baobab \
    gdm \
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
    gnome-shell \
    gnome-user-share \
    gvfs \
    gvfs-afc \
    gvfs-mtp \
    gvfs-nfs \
    gvfs-smb \
    libgnome-keyring \
    loupe \
    nautilus \
    simple-scan \
    sushi \
    snapshot \
    xdg-desktop-portal-gnome \
    xdg-user-dirs-gtk \
    sound-theme-freedesktop \
    vlc \
    nvtop \
    gnome-tweaks \
    gnome-shell-extension-fullscreen-to-new-workspace-git \
    gnome-shell-extension-caffeine-git

# TODO: Install caffeine and fullscreen-to-new-workspace extensions on fedora

sudo systemctl enable --now gdm

# Not Included
# - gnome-calculator
# - gnome-clocks
# - gnome-connections
# - gnome-console
# - gnome-contacts
# - gnome-maps
# - gnome-music
# - gnome-remote-desktop
# - gnome-software
# - gnome-system-monitor
# - gnome-text-editor
# - gnome-tour
# - gnome-user-docs
# - gnome-weather
# - grilo-plugins
# - gvfs-goa
# - gvfs-gphoto2
# - malcontent
# - tecla
# - orca
# - rygel
# - totem
# - tracker3-miners
# - yelp
