#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

echo '== [ VMs ] =='
sudo dnf install -y '@Virtualization' libguestfs-tools virt-top libosinfo

echo '== [ Containers ] =='
dnf install -y podman podman-compose distrobox
