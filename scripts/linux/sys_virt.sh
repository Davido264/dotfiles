#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

if  [ "${SUPPORTS_NESTED}" -eq 1]; then
    grep -qxF "options $KVM_MOD nested=1" /etc/modprobe.d/nested.conf || sudo tee -a /etc/modprobe.d/nested.conf <<< "options $KVM_MOD nested=1"
fi

sudo sed -i 's/^#\s*\(unix_sock_group = "libvirt"\)/\1/g' /etc/libvirt/libvirtd.conf
sudo sed -i 's/^#\s*\(group = \)"libvirt-qemu"/\1kvm/g' /etc/libvirt/qemu.conf

for g in libvirtd kvm; do
    sudo groupadd -f "$g"
    sudo usermod -aG "$g" "$USER"
done

sudo sed -i 's/^#\s*\(unqualified-search-registries\).*$/\1 = ["docker.io"]' /etc/containers/registries.conf
