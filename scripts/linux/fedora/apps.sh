#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

sudo dnf install -y \
    telegram-desktop \
    thunderbird \
    mpv \
    alacritty \
    libreoffice \
    libreoffice-langpack-es \
    libreoffice-langpack-en \
    obs-studio \
    okular \
    universal-android-debloater

flatpak install -y flathub \
    dev.vencord.Vesktop \
    in.srev.guiscrcpy \
    com.spotify.Client

# krita
# inkscape
# blender
# zoom
# md.obsidian.Obsidian (flatpak)
# drawio-bin

sudo dnf install -y \
    fontconfig-devel \
    freetype-devel \
    libX11-xcb \
    libX11-devel \
    libstdc++-static \
    libstdc++-devel \
    '@Development Tools' \
    '@Development Libraries' \
    cargo \
    git


if ! command -v neovide; then
    # TODO: Maybe, just maybe. This can be an RPM
    mkdir -p ~/Source/tools
    git clone --depth 1 https://github.com/neovide/neovide ~/Source/tools/neovide

    (
        cd ~/Source/tools/neovide || exit 1
        cargo install --root /usr --lock
    )
fi


# TODO: Maybe, just maybe. This can also be an RPM
if ! command -v universal-android-debloater; then
    dnf install -y android-tools
    t=$(mktemp -d)
    (
        cd "$t" || exit 1
        curl -sL https://github.com/0x192/universal-android-debloater/releases/download/0.5.1/uad_gui-linux.tar.gz | tar -xz
        sudo install -Dm755 . -t '/usr/bin/universal-android-debloater'
        sudo tee -a /usr/share/applications/UniversalAndroidDebloater.desktop <<- EOF
            [Desktop Entry]
            Encoding=UTF-8
            Type=Application
            Terminal=false
            Exec=/usr/bin/universal-android-debloater
            Name=Universal Android Debloater
        EOF
    )
    rm -rf "$t"
fi
