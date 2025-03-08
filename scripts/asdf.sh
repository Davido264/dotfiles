#!/usr/bin/env bash
set -euo pipefail

asdf_version='v0.14.0'
asdf_dir="$HOME/.local/share/asdf/"

if [ ! -d "$asdf_dir" ]; then
    echo '== [ Install asdf ] =='

    mkdir -p "$asdf_dir"
    git clone https://github.com/asdf-vm/asdf.git "$asdf_dir" --branch $asdf_version

    export ASDF_DATA_DIR="$asdf_dir"
    export ASDF_DIR="$asdf_dir"

    . "$asdf_dir/asdf.sh"
fi
