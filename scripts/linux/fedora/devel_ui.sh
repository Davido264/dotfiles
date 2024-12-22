#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

flatpak install -y flathub com.google.AndroidStudio
flatpak install -y flathub dev.zed.Zed
