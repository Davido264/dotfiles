#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

if ! "${CODESPACES}"; then
    sudo cp "${REPO_DIR}/res/linux/btkb_homepage_to_esc" /etc/udev/hwdb.d/99-btkb_homepage_to_esc.hwdb
    sudo chown root:root /etc/udev/hwdb.d/99-btkb_homepage_to_esc.hwdb
    sudo chmod 644 /etc/udev/hwdb.d/99-btkb_homepage_to_esc.hwdb

    sudo cp "${REPO_DIR}/res/linux/xkb.layout" /etc/X11/xorg.conf.d/99-keymaps.conf
    sudo chown root:root /etc/X11/xorg.conf.d/99-keymaps.conf
    sudo chmod 644 /etc/X11/xorg.conf.d/99-keymaps.conf

    sudo localectl set-keymap --no-convert us-acentos

    grep -qxF 'NoExtract=etc/xdg/autostart/firewall-applet.desktop' /etc/pacman.conf || sudo sed -i 's/#\(NoExtract\s*=\)/#\1\n\1 etc\/xdg\/autostart\/firewall-applet.desktop/g' /etc/pacman.conf
    [ -f /etc/xdg/autostart/firewall-applet.desktop ] && sudo rm -f /etc/xdg/autostart/firewall-applet.desktop

    paru -S --noconfirm --noupgrademenu --needed --skipreview android-udev
    for group in networkmanager power users wheel; do
        sudo groupadd -f "$group"
        sudo usermod -aG "$group" "$USER"
    done

    for line in \
        'XDG_CONFIG_HOME   DEFAULT=@{HOME}/.config' \
        'XDG_CONFIG_HOME   DEFAULT=@{HOME}/.config' \
        'XDG_CACHE_HOME    DEFAULT=@{HOME}/.cache' \
        'XDG_DATA_HOME     DEFAULT=@{HOME}/.local/share' \
        'XDG_STATE_HOME    DEFAULT=@{HOME}/.local/state'; do
        grep -qxF "$line" /etc/security/pam_env.conf || sudo tee -a /etc/security/pam_env.conf <<<"$line"
    done
fi
