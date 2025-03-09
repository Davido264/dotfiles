#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

# There is a packages in arch that setups audio limits, udev rules and create a "realtime" group
echo '== [ realtime group ] =='
sudo groupadd realtime -f
sudo usermod -aG realtime "$USER"

echo '== [ Increase the maximum watches on files (for DAWS) ] =='
[ -f /etc/sysctl.d/10-max_user_watches.conf ] || sudo tee -a /etc/sysctl.d/10-max_user_watches.conf <<<'fs.inotify.max_user_watches=60000'

echo '== [ Swappiness ] =='
[ -f /etc/sysctl.d/90-swappiness.conf ] || sudo tee -a /etc/sysctl.d/90-swappiness.conf <<<'vm.swappiness = 30'

# it seems that in arch, this is already done with the realtime privileges package
if [ "$OSID" != "arch" ]; then
    echo '== [ Modify limits] =='
    [ -f /etc/security/limits.d/10-audio.conf ] || sudo tee -a /etc/security/limits.d/10-audio.conf <<EOF
@audio - rtprio 90
@audio - memlock unlimited
EOF
fi

echo '== [ Audio packages and setup ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    pipewire \
    wireplumber \
    pipewire-pulse \
    pipewire-jack \
    pipewire-alsa \
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
