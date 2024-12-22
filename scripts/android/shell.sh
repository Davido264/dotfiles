#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

pkg install -y \
    coreutils \
    curl \
    zip \
    unzip \
    wget \
    jq \
    fzf \
    git \
    rclone \
    bitwarden-cli \
    zoxide \
    gum \
    zsh \
    yt-dlp \
    pandoc \
    ImageMagick \
    fastfetch \
    cmatrix

pkg install -y \
    ripgrep \
    tree-sitter-cli \
    neovim

chsh -s "$(which zsh)"

curl -sS https://starship.rs/install.sh | sh -- --yes
