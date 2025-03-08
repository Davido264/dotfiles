#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

sudo pacman -S --noconfirm --needed openssh

systemctl --user enable --now ssh-agent
# ssh-add ~/.ssh/id_rsa
