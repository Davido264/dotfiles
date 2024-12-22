#!/bin/bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for keyboard backlights (if supported) using brightnessctl

icon_dir="$XDG_DATA_HOME/hyprland/icons"

# Get keyboard brightness
get_kbd_backlight() {
	brightnessctl -d '*::kbd_backlight' -m | cut -d, -f4
}

# Notify
notify_user() {
	icon="$icon_dir/brightness-$1.png"
	notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$current -u low -i $icon "Keyboard Brightness : $current%"
}

# Change brightness
change_kbd_backlight() {
	brightnessctl -d *::kbd_backlight set "$1" && notify_user "$2"
}

# Execute accordingly
case "$1" in
"--get")
	get_kbd_backlight
	;;
"--inc")
	change_kbd_backlight "+30%" up
	;;
"--dec")
	change_kbd_backlight "30%-" down
	;;
*)
	get_kbd_backlight
	;;
esac
