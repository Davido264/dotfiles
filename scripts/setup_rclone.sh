#!/bin/sh

BW_SESSION="$(bw login --raw || bw unlock --raw)"
export BW_SESSION
bw sync

fields="$(bw list items --search client_info:rclone | jq -r '.[0].fields')"
client_id="$(echo "$fields" | jq -r '.[0].value')"
client_secret="$(echo "$fields" | jq -r '.[1].value')"

rclone config create gdrive drive \
	scope "drive" \
	client_id "$client_id" \
	client_secret "$client_secret" \
	config_is_local true
