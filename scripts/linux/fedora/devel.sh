#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

echo '== [ Base packages ] =='
sudo dnf install -y \
    coreutils \
    curl \
    jq \
    fzf \
    base-devel \
    git \
    direnv \
    gh \
    android-tools \
    glab \
    gitleaks \
    lazygit \
    ripgrep \
    tree-sitter-cli \
    neovim \
    tmux

echo '== [ C ] =='
sudo dnf install -y \
    '@Development Tools' \
    '@Development Libraries' \
    gcc \
    clang \
    gcc-c++ \
    autoconf \
    automake \
    cmake \
    glibc

echo '== [ Java ] =='
sudo dnf install -y \
  java-21-openjdk-devel \
  java-21-openjdk-headless \
  java-1.8.0-openjdk-devel \
  java-1.8.0-openjdk-headless
source "${SROOT}/asdf_java.sh"


# echo '== [ .NET ] =='
# sudo dnf install -y dotnet
# source "${SROOT}/asdf_dotnet.sh"

echo '== [ Go ] =='
sudo dnf install -y golang


echo '== [ Javascript ] =='
sudo dnf install -y \
    nodejs \
    nodejs-npm \
    pnpm
source "${SROOT}/asdf_node.sh"

echo '== [ Kotlin ] =='
sudo dnf install -y kotlin


echo '== [ Python ] =='
sudo dnf install -y \
    python \
    python3-setuptools \
    python3-pip \
    python3-numpy \
    python3-pandas \
    python3-matplotlib \
    python3-ipykernel \
    python3-ipympl \
    python3-ipywidgets \
    tk-devel \
    xz-devel \
    gcc \
    openssl-devel \
    bzip2-devel \
    libffi-devel \
    zlib-devel \
    sqlite-devel
source "${SROOT}/asdf_python"


echo '== [ Rust ] =='
sudo dnf install -y \
    rust \
    cargo \
    clippy \
    rust-src \
    rustfmt


echo '== [ LaTeX ] =='
sudo dnf install -y \
    texlive-scheme-medium \
    texlive-binarytree \
    texlive-context \
    texlive-hyphen-spanish \
    texlive-latex \
    texlive-luatex \
    texlive-metapost \
    texlive-musical \
    texlive-pstricks \
    texlive-xetex \
    python3-pygments
