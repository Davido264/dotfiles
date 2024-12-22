#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

echo '== [ Install base desktop packages ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    base-devel \
    dbus \
    rtkit \
    polkit \
    xdg-utils \
    xdg-user-dirs \
    python-pyquery \
    python-psutil \
    libnotify \
    pipewire \
    wireplumber \
    pipewire-alsa \
    pipewire-pulse \
    adobe-source-code-pro-fonts \
    noto-fonts-emoji \
    cantarell-fonts \
    ttf-droid \
    ttf-fira-code \
    ttf-jetbrains-mono \
    ttf-jetbrains-mono-nerd \
    ttf-mononoki-nerd \
    otf-comicshanns-nerd \
    kvantum \
    kvantum-qt5 \
    kvantum-theme-libadwaita-git \
    matugen-bin \
    adw-gtk-theme-git \
    morewaita-icon-theme \
    "$video_drivers"

case "$VENDOR" in
"GenuineIntel") video_drivers='xf86-video-intel' ;;
"AuthenticAMD") video_drivers='xf86-video-amdgpu' ;;
*) echo "WTF" && exit 1 ;;
esac

echo "== [ Gnome dark mode ] =="
command -v gsettings && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
command -v gsettings && gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
command -v gsettings && gsettings set org.gnome.desktop.interface icon-theme 'MoreWaita'

echo '== [ Install CUPS (printer) ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    cups \
    cups-pdf \
    cups-browsed \
    libusb \
    ipp-usb \
    xdg-utils \
    colord \
    logrotate


# adobe-source-code-pro-fonts : on fedora
# noto-fonts-emoji            : google-noto-color-emoji-fonts and google-noto-emoji-fonts on fedora
# cantarell-fonts             : abattis-cantarell-fonts on fedora
# ttf-droid                   : google-droid-fonts-all on fedora
# ttf-fira-code               : fira-code-fonts on fedora
# ttf-jetbrains-mono          : jetbrains-mono-fonts-all on fedora
# ttf-jetbrains-mono-nerd     : not on fedora
# ttf-mononoki-nerd           : not on fedora
# otf-comicshanns-nerd        : not on fedora
