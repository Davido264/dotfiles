#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

case "$VENDOR" in
"GenuineIntel") video_drivers='xf86-video-intel' ;;
"AuthenticAMD") video_drivers='xf86-video-amdgpu' ;;
*) echo "WTF" && exit 1 ;;
esac

# TODO: Dont know whether to keep matugen or not
echo '== [ Install base desktop packages ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    base-devel \
    dbus \
    rtkit \
    polkit \
    xclip \
    python-pyquery \
    python-psutil \
    libnotify \
    nvtop \
    "$video_drivers"

[ "$DE" -ne "kde" ] && paru -S --needed --noconfirm --noupgrademenu --skipreview \
    adw-gtk-theme-git \
    matugen-bin

# TODO: test libadwaita-without-adwaita-git vs libadwaita
# [ "$DE" -eq "kde" ] && paru -S --needed --noconfirm --noupgrademenu --skipreview \
#     libadwaita-without-adwaita-git

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    libadwaita

echo '== [ Install Fonts ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    adobe-source-code-pro-fonts \
    noto-fonts-emoji \
    noto-color-emoji-fontconfig \
    cantarell-fonts \
    ttf-droid \
    ttf-fira-code \
    ttf-jetbrains-mono \
    ttf-jetbrains-mono-nerd \
    ttf-mononoki-nerd \
    otf-comicshanns-nerd

echo "== [ Install Sound stuff ] =="
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    pipewire \
    wireplumber \
    pipewire-alsa \
    pipewire-pulse

echo "== [ Install Generic Portals ] =="
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    xdg-desktop-portal-gtk

echo "== [ XDG utils ] =="
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    xdg-utils \
    xdg-user-dirs \
    xdg-user-dirs-gtk

echo "== [ GTK, Qt, Wayland ] =="
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    kvantum \
    kvantum-qt5 \
    kvantum-theme-libadwaita-git \
    qt5-wayland \
    qt6-5compat \
    qt6-svg \
    qt6-declarative \
    qt6-wayland

[ "$DE" -ne "kde" ] && paru -S --needed --noconfirm --noupgrademenu --skipreview \
    qt5ct \
    qt6ct

echo "== [ Power management stuff ] =="
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    power-profiles-daemon

sudo systemctl enable --now power-profiles-daemon

[ "$DE" -ne "kde" ] && paru -S --needed --noconfirm --noupgrademenu --skipreview \
    upower

echo "== [ Gnome dark mode ] =="
command -v gsettings >/dev/null && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
command -v gsettings >/dev/null && gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
command -v gsettings >/dev/null && gsettings set org.gnome.desktop.interface icon-theme 'MoreWaita'

echo '== [ Install CUPS (printer) ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    cups \
    cups-pdf \
    cups-browsed \
    libusb \
    ipp-usb \
    colord \
    logrotate \
    system-config-printer

echo '== [ Remove CUPS web interface desktop icon ] =='
cups="/usr/share/applications/cups.desktop"
if [ -f "$cups" ]; then
    if ! grep -q 'NoDisplay=true' "$cups"; then
        sudo sed -i '/\[Desktop Entry\]/a NoDisplay=true' "$cups"
        echo "[*] Added NoDisplay=true to $cups"
    fi
fi
