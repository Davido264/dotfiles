#!/usr/bin/env bash
set -e
export ASDF_DIR="$HOME/.local/share/asdf"
. "$HOME/.local/share/asdf/asdf.sh"
asdf plugin add nodejs
command -v node && asdf global nodejs system
