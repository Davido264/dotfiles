#!/usr/bin/env bash
set -euo pipefail

[ "${CHEZMOI:-0}" -eq 1 ] || source "${SROOT}/vars.sh"
[ "${VERBOSE}" -eq 1 ] && set -x

paru -S --noconfirm --noupgrademenu --skipreview --needed \
    linux-zen \
    linux-zen-headers \
    python3 \
    lzip \
    waydroid \
    waydroid-image-gapps

waydroid init -s GAPPS

case "$VENDOR" in
"GenuineIntel") arm_trans="libhoudini" ;;
"AuthenticAMD") arm_trans="libndk" ;;
*) echo "WTF" && exit 1 ;;
esac

mkdir -p "$HOME/Source/tools/waydroid_scripts"
git clone --depth 1 github.com:casualsnek/waydroid_script.git "$HOME/Source/tools/waydroid_scripts"
(
    cd "$HOME/Source/tools/waydroid_scripts" || exit 1
    python -m venv venv
    venv/bin/pip install -r requirements.txt
    sudo venv/bin/python3 main.py hack hidestatusbar
    sudo venv/bin/python3 main.py install "$arm_trans"
)


filenames=$(find ~/.local/share/applications/ -type f -name 'waydroid.*')
for app in $filenames; do
  if ! grep -q 'NoDisplay=true' "$app"; then
    sed -i '/\[Desktop Entry\]/a NoDisplay=true' "$app"
    echo "[*] Added NoDisplay=true to $app"
  fi
done

echo '== [ Modified the selected applications ] =='
update-desktop-database ~/.local/share/applications
