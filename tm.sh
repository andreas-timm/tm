#!/usr/bin/env bash
# SPDX-License-Identifier: CC-BY-4.0
# This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) License.
# To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
# Author: Andreas Timm
# Repository: https://github.com/andreas-timm/tm
# Version: 0.5.0
# @sha256sum 0xd8bee9c9bbce10af78d28321a02417454808d3e36549aecd7b0bc49f6dcbeae0
# @eip191signature 0xbcee1fd9890f644bbd7e44d7fb2e714ee06f164416ddf2fd476a9a9bcb1b70cc0e98d8a5fb61d60435869938f6ccaca52b8d33145552d657cb4b8c40f23694911c

MESSAGE=$1

if [ "$MESSAGE" = "-h" ]; then
    echo "Usage: $(basename "$0") <MESSAGE>|->"
    echo "ENVIRONMENT:"
    echo "  MESSAGE_PREFIX"
    echo "  CHAT_ID"
    echo "  API_ID"
    exit 0
fi

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
test -f "$SCRIPT_DIR/.env" && source "$SCRIPT_DIR/.env"
test -f "$HOME/.config/tm/env" && source "$HOME/.config/tm/env"

function checkEnv() { name=$1; [ -z "${!name}" ] && name=$(pass show "tm/$name"); echo -n "${!name}"; }

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
