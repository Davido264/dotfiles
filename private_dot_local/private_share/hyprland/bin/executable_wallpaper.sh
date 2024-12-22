#!/usr/bin/sh

if ! pgrep swww-daemon 2>/dev/null 1>&2; then
	swww-daemon --format xrgb >/dev/null 2>&1 &
	swww restore
fi
