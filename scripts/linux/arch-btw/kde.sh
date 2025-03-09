#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

# TODO: Customize this right

echo '== [ Install Plasma Desktop ] =='
paru -S plasma-desktop \
    --needed \
    --noconfirm \
    --noupgrademenu \
    --skipreview \
    --asdeps \
        $(expac -Ss '%o' plasma-desktop) \
        kdeplasma-addons \
        kcmutils \
        kcmutils5 \
        kde-sdk \
        spectacle \
        kdegraphics-thumbnailers \
        kimageformats \
        icoutils \
        qt5-imageformats \
        qt6-imageformats \
        ffmpegthumbs \
        breeze-grub \
        breeze-gtk \
        breeze-plymouth \
        drkonqi \
        kde-gtk-config \
        ksshaskpass \
        kwallet-pam \
        ocean-sound-theme \
        oxygen-sounds \
        plasma-disks \
        plasma-firewall \
        plasma-nm \
        plasma-pa \
        plasma-sdk \
        plasma-systemmonitor \
        plasma-thunderbolt \
        print-manager \
        phonon-qt6-vlc \
        plymouth-kcm \
        powerdevil \
        sddm-kcm \
        gwenview \
        ark \
        xdg-desktop-portal-kde

command -v flatpak && paru -S --needed --noconfirm --noupgrademenu --skipreview  flatpak-kcm

# filelight, kdf: Disk usage information
echo '== [ Install KDE utilities apps ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    filelight \
    kdf \
    kcharselect \
    skanpage \
    sweeper

# kio-extras: support for Android connected via USB
# kio-extras on kde docs: provides the thumbnailing engine and many thumbnailing plugins, among other things
echo '== [ Install KDE system apps ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    dolphin \
    dolphin-plugins \
    kio-extras \
    kjournald \
    ksystemlog \
    partitionmanager

# echo '== [ Install KDE PIM (try then and decide) apps ] =='
# paru -S --needed --noconfirm --noupgrademenu --skipreview --assume-installed mariadb \
#     akonadi \
#     akonadi-calendar-tools \
#     akonadiconsole \
#     kdepim-addons \
#     korganizer \
#     merkuro \
#     zanshin

# ~/.config/akonadi/akonadiserverrc
# [%General]
# Driver=QSQLITE

echo 'MAYBE THIS WILL FIT MORE ON APPLICATIONS'
echo '== [ Install KDE graphics apps ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    kcolorchooser \
    kolourpaint \

echo '== [ Theming!!! ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    papirus-icon-theme-git \
    tela-icon-theme-kde-accent-git \
    colloid-icon-theme-git \
    fluent-icon-theme-git \
    plasma6-applets-panel-colorizer \
    where-is-my-sddm-theme-git

# klassy-bin ? or klassy-qt5?
# sierrabreeze-kwin-decoration-git
# echo '== [ Install customization modules ] =='
# paru -S --needed --noconfirm --noupgrademenu --skipreview \
#     klassy

# echo '== [ Disable application launcher on Meta key ] =='
# kwriteconfig6 --file kwinrc --group ModifierOnlyShortcuts --key Meta ""

if ! command -v gdm sddm >/dev/null; then
    paru -S --needed --noconfirm --noupgrademenu --skipreview sddm
    sudo systemctl enable --now sddm
fi


if [ "$INCLUDE_MANUAL" = "1" ]; then
    command -v 7z &>/dev/null || paru -S --needed --noconfirm --noupgrademenu --skipreview p7zip
    backup_archive="${REPO_DIR}/res/linux/kde-configs.7z"

    tmp_restore_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_restore_dir"' EXIT

    7z x -aoa -o"$tmp_restore_dir" "$backup_archive"

    CONFIG_DIR="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
    SHARE_DIR="${XDG_DATA_HOME:-"${HOME}/.local/share"}"

    cp -rf "$tmp_restore_dir/kde-configs/.config/"* "$CONFIG_DIR/"
    cp -rf "$tmp_restore_dir/kde-configs/.local/share/"* "$SHARE_DIR/"
    echo "Restauración completada exitosamente."

    SERVICE_FILE="${HOME}/.config/systemd/user/kde-backup.service"
    TIMER_FILE="${HOME}/.config/systemd/user/kde-backup.timer"
    BACKUP_SCRIPT="${HOME}/.local/bin/backup-kde"

    mkdir -p "${HOME}/.config/systemd/user"

    cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=KDE Backup script
After=network.target

[Service]
Type=oneshot
ExecStart=${BACKUP_SCRIPT}
EOF

    cat <<EOF > "$TIMER_FILE"
[Unit]
Description=Ejecutar el respaldo KDE cada mes

[Timer]
OnCalendar=monthly
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now kde-backup.timer
fi

# Not instaled, but recommended by kde docs
# baloo-widgets (provides extra information for Dolphin's Information Panel when the Baloo file indexer is on)
# kde-inotify-survey (warns when apps are using all inotify watches and prompts the user to raise it; this can help users understand why Baloo in particular isn't working properly, and offers them a way to fix it)
# kdeconnect-kde (provides remote mobile phone control; also make sure to whitelist its system service in your firewall, if you ship one)
# kdenetwork-filesharing (provides the Samba file sharing setup wizard)
# kio-admin (provides a safe way to edit files as root)
# kio-fuse (provides transparent access to non-KDE apps for files on remote locations)
# kio-gdrive (provides transparent KIO access to Google Drive)
# kwalletmanager (includes a System Settings KCM for KWallet)
# qqc2-desktop-style (provides a usable theme for QtQuick applications, such as System Settings)
# xwaylandvideobridge
#
# Not Included
# kalk (advanced calculator)
# kcalc (scientific calculator)
# kdialog (display dialogs from shell scripts)
# kfind (find frontend)
# kgpg (gpg frontend)
# kongress (companion app for conferences)
# konsole (kde default terminal)
# khelpcenter
# krdc (Remote desktop client)
# kio-zeroconf (extras for dolphin i guess)
#
# Not included, but on plasma-meta
# discover
# kgamma (gamma settings)
# kinfocenter (help)
# krdp (remote desktop protocol)
# kwrited
# oxygen
# plasma-browser-integration
# plasma-vault
# plasma-welcome
# plasma-workspace-wallpapers
#
# Not installed, recommended by kde and applicable to all desktops
# iio-sensor-proxy
# maliit-keyboard (except for gnome, it comes with its own)
# orca (screen reader, gnome has its own i guess)
# switcheroo-control (provides proper hybrid/multi-GPU detection)
# systemd-coredumpd (Global crash handler for drkonqi. Alternative handlers such as ABRT or apport can be used instead of drkonqi+coredumpd)
#
#
#
#
#
# Other notes form kde docs
# https://community.kde.org/Distributions/Packaging_Recommendations#Proprietary_NVidia_driver_configuration
