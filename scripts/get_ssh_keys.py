#!/usr/bin/env python3

## Well well, it seems that here python is a better choice

# set -eo pipefail
#
#
# BW_SESSION="$(bw login --raw)"
# export BW_SESSION
#
# bw sync
#
# folderid="$(bw list folders | jq -r '.[] | select(.name == "SSH") | .id')"
#
# items=$(bw list items --folderid="$folderid" \
#     | jq '[.[] | select(.fields.[] | select(.name == "File Name") | length != 0) | { content: .notes, name: (.fields.[] | select(.name == "File Name") | .value) }]' \
#     | jq -r '.[] | "\(.name)|\(.content)"')
#
