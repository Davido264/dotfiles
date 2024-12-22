#!/usr/bin/env bash
set -e
export ASDF_DIR="$HOME/.local/share/asdf";
. "$HOME/.local/share/asdf/asdf.sh";
asdf plugin add python
{ command -v python || command -v python3 } && asdf global python system
