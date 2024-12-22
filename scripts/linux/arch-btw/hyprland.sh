#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

# TODO: incorporate Hyprland instalation scripts here

# which dunst && (killall dunst ; sudo dnf uninstall dunst)
# 
# if ! which swaync; then
#     sudo dnf copr enable -y erikreider/SwayNotificationCenter
#     sudo dnf install -y SwayNotificationCenter
# fi
# 
# which system-config-printer || sudo dnf install -y system-config-printer
# 
# which rofi || sudo dnf install -y rofi
# 
# sudo dnf install -y gtk3-devel cairo-devel glib-devel libpng-devel libXcursor-devel
# 
# if ! which xcur2png; then
#     sudo git clone https://github.com/eworm-de/xcur2png.git --depth 1 /usr/src/xcur2png
#     cd ...
#     sudo ./configure --prefix=/usr
#     sudo make
#     sudo make install
# fi
# 
# if ! which nwg-look; then
#     sudo git clone https://github.com/nwg-piotr/nwg-look.git --depth 1 /usr/src/nwg-look
#     cd /usr/src/nwg-look
#     sudo make build && sudo make install
# fi
# 
# if ! which nwg-displays; then
#     sudo git clone https://github.com/nwg-piotr/nwg-displays.git --depth 1 /usr/src/nwg-displays
#     cd /usr/src/nwg-displays
#     sudo ./install.sh
# fi
