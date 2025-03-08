#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

if ! "${CODESPACES}"; then
    echo '== [ Creating directories ] =='
    if [ -s "$HOME/.config/user-dirs.dirs" ]; then
        rm -rf "$HOME/Escritorio"
        rm -rf "$HOME/Descargas"
        rm -rf "$HOME/Plantillas"
        rm -rf "$HOME/Público"
        rm -rf "$HOME/Documentos"
        rm -rf "$HOME/Música"
        rm -rf "$HOME/Imágenes"
        rm -rf "$HOME/Videos"
    fi

    [ "$OS" -eq "linux" ] && LC_ALL=C.UTF-8 xdg-user-dirs-update --force

    mkdir -p "$HOME/Backups"
    mkdir -p "$HOME/Source"
fi
