#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

# dnsmasq         : (opt) required for default NAT/DHCP for guests
# iptables-nft    : (opt) required for default NAT networking
# lvm2            : (opt) Logical Volume Manager support
# openbsd-netcat  : (opt) for remote management over ssh
# sshpass         : (opt) ansible autologin on a vm over ssh
# libosinfo       : osinfo-query command
# osinfo-db-tools : osinfo db tools

echo '== [ VMs ] =='

for g in libvirtd kvm; do
    sudo groupadd -f "$g"
    sudo usermod -aG "$g" "$USER"
done

paru -S --needed --noconfirm --noupgrademenu --skipreview \
    libvirt \
    guestfs-tools \
    libguestfs \
    virt-manager \
    dnsmasq \
    iptables-nft \
    lvm2 \
    openbsd-netcat \
    sshpass \
    libosinfo \
    osinfo-db-tools

if [ "${SUPPORTS_NESTED}" -eq 1 ]; then
    grep -qxF "options $KVM_MOD nested=1" /etc/modprobe.d/nested.conf || sudo tee -a /etc/modprobe.d/nested.conf <<<"options $KVM_MOD nested=1"
fi

sudo sed -i 's/^#\s*\(unix_sock_group = "libvirt"\)/\1/g' /etc/libvirt/libvirtd.conf
sudo sed -i 's/^#\s*\(group =\)"libvirt-qemu"/\1 kvm/g' /etc/libvirt/qemu.conf

echo '== [ Containers ] =='
paru -S --needed --noupgrademenu --noconfirm --skipreview \
    podman \
    podman-compose \
    distrobox

sudo sed -i 's/^#\s*\(unqualified-search-registries\).*$/\1 = ["docker.io"]/g' /etc/containers/registries.conf
