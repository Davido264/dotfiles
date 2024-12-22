#!/usr/bin/env bash
set -e
export ASDF_DIR="$HOME/.local/share/asdf"
. "$HOME/.local/share/asdf/asdf.sh"
asdf plugin add dotnet
command -v dotnet && asdf global dotnet system
