#!/bin/bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For disabling touchpad.

Touchpad_Device="asue1209:00-04f3:319f-touchpad"

XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

toggle_touchpad() {
	if [ ! -f "$STATUS_FILE" ] || [ "$(cat "$STATUS_FILE")" = "false" ]; then
		echo "true" >"$STATUS_FILE"
		action="enabled"
	else
		echo "false" >"$STATUS_FILE"
		action="disabled"
	fi

	notify-send -u low "Touchpad $action"
	hyprctl keyword "device:$Touchpad_Device:enabled" "$(cat "$STATUS_FILE")"
}

toggle_touchpad

notify-send -u low ":D"
