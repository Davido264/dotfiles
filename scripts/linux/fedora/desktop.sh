#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

sudo dnf copr enable -y dusansimic/themes
sudo dnf install -y cargo adw-gtk3-theme morewaita-icon-theme
sudo cargo install matugen --root /usr --locked
