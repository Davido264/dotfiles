#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

sudo tee -a /etc/yum.repos.d/charm.repo <<- EOF
[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key
EOF
sudo chmod 644 /etc/yum.repos.d/charm.repo

sudo dnf copr enable -y aptupdate/bitwarden-cli


sudo dnf install -y \
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

sudo dnf install -y \
    ripgrep \
    tree-sitter-cli \
    neovim

"${CODESPACES}" && exit

sudo dnf copr enable -y varlad/onefetch

# network or advance system related. On a container I dont see too much sense
sudo dnf install -y \
    lsof \
    traceroute \
    whois \
    bind-utils

sudo dnf install -y \
    zsh \
    tmux \
    htop \
    btop \
    yt-dlp \
    p7zip \
    pandoc \
    ImageMagick \
    eza \
    fastfetch \
    cmatrix \
    onefetch

chsh -s "$(which zsh)"

curl -sS https://starship.rs/install.sh | sh -- --yes

