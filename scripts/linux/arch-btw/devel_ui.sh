#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    android-studio \
    zed

# paru -S --needed --noconfirm --noupgrademenu --skipreview \
#     wireshark-qt \
#     glade
