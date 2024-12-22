#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

echo '== [ Base setup ] =='

echo '=== [ fast dnf ] ==='
grep -qxF 'max_parallel_downloads=10' || echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
grep -qxF 'fastestmirror=True' || echo 'fastestmirror=True' | sudo tee -a /etc/dnf/dnf.conf

sudo dnf upgrade -y --refresh
sudo dnf update -y

echo '== [ RPM Fusion ] =='
sudo dnf install -y \
    "http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
