#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

echo '== [ Bluethoot utils ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    bluez \
    bluez-utils \
    blueman

echo '== [ Screenshot utils ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    slurp \
    grim \
    swappy

echo '== [ Audio utils ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    pamixer \
    pavucontrol \
    playerctl

echo '== [ Hyprland pkgs ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    yad \
    xdg-desktop-portal-hyprland \
    hypridle \
    hyprlock \
    network-manager-applet \
    sound-theme-freedesktop \
    nwg-look \
    nwg-displays \
    swww \
    pyprland \
    rofi-wayland \
    mako \
    waybar \
    brightnessctl \
    hyprland-qt-support \
    hyprpolkitagent \
    hyprcursor \
    hyprsunset \
    hyprsysteminfo \
    hyprland

echo '== [ Hyprland official plugins ] =='
yes | hyprpm update
yes | hyprpm add https://github.com/hyprwm/hyprland-plugins.git
yes | hyprpm add https://github.com/DreamMaoMao/hycov
hyprpm reload

hyprpm enable hycov
hyprpm enable hyprbars

echo '== [ Gnome pkgs (tmp) ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    gnome-keyring \
    libgnome-keyring \
    gnome-calendar \
    gnome-characters \
    gnome-disk-utility \
    gnome-font-viewer

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
    paru -S --needed --noconfirm --noupgrademenu --skipreview sddm
    sudo systemctl enable --now sddm
fi

# From Ansible
#    - name: Install AGS deps
#      community.general.pacman:
#        name:
#          - upower
#          - gnome-bluetooth-3.0
#          - gvfs
#          - libdbusmenu-gtk3
#          - sass
#          - brightnessctl
#        state: present
#
#    - name: Install AGS (AUR)
#      become: true
#      become_user: '{{ ansible_user }}'
#      kewlfft.aur.aur:
#        name:
#          - libastal-4-git
#          - libastal-apps-git
#          - libastal-auth-git
#          - libastal-battery-git
#          - libastal-bluetooth-git
#          - libcava
#          - libastal-cava-git
#          - libastal-greetd-git
#          - libastal-hyprland-git
#          - libastal-mpris-git
#          - libastal-network-git
#          - libastal-notifd-git
#          - libastal-powerprofiles-git
#          - libastal-river-git
#          - libastal-tray-git
#          - libastal-wireplumber-git
#          - libastal-git
#          - aylurs-gtk-shell
#        state: present

