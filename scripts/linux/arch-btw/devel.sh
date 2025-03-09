#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

#
# TODO: Instalar las herramientas de línea de comandos mediante la forma oficial (sdkmanager) sale muchísimo mejor y 
# me evito todo tipo de problemas, sólo debo definir las variables de entorno y asegurarme de que sdkmanager las respeta
#
echo '== [ Base packages ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
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

echo '== [ asdf ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview curl git gnupg gawk
source "${SROOT}/asdf.sh"

echo '== [ C/C++ ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    base-devel \
    gcc \
    glibc \
    clang \
    llvm \
    make \
    cmake \
    vcpkg \
    autoconf \
    automake \
    gdb

VCPKG_ROOT="${VCPKG_ROOT:-"$XDG_DATA_HOME/vcpkg"}"
[ -d "$VCPKG_ROOT" ] || mkdir "$VCPKG_ROOT"
(
    cd "$VCPKG_ROOT"
    if git rev-parse --is-inside-work-tree; then
        git -C "$VCPKG_ROOT" pull
    else
        git clone https://github.com/microsoft/vcpkg $VCPKG_ROOT
    fi
)

echo '== [ Java ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview jdk21-openjdk jdk8-openjdk
source "${SROOT}/asdf_java.sh"

# echo '== [ .NET ] =='
# paru -S --needed --noconfirm --noupgrademenu --skipreview dotnet-sdk
# source "${SROOT}/asdf_dotnet.sh"

echo '== [ Android development ] =='
tmp_dir=$(mktemp --directory)
trap "rm -rf '${tmp_dir}'" EXIT
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    android-udev \
    jdk8-openjdk \
    android-sdk-cmdline-tools-latest-dummy \
    android-sdk-build-tools-dummy \
    android-sdk-platform-tools-dummy

paths=(
    '/etc/profile.d/android-emulator.sh' '/etc/profile.d/android-sdk-cmdline-tools-latest.sh'
    '/etc/profile.d/android-sdk-build-tools.sh' '/etc/profile.d/android-ndk.sh'
)

for file in "${paths[@]}"; do
    [ -d "$file" ] && source "$file"
done

curl -sSLo "${tmp_dir}/sdkmanager.zip" 'https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip'
unzip -d"${tmp_dir}" "${tmp_dir}/sdkmanager.zip"
mkdir -p "${ANDROID_SDK_ROOT}/cmdline-tools/"
cp -a "${tmp_dir}/cmdline-tools" "${ANDROID_SDK_ROOT}/cmdline-tools/latest"
rm -rf "${tmp_dir}"

yes | sdkmanager --licenses
yes | sdkmanager 'platform-tools'

echo '== [ Flutter ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    flutter-bin

echo '== [ Go ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview go

echo '== [ Javascript ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
    nodejs-lts-iron \
    npm \
    bun-bin
source "${SROOT}/asdf_node.sh"

echo '== [ Kotlin ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview kotlin

echo '== [ Python ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
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

# echo '== [ Rust ] =='
# paru -S --needed --noconfirm --noupgrademenu --skipreview \
#     rust \
#     rust-src

echo '== [ LaTeX ] =='
paru -S --needed --noconfirm --noupgrademenu --skipreview \
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
