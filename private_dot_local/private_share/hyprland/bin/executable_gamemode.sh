#!/bin/bash

SCRIPTSDIR="$XDG_DATA_HOME/hyprland/bin"

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ]; then
	hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:passes 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
	swww kill
	notify-send -e -u low "Gamemode: enabled. All animations off"
	exit
else
	swww-daemon --format xrgb >/dev/null 2>&1 &
	swww restore
	sleep 0.5
	${SCRIPTSDIR}/refresh.sh
	notify-send -e -u normal "Gamemode: disabled. All animations normal"
fi
hyprctl reload
