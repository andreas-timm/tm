#!/usr/bin/env bash
# SPDX-License-Identifier: CC-BY-4.0
# This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) License.
# To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
# Author: Andreas Timm
# Repository: https://github.com/andreas-timm/tm
# Version: 0.5.0
# @sha256sum 0x46460d3d235dab6cd2aca7f65d3078cd103b7020a09ee81c12a4510b40cf0919
# @eip191signature 0x0101de4a2908ce689e3242711a5addbd44f1e34b0666459dee58f46f6ea8853b19f772d924e32fe162c45f1641c9d8c428ea9c9149a2b1f113a9eba4047190341b

MESSAGE=$1

if [ "$MESSAGE" = "-h" ]; then
    echo "Usage: $(basename "$0") <MESSAGE>|->"
    echo "ENVIRONMENT:"
    echo "  MESSAGE_PREFIX"
    echo "  CHAT_ID"
    echo "  ID_AUTH"
    exit 0
fi

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
test -f "$SCRIPT_DIR/.env" && source "$SCRIPT_DIR/.env"
test -f "$HOME/.config/tm/env" && source "$HOME/.config/tm/env"

function checkEnv() { name=$1; [ -z "${!name}" ] && name=$(pass show "tm/$name"); echo -n "${!name}"; }

MESSAGE_PREFIX="$(checkEnv MESSAGE_PREFIX)"
CHAT_ID="$(checkEnv CHAT_ID)"
ID_AUTH="$(checkEnv ID_AUTH)"

urlPrefix="https://api.telegram.org/bot${ID_AUTH}/"
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
