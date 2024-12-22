#!/usr/bin/env bash
set -eu

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

termux-storage-setup

pkg upgrade -y
pkg install -y openssl openssh

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
