#!/bin/sh
# SPDX-License-Identifier: BSD-3-Clause
# This source code is licensed under the 3-Clause BSD license found in the LICENSE file in the root directory of this source tree.
# Author: Andreas Timm
# Repository: https://github.com/andreas-timm/tm
# Version: 0.5.2
# @sha256sum 0x4000a379a64b73492c9470f44a513342d3a33f86c115613b4bd0c44a9e244d01
# @eip191signature 0x9b2386206d19e5ad785166986acd914963808a06e80c1a251f80f8f88ab07060431d0496b71545fcec1dc54c6e6caa7dcb6f4f68a0db483e281badf28202f0b91b

MESSAGE=$1

if [ "$MESSAGE" = "-h" ]; then
    echo "Usage: $(basename "$0") <MESSAGE>|->"
    echo "ENVIRONMENT:"
    echo "  MESSAGE_PREFIX"
    echo "  CHAT_ID"
    echo "  API_ID"
    echo "or PASS-NAME: tm/ENVIRONMENT"
    exit 0
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
test -f "$SCRIPT_DIR/.env" && . "$SCRIPT_DIR/.env"
test -f "$HOME/.config/tm/env" && . "$HOME/.config/tm/env"

checkEnv() {
    name=$1
    eval value='$'"$name"
    [ -z "$value" ] && value=$(pass show "tm/$name")
    printf %s "$value"
}

MESSAGE_PREFIX="$(checkEnv MESSAGE_PREFIX)"
CHAT_ID="$(checkEnv CHAT_ID)"
API_ID="$(checkEnv API_ID)"

urlPrefix="https://api.telegram.org/bot${API_ID}/"
maxMessageLength=$((4096 - ${#MESSAGE_PREFIX}))

if [ ! -t 0 ]; then
    MESSAGE=$(cat)
fi

MESSAGE=$(printf 'text=%s%s' "$MESSAGE_PREFIX" "$MESSAGE")
MESSAGE=$(echo "$MESSAGE" | tail -c$maxMessageLength)

curl -sXPOST \
    --url "${urlPrefix}sendMessage" \
    -d "chat_id=$CHAT_ID" \
    -d "parse_mode=MarkdownV2" \
    -d 'link_preview_options={"is_disabled":true}' \
    --data-urlencode "$MESSAGE" \
>/dev/null
