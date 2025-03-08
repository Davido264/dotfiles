#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    coreutils \
    curl \
    plocate \
    zip \
    unzip \
    wget \
    jq \
    fzf \
    git \
    rclone \
    bitwarden-cli \
    zoxide \
    gum

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    ripgrep \
    tree-sitter-cli \
    neovim

if ! "${CODESPACES}"; then
    # network or advance system related. On a container I dont see too much sense
    paru -S --needed --noconfirm --noupgrademenu --skipreview \
        lsof \
        traceroute \
        whois \
        dnsutils

    # TODO: See tmux, cmatrix, onefetch
    paru -S --needed --noconfirm --noupgrademenu --skipreview \
        zsh \
        tmux \
        htop \
        btop \
        yt-dlp \
        p7zip \
        pandoc-cli \
        imagemagick \
        eza \
        fastfetch \
        cmatrix \
        onefetch \
        starship

    paru -S --needed --noconfirm --noupgrademenu --skipreview \
        ffmpeg

    [ ${SHELL:-} = "$(which zsh)" ] || chsh -s "$(which zsh)"
fi
