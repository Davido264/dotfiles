#!/bin/bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for refreshing waybar, rofi, swaync, pywal colors

# Kill already running processes
_ps=(ags rofi)
for _prs in "${_ps[@]}"; do
	if pidof "${_prs}" >/dev/null; then
		pkill "${_prs}"
	fi
done

sleep 0.3
# Relaunch ags
ags >/dev/null 2>&1 &

exit 0
