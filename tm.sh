#!/bin/sh
# SPDX-License-Identifier: CC-BY-4.0
# This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) License.
# To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
# Author: Andreas Timm
# Repository: https://github.com/andreas-timm/tm
# Version: 0.5.1
# @sha256sum 0xc9a000ef4e9e21bbc055eb55b08304719464a32b64279d72c86441ebc5e7275f
# @eip191signature 0x130bdef5400634e62c0e75d0c4b5312581ff270dbd51676a1d7726d88632d7000b009ac78f6ff76981b0aed334d96c0f360c6e1d5266761eda1989324acecb071c

MESSAGE=$1

if [ "$MESSAGE" = "-h" ]; then
    echo "Usage: $(basename "$0") <MESSAGE>|->"
    echo "ENVIRONMENT:"
    echo "  MESSAGE_PREFIX"
    echo "  CHAT_ID"
    echo "  API_ID"
    exit 0
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
test -f "$SCRIPT_DIR/.env" && . "$SCRIPT_DIR/.env"
test -f "$HOME/.config/tm/env" && . "$HOME/.config/tm/env"

checkEnv() { name=$1; eval value='$'"$name"; [ -z "$value" ] && name=$(pass show "tm/$name"); printf %s "$value"; }

MESSAGE_PREFIX="$(checkEnv MESSAGE_PREFIX)"
CHAT_ID="$(checkEnv CHAT_ID)"
API_ID="$(checkEnv API_ID)"

urlPrefix="https://api.telegram.org/bot${API_ID}/"
maxMessageLength=$((4096 - ${#MESSAGE_PREFIX}))

(
    printf 'text=%s' "$MESSAGE_PREFIX"

    if [ -t 0 ]; then
        echo "$MESSAGE" | tail -c$maxMessageLength
    else
        cat - | tail -c$maxMessageLength
    fi
)  \
| curl -sXPOST \
    --url "${urlPrefix}sendMessage" \
    -d "chat_id=$CHAT_ID" \
    -d "parse_mode=markdown" \
    --data-binary @- \
>/dev/null
