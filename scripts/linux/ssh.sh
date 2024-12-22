#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

case "$OSID" in
"arch") sudo pacman -S openssh ;;
"fedora") sudo dnf install -y openssh ;;
"debian") sudo apt install -y openssh ;;
*) echo "Not implemented" && exit 1 ;;
esac

systemctl --user enable --now ssh-agent
ssh-add ~/.ssh/id_rsa
