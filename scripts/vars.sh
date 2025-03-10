#!/usr/bin/env bash
set -euo pipefail

assert()
{
    if [ "$1" != "$2" ]; then
        echo "$3" >&2
        exit 1
    fi
}

if [ -z "$CHEZMOI_SOURCE_DIR" ]; then
    script_dir=$(cd "$SROOT/.." &>/dev/null && pwd)
    declare -r REPO_DIR=${script_dir}
else
    declare -r SROOT="${CHEZMOI_SOURCE_DIR}/scripts"
    declare -r REPO_DIR=${CHEZMOI_SOURCE_DIR}
fi

declare -r OS=${CHEZMOI_OS:-$(uname -o | tr '[:upper:]' '[:lower:]' | sed 's/gnu\///g')}
declare -r VERBOSE=${CHEZMOI_VERBOSE:-${VERBOSE:-0}}
declare -r CODESPACES=${CODESPACES:-false}
declare -r DE=${DE:-"gnome"}

if [ -e "$REPO_DIR/.first-time-done" ]; then
    _m=0
else
    _m=1
fi

declare -r INCLUDE_MANUAL=${INCLUDE_MANUAL:-${_m}}

[ "${CHEZMOI:-0}" -eq 0 ] && declare -r CHEZMOI=1

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
    osid="${CHEZMOI_OS_RELEASE_ID:-${ID,,}}"
    id_like="${ID_LIKE:-""}"

    if [ "$osid" != "arch" ]; then
        assert "$id_like" "arch" "Noooooo this is not arch D:<"
        declare -r OSID="arch"
    else
        declare -r OSID=${osid}
    fi

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
