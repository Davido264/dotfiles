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

echo '== [ Containers ] =='
paru -S --needed --noupgrademenu --noconfirm --skipreview \
    podman \
    podman-compose \
    distrobox
