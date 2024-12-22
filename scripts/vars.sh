#!/usr/bin/env bash
set -euo pipefail

declare -r OS=${CHEZMOI_OS:-$(uname -o | tr '[:upper:]' '[:lower:]' | sed 's/gnu\///g')}
declare -r REPO_DIR=${CHEZMOI_SOURCE_DIR:-$(dirname "$(dirname "$(realpath "${BASH_SOURCE[-1]}")")")}
declare -r VERBOSE=${CHEZMOI_VERBOSE:-${VERBOSE:-0}}
declare -r CODESPACES=${CODESPACES:-false}

# if [ -z ${CHASSIS:-} ]; then
#     case "$OS" in
#     "linux") declare -r CHASSIS=$(hostnamectl --json=short | jq '.Chassis') ;;
#     "darwin")
#         if [ "$(sysctl -n hw.model)" = *MacBook* ]; then
#             declare -r CHASSIS='laptop'
#         else
#             declare -r CHASSIS='desktop'
#         fi
#         ;;
#     "android") declare -r CHASSIS='phone' ;;
#     *) echo "WTF" && exit 1 ;;
#     esac
# fi

[ -f "${SROOT}/${OS}/env_vars.sh" ] && source "${SROOT}/${OS}/env_vars.sh"

if [ "$OS" = "linux" ]; then
    declare -r VENDOR=$(grep vendor_id /proc/cpuinfo | uniq | sed 's/vendor_id\s*:\s*//g')

    [ -f /etc/os-release ] && source /etc/os-release
    declare -r OSID="${CHEZMOI_OS_RELEASE_ID:-$ID,,}"

    case "$VENDOR" in
    "GenuineIntel") declare -r KVM_MOD="kvm_intel" ;;
    "AuthenticAMD") declare -r KVM_MOD="kvm_amd" ;;
    *) echo "WTF" && exit 1 ;;
    esac

    nested=$(cat "/sys/module/${KVM_MOD}/parameters/nested")
    if [ "$nested" = "1" ] || [ "$nested" = "Y" ]; then
        declare -r SUPPORTS_NESTED=1
    else
        declare -r SUPPORTS_NESTED=0
    fi

    kernel="$(uname -r)"
    if [ ${kernel,,} = *microsoft* ]; then
        declare -r WSL=1
    else
        declare -r WSL=0
    fi
fi
