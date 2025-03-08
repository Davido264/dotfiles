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
    lazygit \
    git \
    rclone \
    bitwarden-cli \
    zoxide \
    gum \
    fastfetch \
    cmatrix

pkg install -y \
    ripgrep \
    tree-sitter-cli \
    neovim

pkg install -y openssl python python-pip

pip install yt-dlp

[ ${SHELL:-} = "$(which zsh)" ] || chsh -s "$(which zsh)"

curl -sS https://starship.rs/install.sh | sh -s -- --yes
