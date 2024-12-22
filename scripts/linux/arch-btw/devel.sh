#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

echo '== [ Base packages ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview \
    coreutils \
    curl \
    jq \
    fzf \
    base-devel \
    git \
    direnv \
    github-cli \
    android-tools \
    glab \
    gitleaks \
    lazygit \
    ripgrep \
    tree-sitter-cli \
    neovim \
    tmux

echo '== [ C ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview \
  base-devel \
  gcc \
  glibc \
  clang \
  llvm \
  make \
  cmake \
  autoconf \
  automake \
  gdb

echo '== [ Java ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview jdk21-openjdk jdk8-openjdk
source "${SROOT}/asdf_java.sh"


# echo '== [ .NET ] =='
# paru -S --needed --noconfirm --noupgrademenu --skippreview dotnet-sdk
# source "${SROOT}/asdf_dotnet.sh"


echo '== [ Flutter ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview \
    flutter-bin \
    android-emulator \
    android-sdk-cmdline-tools-latest \
    android-build-tools \
    android-ndk
yes | sdkmanager 'platform-tools' --sdk_root "$HOME/.local/share/android-sdk"


echo '== [ Go ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview go


echo '== [ Javascript ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview \
    nodejs-lts-iron \
    npm \
    pnpm
source "${SROOT}/asdf_node.sh"


echo '== [ Kotlin ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview kotlin


echo '== [ Python ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview \
    python \
    python-setuptools \
    python-pip \
    python-numpy \
    python-pandas \
    python-matplotlib \
    python-ipykernel \
    python-ipympl \
    python-ipywidgets \
    tk \
    xz \
    gcc \
    openssl \
    bzip2 \
    libffi \
    zlib \
    sqlite
source "${SROOT}/asdf_python.sh"


echo '== [ Rust ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview \
    rust \
    rust-src


echo '== [ LaTeX ] =='
paru -S --needed --noconfirm --noupgrademenu --skippreview \
    texlive-basic \
    texlive-bibtexextra \
    texlive-bin \
    texlive-binextra \
    texlive-context \
    texlive-fontsextra \
    texlive-fontsrecommended \
    texlive-fontutils \
    texlive-formatsextra \
    texlive-games \
    texlive-humanities \
    texlive-hyphen-spanish \
    texlive-langspanish \
    texlive-latex \
    texlive-latexextra \
    texlive-latexrecommended \
    texlive-luatex \
    texlive-mathscience \
    texlive-metapost \
    texlive-music \
    texlive-pictures \
    texlive-plaingeneric \
    texlive-pstricks \
    texlive-publishers \
    texlive-xetex \
    python-pygments
