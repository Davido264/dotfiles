#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

echo '== [ Audio packages and setup ] =='
sudo dnf install -y \
    pipewire \
    wireplumber \
    pipewire-alsa \
    pipewire-pulseaudio \
    pipewire-jack-audio-connection-kit \
    pavucontrol \
    rtkit \
    realtime-setup

echo '== [ Install music production packages ] =='
dnf copr enable -y ycollet/audinux

sudo dnf install -y \
    qjackctl \
    furnace \
    cardinal \
    surge-xt \
    zynaddsubfx \
    odin2 \
    giada \
    AnalogTapeModel \
    vitalium \

flatpak install -y flathub fm.reaper.Reaper

# TODO: TAL Noise Maker, maybe in its own rpm

