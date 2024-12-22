#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

echo '== [ Audio packages and setup ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    pipewire \
    wireplumber \
    pipewire-pulse \
    pipewire-jack \
    pipewire-alsa \
    pavucontrol \
    rtkit \
    realtime-privileges

echo '== [ Install music production packages ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    qjackctl \
    reaper \
    furnace \
    cardinal \
    surge-xt \
    zynaddsubfx \
    giada \
    chowtapemodel-bin \
    vital-synth \
    tal-noisemaker-bin \
    odin2-synthesizer
