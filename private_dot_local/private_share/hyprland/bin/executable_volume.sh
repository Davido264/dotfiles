#!/bin/bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for volume controls for audio and mic

sDIR="$XDG_DATA_HOME/hyprland/bin/"
icon_dir="$XDG_DATA_HOME/hyprland/icons"

# Get Volume
get_volume() {
	volume=$(pamixer --get-volume)
	if [[ "$volume" -eq "0" ]]; then
		echo "Muted"
	else
		echo "$volume%"
	fi
}

# Notify
notify_user() {
	if [[ "$(get_volume)" == "Muted" ]]; then
		icon="$icon_dir/vol-muted.png"
		# notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -i $icon "Volume: Muted"
	else
		icon="$icon_dir/vol-$1.png"
		# notify-send -e -h int:value:"$(get_volume | sed 's/%//')" -h string:x-canonical-private-synchronous:volume_notif -u low -i $icon "Volume: $(get_volume)"
		"$sDIR/sounds.sh" --volume
	fi
}

# Increase Volume
inc_volume() {
	if [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -u && notify_user up
	fi
	pamixer -i 5 && notify_user up
}

# Decrease Volume
dec_volume() {
	if [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -u && notify_user down
	fi
	pamixer -d 5 && notify_user down
}

# Toggle Mute
toggle_mute() {
	if [ "$(pamixer --get-mute)" == "false" ]; then
		icon="$icon_dir/vol-muted.png"
		pamixer -m && notify-send -e -u low -i $icon "Volume Switched OFF"
	elif [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -u && notify-send -e -u low "Volume Switched ON"
	fi
}

# Toggle Mic
toggle_mic() {
	if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
		pamixer --default-source -m && notify-send -e -u low "Microphone Switched OFF"
	elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		pamixer -u --default-source u && notify-send -e -u low "Microphone Switched ON"
	fi
}

# Get Microphone Volume
get_mic_volume() {
	volume=$(pamixer --default-source --get-volume)
	if [[ "$volume" -eq "0" ]]; then
		echo "Muted"
	else
		echo "$volume%"
	fi
}

# Notify for Microphone
notify_mic_user() {
	volume=$(get_mic_volume)
	notify-send -e -h int:value:"$volume" -h "string:x-canonical-private-synchronous:volume_notif" -u low "Mic-Level: $volume"
}

# Increase MIC Volume
inc_mic_volume() {
	if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		pamixer --default-source -u && notify_mic_user
	fi
	pamixer --default-source -i 5 && notify_mic_user
}

# Decrease MIC Volume
dec_mic_volume() {
	if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
		pamixer --default-source -u && notify_mic_user
	fi
	pamixer --default-source -d 5 && notify_mic_user
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
	toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
	get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
	get_mic_icon
elif [[ "$1" == "--mic-inc" ]]; then
	inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
	dec_mic_volume
else
	get_volume
fi
