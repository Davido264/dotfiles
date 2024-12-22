#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

# There are __music_rt_system_setup packages in fedora and
# arch, they setups audio limits, udev rules and create a
# "realtime" group
echo '== [ realtime group ] =='
sudo groupadd realtime -f
sudo usermod -aG realtime "$USER"

echo '== [ Increase the maximum watches on files (for DAWS) ] =='
echo 'fs.inotify.max_user_watches=60000' | sudo tee /etc/sysctl.d/10-max_user_watches.conf

echo '== [ Swappiness ] =='
[ -f /etc/sysctl.d/90-swappiness.conf ] || sudo tee /etc/sysctl.d/90-swappiness.conf <<< 'vm.swappiness = 30'

echo '== [ Modify limits] =='
[ -f /etc/security/limits.d/audio.conf ] || sudo tee -a << EOF
@audio - rtprio 90
@audio - memlock unlimited
EOF
