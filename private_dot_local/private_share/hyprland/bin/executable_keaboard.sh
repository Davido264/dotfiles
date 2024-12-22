#!/usr/bin/sh

print_help() {
	echo "valid options are -connect (connect to device) and -pair (pair and connect)"
}

notify-send foo

# notify-send -h string:x-canonical-private-synchronous:shot-notify -t 1000 "Taking shot in : $sec"
device="54:46:6B:20:35:99"

case "$1" in
"-c")
	bluetoothctl connect $device
	;;
"-p")
	bluetoothctl scan on
	sleep 5
	bluetoothctl pair $device
	sleep 1
	bluetoothctl connect $device
	sleep 1
	bluetoothctl trust $device
	;;
*)
	print_help
	;;
esac
