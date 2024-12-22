#!/bin/bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for Monitor backlights (if supported) using brightnessctl

notification_timeout=500
icon_dir="$XDG_DATA_HOME/hyprland/icons"

# Get brightness
get_backlight() {
	brightnessctl -m | cut -d, -f4
}

# Notify
notify_user() {
	current=$(get_backlight | sed 's/%//')
	icon="$icon_dir/brightness-$1.png"
	# notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$current -u low -i $icon "Brightness : $current%"
}

# Change brightness
change_backlight() {
	brightnessctl set "$1" && notify_user "$2"
}

# Execute accordingly
case "$1" in
"--get")
	get_backlight
	;;
"--inc")
	change_backlight "+10%" up
	;;
"--dec")
	change_backlight "10%-" down
	;;
*)
	get_backlight
	;;
esac
